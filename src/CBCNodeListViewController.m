/*
 Copyright 2016-present Google Inc. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "CBCNodeListViewController.h"

#import "CBCCatalogExample.h"
#import "private/CBCRuntime.h"

@interface CBCNode()
@property(nonatomic, strong, nullable) NSMutableDictionary *map;
@property(nonatomic, strong, nullable) Class exampleClass;
@end

@implementation CBCNode {
  NSMutableArray *_children;
}

- (instancetype)initWithTitle:(NSString *)title {
  self = [super init];
  if (self) {
    _title = [title copy];
    self.map = [NSMutableDictionary dictionary];
    _children = [NSMutableArray array];
    CBCFixViewDebuggingIfNeeded();
  }
  return self;
}

- (NSComparisonResult)compare:(CBCNode *)otherObject {
  return [self.title compare:otherObject.title];
}

- (void)addChild:(CBCNode *)child {
  self.map[child.title] = child;
  [_children addObject:child];
}

- (void)finalizeNode {
  _children = [[_children sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
}

#pragma mark Public

- (BOOL)isExample {
  return self.exampleClass != nil;
}

- (NSString *)exampleViewControllerName {
  NSAssert(self.exampleClass != nil, @"This node has no associated example.");
  return NSStringFromClass(_exampleClass);
}

- (UIViewController *)createExampleViewController {
  NSAssert(self.exampleClass != nil, @"This node has no associated example.");
  return CBCViewControllerFromClass(self.exampleClass, self.metadata);
}

- (NSString *)exampleDescription {
  NSString *description = [self.metadata objectForKey:CBCDescription];
  if (description != nil && [description isKindOfClass:[NSString class]]) {
    return description;
  }
  return nil;
}

- (NSURL *)exampleRelatedInfo {
  NSURL *relatedInfo = [self.metadata objectForKey:CBCRelatedInfo];
  if (relatedInfo != nil && [relatedInfo isKindOfClass:[NSURL class]]) {
    return relatedInfo;
  }
  return nil;
}

- (BOOL)isPrimaryDemo {
  id isPrimaryDemo;
  if ((isPrimaryDemo = [self.metadata objectForKey:CBCIsPrimaryDemo]) != nil) {
    return [isPrimaryDemo boolValue];
  }
  return NO;
}

- (BOOL)isPresentable {
  id isPresentable;
  if ((isPresentable = [self.metadata objectForKey:CBCIsPresentable]) != nil) {
    return [isPresentable boolValue];
  }
  return NO;
}

@end

@implementation CBCNodeListViewController

- (instancetype)initWithNode:(CBCNode *)node {
  NSAssert(!self.node.isExample, @"%@ cannot represent example nodes.",
           NSStringFromClass([self class]));

  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _node = node;

    self.title = self.node.title;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView =
      [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
  self.tableView.autoresizingMask =
      (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  NSIndexPath *selectedRow = self.tableView.indexPathForSelectedRow;
  if (selectedRow) {
    [[self transitionCoordinator] animateAlongsideTransition:^(id context) {
      [self.tableView deselectRowAtIndexPath:selectedRow animated:YES];
    }
        completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
          if ([context isCancelled]) {
            [self.tableView selectRowAtIndexPath:selectedRow
                                        animated:NO
                                  scrollPosition:UITableViewScrollPositionNone];
          }
        }];
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [self.tableView flashScrollIndicators];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return (NSInteger)[self.node.children count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
  if (!cell) {
    cell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
  }
  cell.textLabel.text = [self.node.children[(NSUInteger)indexPath.row] title];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CBCNode *node = self.node.children[(NSUInteger)indexPath.row];
  UIViewController *viewController = nil;
  if ([node isExample]) {
    viewController = [node createExampleViewController];
  } else {
    viewController = [[[self class] alloc] initWithNode:node];
  }
  [self.navigationController pushViewController:viewController animated:YES];
}

@end

static void CBCAddNodeFromBreadCrumbs(CBCNode *tree,
                                      NSArray<NSString *> *breadCrumbs,
                                      Class aClass,
                                      NSDictionary *metadata) {
  // Walk down the navigation tree one breadcrumb at a time, creating nodes along the way.

  CBCNode *node = tree;
  for (NSUInteger ix = 0; ix < [breadCrumbs count]; ++ix) {
    NSString *title = breadCrumbs[ix];
    BOOL isLastCrumb = ix == [breadCrumbs count] - 1;

    // Don't walk the last crumb
    if (node.map[title] && !isLastCrumb) {
      node = node.map[title];
      continue;
    }

    CBCNode *child = [[CBCNode alloc] initWithTitle:title];
    [node addChild:child];
    child.metadata = metadata;
    if ([[child.metadata objectForKey:CBCIsPrimaryDemo] boolValue] == YES) {
      node.metadata = child.metadata;
    }
    if ([[child.metadata objectForKey:CBCIsDebug] boolValue] == YES) {
      tree.debugLeaf = child;
    }
    node = child;
  }

  node.exampleClass = aClass;
}

static CBCNode *CBCCreateTreeWithOnlyPresentable(BOOL onlyPresentable) {
  NSArray *allClasses = CBCGetAllCompatibleClasses();
  NSArray *filteredClasses = [allClasses filteredArrayUsingPredicate:
                    [NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
    NSDictionary *metadata = CBCCatalogMetadataFromClass(object);
    id breadcrumbs = [metadata objectForKey:CBCBreadcrumbs];
    BOOL validObject =  breadcrumbs != nil && [breadcrumbs isKindOfClass:[NSArray class]];
    if (onlyPresentable) {
      validObject &= ([[metadata objectForKey:CBCIsPresentable] boolValue] == YES);
    }
    return validObject;
  }]];

  CBCNode *tree = [[CBCNode alloc] initWithTitle:@"Root"];
  for (Class aClass in filteredClasses) {
    // Each example view controller defines its own breadcrumbs (metadata[CBCBreadcrumbs]).
    NSDictionary *metadata = CBCCatalogMetadataFromClass(aClass);
    NSArray *breadCrumbs = [metadata objectForKey:CBCBreadcrumbs];
    if ([[breadCrumbs firstObject] isKindOfClass:[NSString class]]) {
      CBCAddNodeFromBreadCrumbs(tree, breadCrumbs, aClass, metadata);
    } else if ([[breadCrumbs firstObject] isKindOfClass:[NSArray class]]) {
      for (NSArray<NSString *> *parallelBreadCrumb in breadCrumbs) {
        CBCAddNodeFromBreadCrumbs(tree, parallelBreadCrumb, aClass, metadata);
      }
    }
  }

  // Perform final post-processing on the nodes.
  NSMutableArray *queue = [NSMutableArray arrayWithObject:tree];
  while ([queue count] > 0) {
    CBCNode *node = [queue firstObject];
    [queue removeObjectAtIndex:0];
    [queue addObjectsFromArray:node.children];

    [node finalizeNode];
  }

  return tree;
}

CBCNode *CBCCreateNavigationTree(void) {
  return CBCCreateTreeWithOnlyPresentable(NO);
}

CBCNode *CBCCreatePresentableNavigationTree(void) {
  return CBCCreateTreeWithOnlyPresentable(YES);
}

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

#import <UIKit/UIKit.h>

@class CBCNode;

/**
 An instance of CBCNodeListViewController is able to represent a non-example CBCNode instance as a
 UITableView.
 */
@interface CBCNodeListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

/** Initializes a CBCNodeViewController instance with a non-example node. */
- (nonnull instancetype)initWithNode:(nonnull CBCNode *)node;

- (nonnull instancetype)initWithStyle:(UITableViewStyle)style NS_UNAVAILABLE;

@property(nonatomic, strong, nonnull) UITableView *tableView;

/** The node that this view controller must represent. */
@property(nonatomic, strong, nonnull, readonly) CBCNode *node;

@end

/**
 Returns the root of a CBCNode tree representing the complete catalog navigation hierarchy.

 Only classes that implement +catalogBreadcrumbs and return at least one breadcrumb will be part of
 the tree.
 */
FOUNDATION_EXTERN CBCNode *_Nonnull CBCCreateNavigationTree(void);

/**
 Returns the root of a CBCNode tree representing only the presentable catalog navigation hierarchy.

 Only classes that implement +catalogIsPresentable with a return value of YES,
 and +catalogBreadcrumbs and return at least one breadcrumb will be part of the tree.
 */
FOUNDATION_EXTERN CBCNode *_Nonnull CBCCreatePresentableNavigationTree(void);

/**
 A node describes a single navigable page in the Catalog by Convention.

 A node either has children or it is an example.

 - If a node has children, then the node should be represented by a list of some sort.
 - If a node is an example, then the example controller can be instantiated with
   createExampleViewController.
 */
@interface CBCNode : NSObject

/** Nodes cannot be created by clients. */
- (nonnull instancetype)init NS_UNAVAILABLE;

/** The title for this node. */
@property(nonatomic, copy, nonnull, readonly) NSString *title;

/** The description for this node. */
@property(nonatomic, copy, nonnull, readonly) NSString *nodeDescription;

/** The children of this node. */
@property(nonatomic, strong, nonnull) NSArray<CBCNode *> *children;

/**
 The example you wish to debug as the initial view controller.
 If there are multiple examples with catalogIsDebug returning YES
 the debugLeaf will hold the example that has been iterated on last
 in the hierarchy tree.
 */
@property(nonatomic, strong, nullable) CBCNode *debugLeaf;

/** Returns YES if this is an example node. */
- (BOOL)isExample;

/**
 Returns YES if this the primary demo for this component.

 Can only return YES if isExample also returns YES.
 */
- (BOOL)isPrimaryDemo;

/** Returns YES if this is a presentable example.  */
- (BOOL)isPresentable;

/** Returns String representation of exampleViewController class name if it exists */
- (nullable NSString *)exampleViewControllerName;

/**
 Returns an instance of a UIViewController for presentation purposes.

 Check that isExample returns YES before invoking.
 */
- (nonnull UIViewController *)createExampleViewController;

/**
 Returns a description of the example.

 Check that isExample returns YES before invoking.
 */
- (nonnull NSString *)exampleDescription;

@end

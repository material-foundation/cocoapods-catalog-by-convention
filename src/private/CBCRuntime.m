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

#import "CBCRuntime.h"
#import "CBCCatalogExample.h"
#import <objc/runtime.h>

#pragma mark Class Invocations

__attribute__((deprecated))
static NSArray<NSString *> *CBCCatalogBreadcrumbsFromClass(Class aClass) {
  return [aClass performSelector:@selector(catalogBreadcrumbs)];
}

__attribute__((deprecated))
static BOOL CBCCatalogIsPrimaryDemoFromClass(Class aClass) {
  BOOL isPrimary = NO;
  if ([aClass respondsToSelector:@selector(catalogIsPrimaryDemo)]) {
    isPrimary = [aClass catalogIsPrimaryDemo];
  }
  return isPrimary;
}

__attribute__((deprecated))
static BOOL CBCCatalogIsPresentableFromClass(Class aClass) {
  BOOL isPresentable = NO;
  if ([aClass respondsToSelector:@selector(catalogIsPresentable)]) {
    isPresentable = [aClass catalogIsPresentable];
  }
  return isPresentable;
}

__attribute__((deprecated))
static BOOL CBCCatalogIsDebugLeaf(Class aClass) {
  BOOL isDebugLeaf = NO;
  if ([aClass respondsToSelector:@selector(catalogIsDebug)]) {
    isDebugLeaf = [aClass catalogIsDebug];
  }
  return isDebugLeaf;
}

__attribute__((deprecated))
static NSURL *CBCRelatedInfoFromClass(Class aClass) {
  NSURL *catalogRelatedInfo = nil;
  if ([aClass respondsToSelector:@selector(catalogRelatedInfo)]) {
    catalogRelatedInfo = [aClass catalogRelatedInfo];
  }
  return catalogRelatedInfo;
}

__attribute__((deprecated))
static NSString *CBCDescriptionFromClass(Class aClass) {
  NSString *catalogDescription = nil;
  if ([aClass respondsToSelector:@selector(catalogDescription)]) {
    catalogDescription = [aClass catalogDescription];
  }
  return catalogDescription;
}

__attribute__((deprecated))
static NSString *CBCStoryboardNameFromClass(Class aClass) {
  NSString *catalogStoryboardName = nil;
  if ([aClass respondsToSelector:@selector(catalogStoryboardName)]) {
    catalogStoryboardName = [aClass catalogStoryboardName];
  }
  return catalogStoryboardName;
}

__attribute__((deprecated))
static NSDictionary *CBCConstructMetadataFromMethods(Class aClass) {
  NSMutableDictionary *catalogMetadata = [NSMutableDictionary new];
  if ([aClass respondsToSelector:@selector(catalogBreadcrumbs)]) {
    [catalogMetadata setObject:CBCCatalogBreadcrumbsFromClass(aClass) forKey:@"breadcrumbs"];
    [catalogMetadata setObject:[NSNumber numberWithBool:CBCCatalogIsPrimaryDemoFromClass(aClass)]
                        forKey:@"primaryDemo"];
    [catalogMetadata setObject:[NSNumber numberWithBool:CBCCatalogIsPresentableFromClass(aClass)]
                        forKey:@"presentable"];
    [catalogMetadata setObject:[NSNumber numberWithBool:CBCCatalogIsDebugLeaf(aClass)]
                        forKey:@"debug"];
    NSURL *relatedInfo;
    if ((relatedInfo = CBCRelatedInfoFromClass(aClass)) != nil) {
      [catalogMetadata setObject:CBCRelatedInfoFromClass(aClass) forKey:@"relatedInfo"];
    }
    NSString *description;
    if ((description = CBCDescriptionFromClass(aClass)) != nil) {
      [catalogMetadata setObject:CBCDescriptionFromClass(aClass) forKey:@"description"];
    }
    NSString *storyboardName;
    if ((storyboardName = CBCStoryboardNameFromClass(aClass)) != nil) {
      [catalogMetadata setObject:CBCStoryboardNameFromClass(aClass) forKey:@"storyboardName"];
    }
  }
  return catalogMetadata;
}

NSDictionary *CBCCatalogMetadataFromClass(Class aClass) {
  NSDictionary *catalogMetadata;
  if ([aClass respondsToSelector:@selector(catalogMetadata)]) {
    catalogMetadata = [aClass catalogMetadata];
  } else {
    catalogMetadata = CBCConstructMetadataFromMethods(aClass);
  }
  return catalogMetadata;
}

#pragma mark Runtime enumeration

NSArray<Class> *CBCGetAllCompatibleClasses(void) {
  int numberOfClasses = objc_getClassList(NULL, 0);
  Class *classList = (Class *)malloc((size_t)numberOfClasses * sizeof(Class));
  objc_getClassList(classList, numberOfClasses);

  NSMutableArray<Class> *classes = [NSMutableArray array];

  NSSet *ignoredClasses = [NSSet setWithArray:@[
    @"SwiftObject", @"Object", @"FigIrisAutoTrimmerMotionSampleExport", @"NSLeafProxy"
  ]];
  NSArray *ignoredPrefixes = @[ @"Swift.", @"_", @"JS", @"WK" ];

  for (int ix = 0; ix < numberOfClasses; ++ix) {
    Class aClass = classList[ix];
    NSString *className = NSStringFromClass(aClass);
    if ([ignoredClasses containsObject:className]) {
      continue;
    }
    BOOL hasIgnoredPrefix = NO;
    for (NSString *prefix in ignoredPrefixes) {
      if ([className hasPrefix:prefix]) {
        hasIgnoredPrefix = YES;
        break;
      }
    }
    if (hasIgnoredPrefix) {
      continue;
    }
    if (![aClass isSubclassOfClass:[UIViewController class]]) {
      continue;
    }
    [classes addObject:aClass];
  }

  free(classList);

  return classes;
}

NSArray<Class> *CBCClassesRespondingToSelector(NSArray<Class> *classes, SEL selector) {
  NSMutableArray<Class> *filteredClasses = [NSMutableArray array];
  for (Class aClass in classes) {
    if ([aClass respondsToSelector:selector]) {
      [filteredClasses addObject:aClass];
    }
  }
  return filteredClasses;
}

#pragma mark UIViewController instantiation

UIViewController *CBCViewControllerFromClass(Class aClass, NSDictionary *metadata) {
  if ([metadata objectForKey:@"storyboardName"]) {
    NSString *storyboardName = [metadata objectForKey:@"storyboardName"];
    NSBundle *bundle = [NSBundle bundleForClass:aClass];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:bundle];
    NSCAssert(storyboard, @"expecting a storyboard to exist at %@", storyboardName);
    UIViewController *vc = [storyboard instantiateInitialViewController];
    NSCAssert(vc, @"expecting a initialViewController in the storyboard %@", storyboardName);
    return vc;
  }
  return [[aClass alloc] init];
}

#pragma mark Fix View Debugging

void CBCFixViewDebuggingIfNeeded(void) {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Method original = class_getInstanceMethod([UIView class], @selector(viewForBaselineLayout));
    class_addMethod([UIView class], @selector(viewForFirstBaselineLayout),
                    method_getImplementation(original), method_getTypeEncoding(original));
    class_addMethod([UIView class], @selector(viewForLastBaselineLayout),
                    method_getImplementation(original), method_getTypeEncoding(original));
  });
}

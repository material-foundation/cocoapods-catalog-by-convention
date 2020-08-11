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

#pragma mark Metadata keys

NSString *const CBCBreadcrumbs    = @"breadcrumbs";
NSString *const CBCIsDebug        = @"debug";
NSString *const CBCDescription    = @"description";
NSString *const CBCIsPresentable  = @"presentable";
NSString *const CBCIsPrimaryDemo  = @"primaryDemo";
NSString *const CBCRelatedInfo    = @"relatedInfo";
NSString *const CBCStoryboardName = @"storyboardName";

#pragma mark Class invocations

static NSArray<NSString *> *CBCCatalogBreadcrumbsFromClass(Class aClass) {
  return [aClass performSelector:@selector(catalogBreadcrumbs)];
}

static BOOL CBCCatalogIsPrimaryDemoFromClass(Class aClass) {
  BOOL isPrimary = NO;
  if ([aClass respondsToSelector:@selector(catalogIsPrimaryDemo)]) {
    isPrimary = [aClass catalogIsPrimaryDemo];
  }
  return isPrimary;
}

static BOOL CBCCatalogIsPresentableFromClass(Class aClass) {
  BOOL isPresentable = NO;
  if ([aClass respondsToSelector:@selector(catalogIsPresentable)]) {
    isPresentable = [aClass catalogIsPresentable];
  }
  return isPresentable;
}

static BOOL CBCCatalogIsDebugLeaf(Class aClass) {
  BOOL isDebugLeaf = NO;
  if ([aClass respondsToSelector:@selector(catalogIsDebug)]) {
    isDebugLeaf = [aClass catalogIsDebug];
  }
  return isDebugLeaf;
}

static NSURL *CBCRelatedInfoFromClass(Class aClass) {
  NSURL *catalogRelatedInfo = nil;
  if ([aClass respondsToSelector:@selector(catalogRelatedInfo)]) {
    catalogRelatedInfo = [aClass catalogRelatedInfo];
  }
  return catalogRelatedInfo;
}

static NSString *CBCDescriptionFromClass(Class aClass) {
  NSString *catalogDescription = nil;
  if ([aClass respondsToSelector:@selector(catalogDescription)]) {
    catalogDescription = [aClass catalogDescription];
  }
  return catalogDescription;
}

static NSString *CBCStoryboardNameFromClass(Class aClass) {
  NSString *catalogStoryboardName = nil;
  if ([aClass respondsToSelector:@selector(catalogStoryboardName)]) {
    catalogStoryboardName = [aClass catalogStoryboardName];
  }
  return catalogStoryboardName;
}

static NSDictionary *CBCConstructMetadataFromMethods(Class aClass) {
  NSMutableDictionary *catalogMetadata = [NSMutableDictionary new];
  if ([aClass respondsToSelector:@selector(catalogBreadcrumbs)]) {
    [catalogMetadata setObject:CBCCatalogBreadcrumbsFromClass(aClass) forKey:CBCBreadcrumbs];
    [catalogMetadata setObject:[NSNumber numberWithBool:CBCCatalogIsPrimaryDemoFromClass(aClass)]
                        forKey:CBCIsPrimaryDemo];
    [catalogMetadata setObject:[NSNumber numberWithBool:CBCCatalogIsPresentableFromClass(aClass)]
                        forKey:CBCIsPresentable];
    [catalogMetadata setObject:[NSNumber numberWithBool:CBCCatalogIsDebugLeaf(aClass)]
                        forKey:CBCIsDebug];
    NSURL *relatedInfo;
    if ((relatedInfo = CBCRelatedInfoFromClass(aClass)) != nil) {
      [catalogMetadata setObject:CBCRelatedInfoFromClass(aClass) forKey:CBCRelatedInfo];
    }
    NSString *description;
    if ((description = CBCDescriptionFromClass(aClass)) != nil) {
      [catalogMetadata setObject:CBCDescriptionFromClass(aClass) forKey:CBCDescription];
    }
    NSString *storyboardName;
    if ((storyboardName = CBCStoryboardNameFromClass(aClass)) != nil) {
      [catalogMetadata setObject:CBCStoryboardNameFromClass(aClass) forKey:CBCStoryboardName];
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

static BOOL IsSubclassOfClass(Class aClass, Class parentClass) {
  Class iterator = class_getSuperclass(aClass);
  while (iterator) {
    if (iterator == parentClass) {
      return YES;
    }
    iterator = class_getSuperclass(iterator);
  }
  return NO;
}

NSArray<Class> *CBCGetAllCompatibleClasses(void) {
  int numberOfClasses = objc_getClassList(NULL, 0);
  Class *classList = (Class *)malloc((size_t)numberOfClasses * sizeof(Class));
  objc_getClassList(classList, numberOfClasses);

  NSMutableArray<Class> *classes = [NSMutableArray array];

  NSSet *ignoredClasses = [NSSet setWithArray:@[
    @"SwiftObject", @"Object", @"FigIrisAutoTrimmerMotionSampleExport", @"NSLeafProxy"
  ]];
  NSArray *ignoredPrefixes = @[ @"Swift.", @"_", @"JS", @"WK", @"PF", @"NS" ];

  Class viewControllerClass = [UIViewController class];

  for (int ix = 0; ix < numberOfClasses; ++ix) {
    Class aClass = classList[ix];

    if (!IsSubclassOfClass(aClass, viewControllerClass)) {
      continue;
    }

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
  if ([metadata objectForKey:CBCStoryboardName]) {
    NSString *storyboardName = [metadata objectForKey:CBCStoryboardName];
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

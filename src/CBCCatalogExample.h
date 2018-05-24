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

#import <Foundation/Foundation.h>

/**
 The CBCCatalogExample protocol defines methods that examples are expected to implement in order to
 customize their location and behavior in the Catalog by Convention.

 Examples should not formally conform to this protocol. Examples should simply implement these
 methods by convention.
 */
@protocol CBCCatalogExample <NSObject>

/**
 Returns a dictionary with metaata information for the example.
 */
+ (nonnull NSDictionary<NSString *, NSObject *> *)catalogMetadata;

@optional

/** Return a list of breadcrumbs defining the navigation path taken to reach this example. */
+ (nonnull NSArray<NSString *> *)catalogBreadcrumbs
  __attribute__((deprecated("use catalogMetadata[CBCBreadcrumbs] instead.")));

/**
 Return a BOOL stating whether this example should be treated as the primary demo of the component.
 */
+ (BOOL)catalogIsPrimaryDemo
  __attribute__((deprecated("use catalogMetadata[CBCIsPrimaryDemo] instead.")));;

/**
 Return a BOOL stating whether this example is presentable and should be part of the catalog app.
 */
+ (BOOL)catalogIsPresentable
  __attribute__((deprecated("use catalogMetadata[CBCIsPresentable] instead.")));

/**
 Return a BOOL stating whether this example is in debug mode and should appear as the initial view controller.
 */
+ (BOOL)catalogIsDebug
  __attribute__((deprecated("use catalogMetadata[CBCIsDebug] instead.")));

/**
 Return the name of a UIStoryboard from which the example's view controller should be instantiated.
 */
- (nonnull NSString *)catalogStoryboardName
  __attribute__((deprecated("use catalogMetadata[CBCStoryboardName] instead.")));

/** Return a description of the example. */
- (nonnull NSString *)catalogDescription
  __attribute__((deprecated("use catalogMetadata[CBCDescription] instead.")));

/** Return a link to related information or resources. */
- (nonnull NSURL *)catalogRelatedInfo
  __attribute__((deprecated("use catalogMetadata[CBCRelatedInfo] instead.")));

@end

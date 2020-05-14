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
#import <UIKit/UIKit.h>

#pragma mark Class invocations

/** Invokes +catalogMetadata on the class and returns the NSDictionary value */
FOUNDATION_EXTERN NSDictionary *CBCCatalogMetadataFromClass(Class aClass);

#pragma mark Runtime enumeration

/** Returns all Objective-C and Swift classes available to the runtime. */
FOUNDATION_EXTERN NSArray<Class> *CBCGetAllCompatibleClasses(void);

/** Returns an array of classes that respond to a given static method selector. */
FOUNDATION_EXTERN NSArray<Class> *CBCClassesRespondingToSelector(NSArray<Class> *classes,
                                                                 SEL selector);

/**
 Internal helper method that allows invoking aClass with selector and puts
 the return value in retValue.
 */
void CBCCatalogInvokeFromClassAndSelector(Class aClass, SEL selector, void *retValue);

#pragma mark UIViewController instantiation

/**
 Creates a view controller instance from the provided class.

 If the provided class implements +(NSString *)catalogStoryboardName, a UIStoryboard instance will
 be created with the returned name. The returned view controller will be instantiated by invoking
 -instantiateInitialViewController on the UIStoryboard instance.
 */
FOUNDATION_EXTERN UIViewController *CBCViewControllerFromClass(Class aClass, NSDictionary *metadata);

#pragma mark Fix View Debugging

/**
 Fixes View Debugging in Xcode when running on iOS 8 and below. See
 http://stackoverflow.com/questions/36313850/debug-view-hierarchy-in-xcode-7-3-fails
 */
FOUNDATION_EXTERN void CBCFixViewDebuggingIfNeeded(void);

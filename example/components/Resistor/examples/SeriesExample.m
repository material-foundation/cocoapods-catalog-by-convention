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

#import "Resistor.h"

#import <UIKit/UIKit.h>

@interface SeriesExample : UIViewController
@end

@implementation SeriesExample

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"Series";
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor whiteColor];
}

@end

@implementation SeriesExample (CatalogByConvention)

+ (NSArray<NSArray<NSString *> *> *)catalogBreadcrumbs {
  return @[ @[ @"Resistor", @"Series"], @[ @"Film", @"Series" ], @[@"Botany", @"Series"] ];
}

+ (NSURL *)catalogRelatedInfo {
  return [[NSURL alloc] initWithString:@"https://www.google.com/search?q=series"];
}

@end

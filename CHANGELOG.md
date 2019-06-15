# 2.5.2

Fix a runtime crash that occurred when built and run under Catalyst (iPad app for Mac).

# 2.5.1

Fix a runtime crash that occurred when the PhotoFoundation framework was included in an app.

## Source changes

* [Ignore PhotoFoundation classes in the runtime lookup (#31)](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/2e8866dcd15ed6a3e755c054510333438802e0a6) (featherless)

# 2.5.0

There is now a new `NSDictionary` property in `CBCNode` called metadata. It is meant to store all the information regarding an example
rather than using separate methods as previously done. With that said, we offer backwards compatibility and still allow the usage of methods to provide example information.

Before:
```
+ (NSArray *)catalogBreadcrumbs {
  return @[ @"Activity Indicator", @"Activity Indicator" ];
}

+ (NSString *)catalogDescription {
  return @"Activity Indicator is a visual indication of an app loading content. It can display how "
         @"long an operation will take or visualize an unspecified wait time.";
}

+ (BOOL)catalogIsPrimaryDemo {
  return YES;
}

+ (BOOL)catalogIsPresentable {
  return YES;
}
```

After:
```
+ (NSDictionary *)catalogMetadata {
  return @{@"breadcrumbs": @[ @"Activity Indicator", @"Activity Indicator" ],
           @"description": @"Activity Indicator is a visual indication of an app loading content. It can display how "
           @"long an operation will take or visualize an unspecified wait time.",
           @"primaryDemo": @YES,
           @"presentable": @YES};
}
```

## Source changes

 * [added a new metadata property that will hold all the key/values for that node. Also code refactoring (#27)](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/6c44e443e98bb87c955663c45c1245921338de1e) (Yarden Eitan)

## API changes

#### CBCBreadcrumbs

*new* constant: `CBCBreadcrumbs`

#### CBCNode

*new* property: `metadata` in `CBCNode`

*removed* property: `nodeDescription` in `CBCNode`

*modified* method: `-exampleDescription` in `CBCNode`

| Type of change: | Swift declaration |
|---|---|
| From: | `func exampleDescription() -> String` |
| To: | `func exampleDescription() -> String?` |

*modified* method: `-exampleDescription` in `CBCNode`

| Type of change: | Declaration |
|---|---|
| From: | `- (nonnull NSString *)exampleDescription;` |
| To: | `- (nullable NSString *)exampleDescription;` |

#### CBCRelatedInfo

*new* constant: `CBCRelatedInfo`

#### CBCIsDebug

*new* constant: `CBCIsDebug`

#### CBCIsPresentable

*new* constant: `CBCIsPresentable`

#### CBCIsPrimaryDemo

*new* constant: `CBCIsPrimaryDemo`

#### CBCDescription

*new* constant: `CBCDescription`

#### CBCStoryboardName

*new* constant: `CBCStoryboardName`

# 2.4.1

 Add `exampleRelatedInfo` to the CBCNode header for external invocation.

 ## Source changes

 * [add exampleRelatedInfo to header file (#26)](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/57edd7f16ea7ec40d62378faacbc95071310bfbc) (Yarden Eitan)

# 2.4.0

- Now you can add the method `catalogRelatedInfo` that returns an NSURL to your example, if you wish to link to related information and resources.
- A performance improvement when fetching all viable classes to build the navigation tree.

## Source changes

* [Add "related info" URLs to examples (#24)](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/ee57bf7bb544b105c5d91aaa2ef348d0f663a690) (Adrian Secord)
* [[Runtime] Only select UIViewController subclasses (#22)](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/ce864aabf505978a3933a93bfcf048f5d41bc071) (Robert Moore)

# 2.3.1

 minor bug fix introduced in 2.3.0 that returns wrong boolean values.

 ## Source changes

 * [PR fixes introduced a minor bug, need to update release (#20)](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/6be4d710a05dbe981728af00700e20268ca548a9) (Yarden Eitan)

# 2.3.0

This minor release adds two new functionalities that support our new Dragons app.

## New features

It's now possible to call `CBCCreatePresentableNavigationTree` to create a navigation tree that only consists of examples that implement the `catalogIsPresentable` method and return `YES` to it.
`CBCNode` now has a new property called `debugLeaf` which is also a `CBCNode`. If an example implements the `catalogIsDebug` method and returns `YES`, then that example will become the
`debugLeaf`. When the `debugLeaf` is set, then in the Dragons app it will become the initial view controller in the navigation. NOTE: If there are multiple examples that return `YES` to
`catalogIsDebug` then the last class that is parsed while going through the hierarchy is the one to be set as the `debugLeaf`.

## Source changes

* [Additional functionality to CbC to support Dragons (#19)](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/67c6d97e80c465d5915dc6dff4c6c19f53627bb8) (Yarden Eitan)

## Non-source changes

* [Remove arc support. (#18)](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/1fcaf777143b7906958b1cccc3a861320c45ce36) (featherless)
* [Bump the kokoro runner version to v2.1.1.](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/a49bf18bc839f86879473329a85f7939e0b115c8) (Jeff Verkoeyen)
* [Replace Carthage support with bazel support (#17)](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/dc45a1a6ef5ad92325ee2799b76920375141dacc) (featherless)

# 2.2.0

This minor release introduces support for Carthage.

## New features

It's now possible to define multiple paths to a single example. Simply return an array of arrays
of breadcrumbs from the `catalogBreadcrumbs` implementation.

## Source changes

* [added ability to have multiple parallel bread crumbs to get to a view controller.](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/cc6a0b16dc41cc044d2ca0a98aa2dcbd35a7c2c5) (randallli)

## Non-source changes

* [Disable code coverage reporting. (#16)](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/098188b6353e96f1ffebe2749816e859ba1e8d72) (featherless)
* [Add kokoro continuous build script. (#15)](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/ac9cc4b1c67b74c2c03c1d12c1905dfb47a0a141) (featherless)
* [Fix the xcodeproj. (#14)](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/a25b7b00664903e90e9be058e5e7826213b6295b) (featherless)
* [Add support for Carthage.](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/30dfc96ae85c5e32040304ba584ad6663c9a931f) (Jeff Verkoeyen)
* [fixed method signature](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/9cc0050858eb26dd6bd0c0ecef1f6ffcca6a49e1) (randallli)
* [Add .swift-version file.](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/3e38db52bd3d245ade4734394295894e123b1e59) (Jeff Verkoeyen)

# 2.1.1

- Fixed a crashing bug on iOS 10.3.1.

# 2.1.0

- Add tvOS as a platform.

# 2.0.1

- Fixed some warnings.

## Source changes

* [Merge pull request #6 from randallli/fixWarnings](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/8136bf10acab15ebfb12de080e919f6540753dd9) (Randall Li)

# 2.0.0

- Upgraded to Swift 3.
- Resolved nullability warning in CBCNodeListViewController.

## Source changes

* [Resolve nullability warning in CBCNodeListViewController.](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/aba9ba241b0c93b23aeff2dffbf840308fa1c6a9) (Jeff Verkoeyen)

## Non-source changes

* [Update CHANGELOG.md.](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/8749999cea843119c585267211bcebbdd482a5bf) (Jeff Verkoeyen)
* [Automatic changelog preparation for release.](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/204bcbf77edae27053e60f9e6c21d36bfb8d48c2) (Jeff Verkoeyen)
* [Upgrade project to Xcode 8 and Swift 3.](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/6d7d7e6786ccafe9a267641c48a71859710c5cc0) (Jeff Verkoeyen)
* [Update Podfile.lock.](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/d273761f8c452b2cf7fc1f97141320a8f5978ff4) (Jeff Verkoeyen)
* [Add explanation for adding new examples.](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/452e5f715adb1c5a1d68f4d642d20ce9ba51b875) (Jeff Verkoeyen)
* [Add notes regarding creating a unit test target and ensuring names match.](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/98639ec477c050a8a3d5bb14137fb70a2064bc0f) (Jeff Verkoeyen)
* [Replace tabs with spaces.](https://github.com/material-foundation/cocoapods-catalog-by-convention/commit/a26020e6bc55f2a4a19eb45bd218109eea2ddcd1) (Jeff Verkoeyen)

# 1.0.1

- Add missing header import to src/CBCCatalogExample.h.
- Add exampleViewControllerName API to CBCNode.
- Use modern nullability annotations.
- API docs now available at https://material-foundation.github.io/cocoapods-catalog-by-convention/.

# 1.0.0

- Initial release.

Includes support for examples and unit tests by convention.


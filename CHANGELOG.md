# #develop#

 TODO: Enumerate changes.


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


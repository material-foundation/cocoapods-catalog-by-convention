#if canImport(SwiftUI)
  import SwiftUI
  import UIKit

  /// A view controller to host SwiftUI views wrapped by a UIHostingControllers.
  /// Sample use, where MySwiftUIExample is a SwiftUI View:
  ///
  ///   class MySwiftUIExampleWrapper: SwiftUIExampleWrapper {
  ///     override func viewDidLoad() {
  ///       super.viewDidLoad()
  ///       addChildHostingController(UIHostingController(rootView: MySwiftUIExample()))
  ///     }
  ///   }
  open class SwiftUIExampleWrapper: UIViewController {
    public func addChildHostingController(_ swiftUIHostingController: UIViewController) {
      swiftUIHostingController.view.translatesAutoresizingMaskIntoConstraints = false
      addChild(swiftUIHostingController)
      view.addSubview(swiftUIHostingController.view)
      swiftUIHostingController.didMove(toParent: self)

      swiftUIHostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive =
        true
      swiftUIHostingController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      swiftUIHostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive =
        true
      swiftUIHostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive =
        true
    }
  }
#endif

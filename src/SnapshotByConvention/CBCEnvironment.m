#import "CBCEnvironment.h"

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static BOOL IsSubviewOfUIAlertControllerView(UIView *view) {
  static dispatch_once_t onceToken;
  static Class UIAlertControllerViewClass = nil;
  dispatch_once(&onceToken, ^{
    UIAlertControllerViewClass = NSClassFromString(@"_UIAlertControllerView");
  });

  UIView *iterator = view;
  while (iterator) {
    if ([iterator isMemberOfClass:UIAlertControllerViewClass]) {
      return YES;
    }
    iterator = iterator.superview;
  }
  return NO;
}

@implementation UIVisualEffectView (CatalogByConventionFlakinessReduction)

- (void)cbc_setEffect:(UIVisualEffect *)effect {
  if (@available(iOS 14, *)) {
    // Never allow effects to be set, and if they are set, pin the background color so that the
    // view isn't transparent.
    [self cbc_setEffect:nil];
    self.backgroundColor = [UIColor systemBackgroundColor];
  } else {
    [self cbc_setEffect:effect];
  }
}

- (void)cbc_addSubview:(UIView *)view {
  if (@available(iOS 14, *)) {
    static dispatch_once_t onceToken;
    static Class UIVisualEffectBackdropViewClass = nil;
    dispatch_once(&onceToken, ^{
      UIVisualEffectBackdropViewClass = NSClassFromString(@"_UIVisualEffectBackdropView");
    });

    if ([view isMemberOfClass:UIVisualEffectBackdropViewClass]) {
      // Ignore adding this view. Instead, pin the background of the UIVisualEffectView to a
      // solid color.
      self.backgroundColor = [UIColor systemBackgroundColor];
      return;
    }
  }

  // Call the pre-swizzled implementation in the general case.
  [self cbc_addSubview:view];
}

@end

// Technically an extension for _UIDimmingKnockoutBackdropView, but it's a private API so we extend
// UIView instead.
@implementation UIView (CatalogByConventionFlakinessReduction)

- (void)cbc_setUIDimmingKnockoutBackdropViewCornerRadius:(CGFloat)cornerRadius {
  if (@available(iOS 14, *)) {
    // To avoid over-disabling corner radii, we only ignore the corner radius if we're a subview of
    // a _UIAlertControllerView.
    if (IsSubviewOfUIAlertControllerView(self)) {
      [self cbc_setUIDimmingKnockoutBackdropViewCornerRadius:0];
      return;
    }
  }

  // Call the pre-swizzled implementation in the general case.
  [self cbc_setUIDimmingKnockoutBackdropViewCornerRadius:cornerRadius];
}

@end

@implementation CALayer (CatalogByConventionFlakinessReduction)

- (void)cbc_setCornerRadius:(CGFloat)cornerRadius {
  if (@available(iOS 14, *)) {
    static dispatch_once_t onceToken;
    static Class UIDropShadowViewClass = nil;
    dispatch_once(&onceToken, ^{
      UIDropShadowViewClass = NSClassFromString(@"UIDropShadowView");
    });

    // Disable rounded corners in modally presented view controllers. The rounded corner behavior
    // is governed by the subviews of UIDropShadowView, so we check to see if this layer's view is a
    // subview of a UIDropShadowView. We're able to get the layer's view by looking at the delegate,
    // which will always be set to the corresponding UIView for layer-backed UIViews.
    if ([self.delegate isKindOfClass:[UIView class]]) {
      UIView *view = (UIView *)self.delegate;
      if ([view.superview isMemberOfClass:UIDropShadowViewClass]) {
        [self cbc_setCornerRadius:0];
        return;
      }
    }
  }

  // Call the pre-swizzled implementation in the general case.
  [self cbc_setCornerRadius:cornerRadius];
}

@end

// General purpose instance method swizzler.
static void Swizzle(Class aClass, SEL originalSelector, SEL swizzledSelector) {
  Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);

  BOOL didAddMethod =
      class_addMethod(aClass, originalSelector, method_getImplementation(swizzledMethod),
                      method_getTypeEncoding(swizzledMethod));
  if (didAddMethod) {
    class_replaceMethod(aClass, swizzledSelector, method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod));
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
}

static void DisableBlurEffects(void) {
  Swizzle([UIVisualEffectView class], @selector(setEffect:), @selector(cbc_setEffect:));
  Swizzle([UIVisualEffectView class], @selector(addSubview:), @selector(cbc_addSubview:));
}

static void DisableRoundedAlerts(void) {
  Swizzle(NSClassFromString(@"_UIDimmingKnockoutBackdropView"), @selector(setCornerRadius:),
          @selector(cbc_setUIDimmingKnockoutBackdropViewCornerRadius:));
}

static void DisableRoundedModalViewControllers(void) {
  // We need to swizzle CALayer's setCornerRadius because UIKit's private APIs will repeatedly
  // attempt to enforce the corner radius of modal view controllers at various stages of
  // presentation, and we want to ensure that the radius is never set.
  Swizzle([CALayer class], @selector(setCornerRadius:), @selector(cbc_setCornerRadius:));
}

#pragma mark - Public APIs

void CBCReduceFlakiness(void) {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (@available(iOS 14, *)) {
      // On iOS 14, blur effects result in an almost 50/50 split in rendering behaviors when taking
      // snapshots, so we disable them entirely.
      DisableBlurEffects();

      // On iOS 14, rounded corners on alerts cause flakiness about 50% of the time as well.
      DisableRoundedAlerts();
      DisableRoundedModalViewControllers();
    }
  });
}

@protocol AccessibilitySupportOverrides
+ (instancetype)shared;
- (instancetype)initWithContentSizeCategory:(UIContentSizeCategory)value;
- (void)setBoldText:(NSNumber *)value;
- (void)overrideSystemWithPreference:(id)value;
@end

static void SetBoldText(BOOL enabled) {
  [[objc_getClass("AccessibilitySupportOverrides") shared] setBoldText:@(enabled)];
}

void CBCEnableBoldTextMode(void) {
  SetBoldText(YES);
}

void CBCSetDynamicType(UIContentSizeCategory sizeCategory) {
  [objc_getClass("UIContentSizeCategoryPreference") overrideSystemWithPreference:[[objc_getClass("UIContentSizeCategoryPreference") alloc] initWithContentSizeCategory:sizeCategory]];
}


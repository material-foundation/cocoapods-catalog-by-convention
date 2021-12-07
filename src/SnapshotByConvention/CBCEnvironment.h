#import <UIKit/UIKit.h>

/** Attempts to reduce flakiness by disabling certain features known to cause flakiness. */
FOUNDATION_EXTERN void CBCReduceFlakiness(void);

/** Enables Bold Text mode as though it had been toggled by Xcode's accessibility overrides. */
FOUNDATION_EXTERN void CBCEnableBoldTextMode(void) API_AVAILABLE(ios(13));

/** Set dynamic type by a specific @c UIContentSizeCategory value. */
FOUNDATION_EXTERN void CBCSetDynamicType(UIContentSizeCategory sizeCategory) API_AVAILABLE(ios(13));

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "ICHighlight.h"
#import "ICLabel.h"
#import "ICLabelAttachment.h"
#import "ICLabelDrawService.h"
#import "ICLabelMarco.h"
#import "ICLinkData.h"
#import "NSAttributedString+ICLabel.h"
#import "NSMutableAttributedString+ICLabel.h"

FOUNDATION_EXPORT double ICLabelVersionNumber;
FOUNDATION_EXPORT const unsigned char ICLabelVersionString[];


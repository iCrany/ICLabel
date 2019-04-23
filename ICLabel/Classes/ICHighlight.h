//
//  ICHightlight.h
//  ICLabel
//
//  Created by iCrany on 2018/9/27.
//  Copyright © 2018年 iCrany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICLabelMarco.h"

#if kIS_SUPPORT_TOUCH
typedef void(^ICHighlight_TapAction)(void);
#endif


NS_ASSUME_NONNULL_BEGIN

@interface ICHighlight : NSObject

#if kIS_SUPPORT_TOUCH
@property (nonatomic, copy) ICHighlight_TapAction tapAction;
#endif

@end

NS_ASSUME_NONNULL_END

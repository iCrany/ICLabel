//
//  ICHightlight.h
//  iOSExample
//
//  Created by iCrany on 2018/9/27.
//  Copyright © 2018年 iCrany. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ICHighlight_TapAction)();

NS_ASSUME_NONNULL_BEGIN

@interface ICHighlight : NSObject

@property (nonatomic, copy) ICHighlight_TapAction tapAction;

@end

NS_ASSUME_NONNULL_END

//
//  ICLabelDrawService.h
//  ICLabel
//
//  Created by iCrany on 2018/9/27.
//  Copyright © 2018年 iCrany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "ICLabelMarco.h"

@class ICLabel;
@class ICLabelAttachment;

NS_ASSUME_NONNULL_BEGIN

@interface ICLabelDrawService : NSObject

#if kIS_SUPPORT_ATTACHMENT
+ (ICLabelAttachment *)drawTrunctionTokenWithCTX:(CGContextRef)contextRef
                                        label:(ICLabel *)label
                                         rect:(CGRect)rect
                                       ctLine:(CTLineRef)ctLine
                                  curLineAttr:(NSMutableAttributedString *)curLineAttr
                           trunctionTokenAttr:(NSAttributedString *)trunctionTokenAttrStr
                                lineBreakMode:(NSLineBreakMode)lineBreakMode
                            ctLineOriginPoint:(CGPoint)ctLineOriginPoint; //绘制 trunctionToken 字符
#endif
@end

NS_ASSUME_NONNULL_END

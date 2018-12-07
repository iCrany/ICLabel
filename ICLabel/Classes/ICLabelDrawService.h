//
//  ICLabelDrawService.h
//  iOSExample
//
//  Created by iCrany on 2018/9/27.
//  Copyright © 2018年 iCrany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@class ICLabel;
@class ICLabelAttachment;

NS_ASSUME_NONNULL_BEGIN

@interface ICLabelDrawService : NSObject


+ (void)drawLine; //绘制每一行

+ (void)drawRunWithCTX:(CGContextRef)contextRef
                 label:(ICLabel *)label
                  rect:(CGRect)rect
                ctLine:(CTLineRef)ctLine
     ctLineOriginPoint:(CGPoint)ctLineOriginPoint; //绘制具体的每一个 run, 主要是绘制附件

+ (ICLabelAttachment *)drawTrunctionTokenWithCTX:(CGContextRef)contextRef
                                        label:(ICLabel *)label
                                         rect:(CGRect)rect
                                       ctLine:(CTLineRef)ctLine
                                  curLineAttr:(NSMutableAttributedString *)curLineAttr
                           trunctionTokenAttr:(NSAttributedString *)trunctionTokenAttrStr
                                lineBreakMode:(NSLineBreakMode)lineBreakMode
                            ctLineOriginPoint:(CGPoint)ctLineOriginPoint; //绘制 trunctionToken 字符

@end

NS_ASSUME_NONNULL_END

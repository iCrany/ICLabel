//
//  ICLabelDrawService.m
//  iOSExample
//
//  Created by iCrany on 2018/9/27.
//  Copyright © 2018年 iCrany. All rights reserved.
//

#import "ICLabelDrawService.h"
#import "ICLabelAttachment.h"
#import "ICLabel.h"
#import <CoreText/CoreText.h>

@implementation ICLabelDrawService

+ (void)drawLine {
    
}

+ (void)drawRunWithCTX:(CGContextRef)contextRef
                 label:(ICLabel *)label
                  rect:(CGRect)rect
                ctLine:(CTLineRef)ctLine
     ctLineOriginPoint:(CGPoint)ctLineOriginPoint {
    
}

+ (ICLabelAttachment *)drawTrunctionTokenWithCTX:(CGContextRef)contextRef
                            label:(ICLabel *)label
                             rect:(CGRect)rect
                           ctLine:(CTLineRef)ctLine
                      curLineAttr:(NSMutableAttributedString *)curLineAttr
               trunctionTokenAttr:(NSAttributedString *)trunctionTokenAttrStr
                    lineBreakMode:(NSLineBreakMode)lineBreakMode
                ctLineOriginPoint:(CGPoint)ctLineOriginPoint {
    
    CTLineTruncationType truncationType = kCTLineTruncationEnd;
    switch (lineBreakMode) {
        case NSLineBreakByTruncatingHead: {
            truncationType = kCTLineTruncationStart;
            break;
        }
        case NSLineBreakByTruncatingMiddle: {
            truncationType = kCTLineTruncationMiddle;
            break;
        }
        default: {
            truncationType = kCTLineTruncationEnd;
            break;
        }
    }
    
    ICLabelAttachment *attachment = nil;
    
    NSMutableAttributedString *curLineAttrStr = [curLineAttr mutableCopy];
    [curLineAttrStr appendAttributedString:trunctionTokenAttrStr];
    
    CTLineRef curCTLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)curLineAttrStr);
    CTLineRef truncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)trunctionTokenAttrStr);
    
    //经调试该接口是会主动自己做相关的截断操作，我们仅仅需要将 truncationToken 添加到需要进行裁断处理的当前行字符中去即可，不需要自己做截断字符串的动作
    CTLineRef truncationedLine = CTLineCreateTruncatedLine(curCTLine, rect.size.width, truncationType, truncationToken);
    
    if (!truncationedLine) { truncationedLine = CFRetain(truncationToken); }
    
    CFArrayRef glyRunList = CTLineGetGlyphRuns(truncationedLine);
    CFIndex glyRunCount = CFArrayGetCount(glyRunList);
    CGFloat runXOffset = 0;
    for (CFIndex runIndex = 0; runIndex < glyRunCount; runIndex++) {
        CTRunRef ctRun = CFArrayGetValueAtIndex(glyRunList, runIndex);
        
        NSDictionary *runAttrDict = (NSDictionary *)CTRunGetAttributes(ctRun);
        CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttrDict valueForKey:(__bridge NSString *)kCTRunDelegateAttributeName];
        
        CGFloat runAscent = 0;
        CGFloat runDescent = 0;
        CGFloat runLeading = 0;
        CGFloat glyRunWidth = CTRunGetTypographicBounds(ctRun, CFRangeMake(0, 0), &runAscent, &runDescent, &runLeading);
        
        if (!delegate) {
            runXOffset += glyRunWidth;
            continue;
        }
        //这里进行绘制动作
        attachment = (ICLabelAttachment *)CTRunDelegateGetRefCon(delegate);
        
        //TODO: 这里的这个获取到的 x 偏移量是不准确的，甚至是一直等于0，这个现象很奇怪
//        CGFloat runOriginalXOffset = CTLineGetOffsetForStringIndex(ctLine, CTRunGetStringRange(ctRun).location, NULL); //该 glyRun 的 x 坐标
        UIEdgeInsets attachmentInsets = attachment.contentInsets;
        CGSize contentSize = attachment.contentSize;
        
        CGFloat attachmentOriginX = ctLineOriginPoint.x + runXOffset + attachmentInsets.left; //该坐标系已经转换成了 UIKit 坐标系
        CGFloat attachmentOriginY = rect.size.height - ctLineOriginPoint.y - runAscent + attachmentInsets.top;
        
        CGRect attachmentFrame = CGRectMake(attachmentOriginX, //UIKit 坐标系计算出来的结果
                                            attachmentOriginY,
                                            contentSize.width,
                                            contentSize.height);
        
        if ([attachment.content isKindOfClass:[UIImage class]]) { //处理 UIImage 的类型, 使用的是 CoreText 的坐标系来计算
            UIImage *attachmentImage = attachment.content;
            attachmentOriginY = ctLineOriginPoint.y - runDescent + attachmentInsets.bottom;
            
            attachmentFrame = CGRectMake(attachmentOriginX,
                                         attachmentOriginY,
                                         contentSize.width,
                                         contentSize.height);
            
            CGContextSaveGState(contextRef);
            CGContextDrawImage(contextRef, attachmentFrame, attachmentImage.CGImage); //这个坐标系还是在左下角的
            CGContextRestoreGState(contextRef);
            
        } else if ([attachment.content isKindOfClass:[UIView class]]) { //处理 UIView 的类型
            UIView *attachmentView = attachment.content;
            attachmentView.frame = attachmentFrame;
            if (attachmentView.superview == nil) { //防止重复添加
                [label addSubview:attachmentView];
            }
        } else if ([attachment.content isKindOfClass:[CALayer class]]) { //处理 CALayer 的类型
            CALayer *attachmentLayer = attachment.content;
            attachmentLayer.frame = attachmentFrame;
            if (attachmentLayer.superlayer == nil) { //防止重复添加
                [label.layer addSublayer:attachmentLayer];
            }
        }
        
        runXOffset += glyRunWidth;
    }
    
    CFRelease(curCTLine);
    CFRelease(truncationToken);
    CFRelease(truncationedLine);
    return attachment;
}

@end

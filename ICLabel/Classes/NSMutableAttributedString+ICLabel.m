//
//  NSMutableAttributedString+ICLabel.m
//  iOSExample
//
//  Created by iCrany on 2018/9/12.
//  Copyright © 2018年 iCrany. All rights reserved.
//

#import "NSMutableAttributedString+ICLabel.h"
#import "ICLabelAttachment.h"
#import "ICLabelMarco.h"
#import <CoreText/CoreText.h>

const CGSize ContainerMaxSize = (CGSize){0x100000, 0x100000};

@implementation NSMutableAttributedString (ICLabel)

- (void)ic_appendAttachment:(ICLabelAttachment *)attachment {
    [self ic_insertAttachment:attachment atIndex:self.length];
}

- (void)ic_appendAttachment:(ICLabelAttachment *)attachment hightlight:(ICHighlight *)hightlight {
    [self ic_insertAttachment:attachment highlight:hightlight atIndex:self.length];
}

- (void)ic_insertAttachment:(ICLabelAttachment *)attachment atIndex:(NSUInteger)index {
    [self ic_insertAttachment:attachment highlight:nil atIndex:index];
}

- (void)ic_insertAttachment:(ICLabelAttachment *)attachment highlight:(ICHighlight *)highlight atIndex:(NSUInteger)index {
    NSString *attachmentPlaceholder = [NSString stringWithCharacters:&kPlaceHolder length:1];
    NSMutableAttributedString *placeholderAttrStr = [[NSMutableAttributedString alloc] initWithString:attachmentPlaceholder];
    
    CTRunDelegateCallbacks callbacks; //设置回调函数
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ic_ascentCallbacks;
    callbacks.getWidth = ic_widthCallbacks;
    callbacks.getDescent = ic_descentCallbacks;
    callbacks.dealloc = ic_deallocCallbacks;
    
    //这里一开始不写 __bridge_retained 参数的话，attachment 会在真机中崩溃，内存地址被释放了，并且被写入了其他的对象值，但是在模拟器中是不会崩溃的。。。
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge_retained void *)attachment);
    NSDictionary *attrDict = @{(NSString *)kCTRunDelegateAttributeName: (__bridge id)delegate};
    [placeholderAttrStr setAttributes:attrDict range:NSMakeRange(0, placeholderAttrStr.length)];
    [placeholderAttrStr ic_setHightlight:highlight];
    
    if (delegate) { CFRelease(delegate); }
    
    if (index == self.length) {
        [self appendAttributedString:placeholderAttrStr];
    } else {
        [self insertAttributedString:placeholderAttrStr atIndex:index];
    }
}

- (void)ic_appendAttachmentContent:(id)content
                     contentInsets:(UIEdgeInsets)contentInsets
                         alignment:(ICAttachmentAlignment)alignment
                     referenceFont:(UIFont *)referenceFont {
    [self ic_insertAttachmentContent:content contentInsets:contentInsets alignment:alignment referenceFont:referenceFont atIndex:self.length];
}

- (void)ic_insertAttachmentContent:(id)content
                     contentInsets:(UIEdgeInsets)contentInsets
                         alignment:(ICAttachmentAlignment)alignment
                     referenceFont:(UIFont *)referenceFont
                           atIndex:(NSUInteger)index {
    if ([content isKindOfClass:[UIImage class]]
        || [content isKindOfClass:[UIView class]]
        || [content isKindOfClass:[CALayer class]]) { //暂时只支持 UIImage及其派生类 / UIView及其派生类 / CALayer及其派生类
        ICLabelAttachment *attachment = [ICLabelAttachment attachmentWithContent:content
                                                                    contentInset:contentInsets
                                                                       alignment:alignment
                                                                   referenceFont:referenceFont];
        [self ic_insertAttachment:attachment atIndex:index];
    }
    return;
}

#pragma mark - Normal attribtue
- (void)ic_setFont:(UIFont *)font {
    [self ic_setAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
}

- (void)ic_setFont:(UIFont *)font range:(NSRange)range {
    [self ic_setAttribute:NSFontAttributeName value:font range:range];
}

- (void)ic_setForegroundColor:(UIColor *)forgroundColor {
    [self ic_setAttribute:NSForegroundColorAttributeName value:forgroundColor range:NSMakeRange(0, self.length)];
}

- (void)ic_setForegroundColor:(UIColor *)forgroundColor range:(NSRange)range {
    [self ic_setAttribute:NSForegroundColorAttributeName value:forgroundColor range:range];
}

- (void)ic_setBackgroundColor:(UIColor *)backgroundColor {
    [self ic_setAttribute:NSBackgroundColorAttributeName value:backgroundColor range:NSMakeRange(0, self.length)];
}

- (void)ic_setBackgroundColor:(UIColor *)backgroundColor range:(NSRange)range {
    [self ic_setAttribute:NSBackgroundColorAttributeName value:backgroundColor range:range];
}

- (void)ic_setAttribute:(NSString *)attributedKey value:(id)value range:(NSRange)range {
    if (attributedKey.length <= 0) return;
    if (range.location + range.length > self.length) return;
    
    if (value) {
        [self addAttribute:attributedKey value:value range:range];
    } else {
        [self removeAttribute:attributedKey range:range];
    }
}

#pragma mark - ParagraphStyle setting
- (void)ic_setParagraphStyleWithValue:(NSParagraphStyle *)paragraphStyle {
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
}

- (void)ic_setParagraphStyle_linespacing:(CGFloat)lineSpacing {
    NSDictionary *dict = [self attributesAtIndex:0 longestEffectiveRange:NULL inRange:NSMakeRange(0, self.length)];
    NSMutableParagraphStyle *paragraphStyle = [dict objectForKey:NSParagraphStyleAttributeName];
    if (paragraphStyle == nil) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.lineSpacing = lineSpacing;
    [self ic_setAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
}

- (void)ic_setParagraphStyle_alignment:(NSTextAlignment)alignment {
    NSDictionary *dict = [self attributesAtIndex:0 longestEffectiveRange:NULL inRange:NSMakeRange(0, self.length)];
    NSMutableParagraphStyle *paragraphStyle = [dict objectForKey:NSParagraphStyleAttributeName];
    if (paragraphStyle == nil) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.alignment = alignment;
    [self ic_setAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
}

- (void)ic_setParagraphStyle_lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSDictionary *dict = [self attributesAtIndex:0 longestEffectiveRange:NULL inRange:NSMakeRange(0, self.length)];
    NSMutableParagraphStyle *paragraphStyle = [dict objectForKey:NSParagraphStyleAttributeName];
    if (paragraphStyle == nil) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.lineBreakMode = lineBreakMode;
    [self ic_setAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
}

- (void)ic_setParagraphStyle_firstLineHeadIndent:(CGFloat)firstLineHeadIndent {
    NSDictionary *dict = [self attributesAtIndex:0 longestEffectiveRange:NULL inRange:NSMakeRange(0, self.length)];
    NSMutableParagraphStyle *paragraphStyle = [dict objectForKey:NSParagraphStyleAttributeName];
    if (paragraphStyle == nil) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.firstLineHeadIndent = firstLineHeadIndent;
    [self ic_setAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
}

- (void)ic_setParagraphStyle_minimumLineHeight:(CGFloat)minimumLineHeight {
    NSDictionary *dict = [self attributesAtIndex:0 longestEffectiveRange:NULL inRange:NSMakeRange(0, self.length)];
    NSMutableParagraphStyle *paragraphStyle = [dict objectForKey:NSParagraphStyleAttributeName];
    if (paragraphStyle == nil) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.minimumLineHeight = minimumLineHeight;
    [self ic_setAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
}

- (void)ic_setParagraphStyle_maximumLineHeight:(CGFloat)maximumLineHeight {
    NSDictionary *dict = [self attributesAtIndex:0 longestEffectiveRange:NULL inRange:NSMakeRange(0, self.length)];
    NSMutableParagraphStyle *paragraphStyle = [dict objectForKey:NSParagraphStyleAttributeName];
    if (paragraphStyle == nil) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.maximumLineHeight = maximumLineHeight;
    [self ic_setAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
}

#pragma mark - Custom attribute
- (void)ic_setHightlight:(ICHighlight *)hightlight {
    [self ic_setHightlight:hightlight range:NSMakeRange(0, self.length)];
}

- (void)ic_setHightlight:(ICHighlight *)hightlight range:(NSRange)range {
    [self ic_setAttribute:ICTextHighlightAttributeName value:hightlight range:range];
}

#pragma mark - Other method
- (void)ic_setParagraphStyle_linespacing:(CGFloat)lineSpacing maxWidth:(CGFloat)maxWidth withFont:(UIFont *)font {
    BOOL isMoreThanOneLine = [self __isMoreThanOneLineWithMaxWidth:maxWidth withFont:font];
    if (isMoreThanOneLine) {//超过一行才设置 lineSpacing 参数
        [self ic_setParagraphStyle_linespacing:lineSpacing];
    }
}

- (BOOL)__isMoreThanOneLineWithMaxWidth:(CGFloat)maxWidth withFont:(UIFont *)font {
    if (self.length == 0) return NO;
    
    CGFloat lineHeight = font.lineHeight;
    CGRect rect = [self boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     context: nil];
    
    if (rect.size.height - lineHeight > FLT_MIN) {
        return YES;
    }
    return NO;
}

- (CGRect)ic_boundRectWithSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines {
    if (self.string.length <= 0) return CGRectZero;
    
    //暂时只支持固定宽度算高度的计算, 方便坐标的做换工作，CoreText 的布局就是在 size 这个范围布局的，若高度很大的话运算容易出现溢出之类的问题
    size.height = ContainerMaxSize.height;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self);
    
    if (framesetter) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, nil, CGRectMake(0, 0, size.width, size.height));
        CTFrameRef ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil);
        
        CFArrayRef ctLines = CTFrameGetLines(ctFrame);
        NSInteger lineCount = CFArrayGetCount(ctLines);
        CGPoint lineOriginList[lineCount];
        CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, lineCount), lineOriginList); //获取baseline 原点坐标
        
        if (lineCount <= 0) { return CGRectZero; }
        
        NSInteger limitNumberOfLine = numberOfLines > 0 ? MIN(numberOfLines, lineCount): lineCount;
        
        CGRect boundRect = CGRectZero;
        for (NSInteger index = 0; index < limitNumberOfLine; index++) {
            CTLineRef ctLine = CFArrayGetValueAtIndex(ctLines, index);
            
            CGFloat ascender, descander;
            CGFloat lineWidth = CTLineGetTypographicBounds(ctLine, &ascender, &descander, nil);
            CGPoint baseLineOrigin = lineOriginList[index]; //CoreText 坐标系
            baseLineOrigin.y = size.height - baseLineOrigin.y; //转换成 UIKit 坐标系
            CGRect lineRect = CGRectMake(baseLineOrigin.x, baseLineOrigin.y - ascender, lineWidth, ascender + descander);
            if (index == 0) {
                boundRect = lineRect;
            } else {
                boundRect = CGRectUnion(lineRect, boundRect);
            }
        }
        
        CGPathRelease(path);
        if (ctFrame) CFRelease(ctFrame);
        if (framesetter) CFRelease(framesetter);
        
        if (@available(iOS 10, *)) {
            if (@available(iOS 11, *)) { //取不了非。。。恶心
                
            } else {
                boundRect.size.height += 1.5; //iOS 10 系统的 bug, 暂时解决方案是添加 1.5pt
            }
        }

        return CGRectMake(boundRect.origin.x, boundRect.origin.y, ceil(boundRect.size.width), ceil(boundRect.size.height));
    }
    
    return CGRectZero;
}

@end

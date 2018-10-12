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
    
    CFRelease(delegate);
    
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

@end
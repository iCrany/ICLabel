//
//  NSMutableAttributedString+ICLabel.h
//  iOSExample
//
//  Created by iCrany on 2018/9/12.
//  Copyright © 2018年 iCrany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICLabelAttachment.h"

@class ICHighlight;

/**
 这里应该做的一些工作就是为调用者提供不需要自己额外的在 addAttraibuted 之前 remove 掉上一次添加的属性动作
 */
@interface NSMutableAttributedString (ICLabel)

//################################## Attachment ##################################

- (void)ic_appendAttachment:(ICLabelAttachment *)attachment;
- (void)ic_appendAttachment:(ICLabelAttachment *)attachment hightlight:(ICHighlight *)hightlight;
- (void)ic_insertAttachment:(ICLabelAttachment *)attachment atIndex:(NSUInteger)index;
- (void)ic_insertAttachment:(ICLabelAttachment *)attachment highlight:(ICHighlight *)highlight atIndex:(NSUInteger)index;

- (void)ic_appendAttachmentContent:(id)content
                     contentInsets:(UIEdgeInsets)contentInsets
                         alignment:(ICAttachmentAlignment)alignment
                     referenceFont:(UIFont *)referenceFont;

- (void)ic_insertAttachmentContent:(id)content
                     contentInsets:(UIEdgeInsets)contentInsets
                         alignment:(ICAttachmentAlignment)alignment
                     referenceFont:(UIFont *)referenceFont
                           atIndex:(NSUInteger)index;

//################################## Normal attribute ##################################

- (void)ic_setAttribute:(NSString *)attributedName value:(id)value range:(NSRange)range;

/**
 更新字体，影响的是当前全局的 `attributedText`
 若 font 参数为 nil 则为 removeAttribute 操作
 @param font 字体
 */
- (void)ic_setFont:(UIFont *)font;
- (void)ic_setFont:(UIFont *)font range:(NSRange)range;

- (void)ic_setForegroundColor:(UIColor *)forgroundColor;
- (void)ic_setForegroundColor:(UIColor *)forgroundColor range:(NSRange)range;

- (void)ic_setBackgroundColor:(UIColor *)backgroundColor;
- (void)ic_setBackgroundColor:(UIColor *)backgroundColor range:(NSRange)range;

//################################## NSParagraphStyle ##################################
/**
 更新 NSParagraphStyle 参数

 @param paragraphStyle 参数内容
 */
- (void)ic_setParagraphStyleWithValue:(NSParagraphStyle *)paragraphStyle;

- (void)ic_setParagraphStyle_linespacing:(CGFloat)lineSpacing;
- (void)ic_setParagraphStyle_alignment:(NSTextAlignment)alignment;
- (void)ic_setParagraphStyle_lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (void)ic_setParagraphStyle_firstLineHeadIndent:(CGFloat)firstLineHeadIndent;
- (void)ic_setParagraphStyle_minimumLineHeight:(CGFloat)minimumLineHeight;
- (void)ic_setParagraphStyle_maximumLineHeight:(CGFloat)maximumLineHeight;

//################################## Custom attribute ##################################
- (void)ic_setHightlight:(ICHighlight *)hightlight;
- (void)ic_setHightlight:(ICHighlight *)hightlight range:(NSRange)range;

@end

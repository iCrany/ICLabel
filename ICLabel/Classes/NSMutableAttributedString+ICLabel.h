//
//  NSMutableAttributedString+ICLabel.h
//  ICLabel
//
//  Created by iCrany on 2018/9/12.
//  Copyright © 2018年 iCrany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICLabelAttachment.h"

@class ICHighlight;

NS_ASSUME_NONNULL_BEGIN

/**
 这里应该做的一些工作就是为调用者提供不需要自己额外的在 addAttraibuted 之前 remove 掉上一次添加的属性动作
 */
@interface NSMutableAttributedString (ICLabel)

//################################## Attachment ##################################

- (void)ic_appendAttachment:(ICLabelAttachment *)attachment;
- (void)ic_appendAttachment:(ICLabelAttachment *)attachment hightlight:(nullable ICHighlight *)hightlight;
- (void)ic_insertAttachment:(ICLabelAttachment *)attachment atIndex:(NSUInteger)index;
- (void)ic_insertAttachment:(ICLabelAttachment *)attachment highlight:(nullable ICHighlight *)highlight atIndex:(NSUInteger)index;

- (void)ic_appendAttachmentContent:(nullable id)content
                     contentInsets:(UIEdgeInsets)contentInsets
                         alignment:(ICAttachmentAlignment)alignment
                     referenceFont:(UIFont *)referenceFont;

- (void)ic_insertAttachmentContent:(nullable id)content
                     contentInsets:(UIEdgeInsets)contentInsets
                         alignment:(ICAttachmentAlignment)alignment
                     referenceFont:(UIFont *)referenceFont
                           atIndex:(NSUInteger)index;

//################################## Normal attribute ##################################

- (void)ic_setAttribute:(NSString *)attributedName value:(nullable id)value range:(NSRange)range;

/**
 更新字体，影响的是当前全局的 `attributedText`
 若 font 参数为 nil 则为 removeAttribute 操作
 @param font 字体
 */
- (void)ic_setFont:(nullable UIFont *)font;
- (void)ic_setFont:(nullable UIFont *)font range:(NSRange)range;

- (void)ic_setForegroundColor:(nullable UIColor *)forgroundColor;
- (void)ic_setForegroundColor:(nullable UIColor *)forgroundColor range:(NSRange)range;

- (void)ic_setBackgroundColor:(nullable UIColor *)backgroundColor;
- (void)ic_setBackgroundColor:(nullable UIColor *)backgroundColor range:(NSRange)range;

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
- (void)ic_setHightlight:(nullable ICHighlight *)hightlight;
- (void)ic_setHightlight:(nullable ICHighlight *)hightlight range:(NSRange)range;

//################################## Other helper method ##################################

/**
 该方法会根据 maxWith / font 参数来判断是否需要添加 lineSpacing 参数，因为 UILabel 在支持 lineSpacing 的前提下，若文本只显示一行，UILabel 会将 lineSpacing 一起统计到计算的高度中去，
 所以该方法会动态监测若只有一行就不添加 lineSpacing 参数了

 @param lineSpacing 行间距
 @param maxWidth 控件占据的最大宽度
 @param font 控件的字体
 */
- (void)ic_setParagraphStyle_linespacing:(CGFloat)lineSpacing maxWidth:(CGFloat)maxWidth withFont:(UIFont *)font;

/**
 通过 CTFrame 来计算对应的 NSMutableAttributedString 所需要的大小, 注意计算出来的大小只能用在自定义的 ICLabel 控件上，不能使用在 UILabel 上
 对于 NSParagraphStyle/NSMutableParagraphStyle 的 lineBreakMode, 不要设置 NSLineBreakByClipping / NSLineBreakByTruncatingHead / NSLineBreakByTruncatingMiddle /NSLineBreakByTruncatingTail 这四个参数，会导致计算高度出问题，应该是 CoreText 的 bug，若要使用该特性请调用 UILabel / ICLabel 的 lineBreakMode 设置该参数
 @param size 给定约束的大小
 @param numberOfLines 给定的行数的，若为 0 则没有限制
 @return 对应所需要的实际视图大小
 */
- (CGRect)ic_boundRectWithSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines;

@end

NS_ASSUME_NONNULL_END

//
//  ICLabel.h
//  iOSExample
//
//  Created by iCrany on 2018/8/14.
//  Copyright © 2018年 iCrany. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 支持收起，展开逻辑的控件
 */
@interface ICLabel : UIView

@property (nonatomic, strong, nullable) NSMutableAttributedString *attributedText;

/**
 是否支持截断字符，默认值是单纯的省略号，若有需要则可更改该值来做特殊处理，例如支持【...展开】按钮
 */
@property (nonatomic, strong) NSAttributedString *truncationToken;//默认支持的裁断字符
@property (nonatomic, assign) NSLineBreakMode lineBreakMode; //截断类型，默认是 Truncate at tail of line: "abcd..."

@property (nonatomic, assign) NSInteger numberOfLines; //是否限制行数，默认值为 0 即不限制行数
@property (nonatomic, strong) UIFont *font; //字体大小, 默认值为 systemFont 15.0pt
@property (nonatomic, strong) UIColor *textColor; //字体颜色，默认值为 [UIColor blackColor]
@property (nonatomic, assign) CGFloat lineSpacing; //行与行之间的间距

/**
 计算在给定宽高的基础上计算相应合适的 label 大小

 @param size 给定区域的大小
 @return 实际需要的区域大小
 */
- (CGSize)sizeThatFits:(CGSize)size;

/**
 整个视图重绘
 */
- (void)relayoutText;

@end


NS_ASSUME_NONNULL_END

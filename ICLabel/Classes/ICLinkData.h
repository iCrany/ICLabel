//
//  ICLinkData.h
//  iOSExample
//
//  Created by iCrany on 2018/8/21.
//  Copyright © 2018年 iCrany. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICLinkData;

NS_ASSUME_NONNULL_BEGIN

typedef void(^LinkTapActionBlock)(ICLinkData *data);

/**
 可点击文字的数据存储类
 */
@interface ICLinkData : NSObject

/**
 链接的字符串
 */
@property (nonatomic, strong, readonly) NSString *linkStr;

/**
 链接的字体
 */
@property (nonatomic, strong) UIFont *linkFont;

/**
 链接的 `textColor` 色值
 */
@property (nonatomic, strong) UIColor *linkColor;

/**
 该 `linkStr` 在整个 `attrText` 的范围,若是 truncationToken 则由 ICLabel 自动填写该字段值
 */
@property (nonatomic, assign) NSRange linkRange;

/**
 响应点击事件的范围，默认是 [0, self.linekStr.length - 1]，主要处理自定义 truncationToken 中 省略号 + 点击按钮 的情况
 */
@property (nonatomic, assign) NSRange responseLinkRange;

/**
 点击事件处理回调
 */
@property (nonatomic, copy) LinkTapActionBlock actionBlock;

/**
 构造函数

 @param linkStr see `linkStr`
 @param linkRange see `linkRange`
 @return ICLinkData 实例
 */
- (instancetype)initWithLinkStr:(NSString *)linkStr
                      linkRange:(NSRange)linkRange;

- (instancetype)initWithLinkStr:(NSString *)linkStr
                      linkRange:(NSRange)linkRange
              responseLinkRange:(NSRange)responseLinkRange;

- (instancetype)initWithLinkStr:(NSString *)linkStr
                      linkRange:(NSRange)linkRange
                       linkFont:(UIFont *)linkFont
                      linkColor:(UIColor *)linkColor;

@end

NS_ASSUME_NONNULL_END

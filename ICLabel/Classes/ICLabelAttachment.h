//
//  ICLabelAttachment.h
//  iOSExample
//
//  Created by iCrany on 2018/9/5.
//  Copyright © 2018年 iCrany. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

CGFloat ic_ascentCallbacks(void *ref);
CGFloat ic_descentCallbacks(void *ref);
CGFloat ic_widthCallbacks(void *ref);
void ic_deallocCallbacks(void *ref);

typedef enum : NSUInteger {
    ICAttachmentAlignment_Top, //顶部对齐
    ICAttachmentAlignment_CenterY, //垂直对齐
    ICAttachmentAlignment_Bottom, //底部对齐
} ICAttachmentAlignment;

@interface ICLabelAttachment : NSObject

/**
 暂时只支持 UIImage / UIView / CALayer 的子类，当为 UIView 时会主动将 userInteractionEnabled 设置为 NO 参数
 */
@property (nonatomic, strong, nullable) id content;

@property (nonatomic, assign) CGFloat fontDescender;
@property (nonatomic, assign) CGFloat fontAscender;

/**
 附件的排版设置，默认为 centerY
 */
@property (nonatomic, assign) ICAttachmentAlignment alignment;

/**
 内容的上下左右边距调整，默认为 UIEdgeInsetsZero
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;

/**
 限制的最大大小，若为 CGSizeZero 则表示没有限制，该参数只会限制 attachment 的 size, 而不包含 contentInsets 的边距限制
 */
@property (nonatomic, assign) CGSize limitSize;

/**
 构造方法
 @param content 支持 UIImage / UIView / CALayer
 @return ICLabelAttachment 对象
 */
+ (ICLabelAttachment *)attachmentWithContent:(nullable id)content
                                   alignment:(ICAttachmentAlignment)alignment
                               referenceFont:(UIFont *)referenceFont;

+ (ICLabelAttachment *)attachmentWithContent:(nullable id)content
                                contentInset:(UIEdgeInsets)contentInset
                                   alignment:(ICAttachmentAlignment)alignment
                               referenceFont:(UIFont *)referenceFont;


/**
 附件的大小，包含 contentInsets 的边距大小

 @return CGSize
 */
- (CGSize)attachmentSize;

- (CGSize)contentSize;

@end

NS_ASSUME_NONNULL_END

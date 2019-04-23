//
//  NSMutableAttributedString+ICLabel.h
//  ICLabel
//
//  Created by iCrany on 2018/9/12.
//  Copyright © 2018年 iCrany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICLabelAttachment.h"
#import "ICLabelMarco.h"

@class ICHighlight;

NS_ASSUME_NONNULL_BEGIN

/**
 这里应该做的一些工作就是为调用者提供不需要自己额外的在 addAttraibuted 之前 remove 掉上一次添加的属性动作
 */
@interface NSMutableAttributedString (ICLabel)

//################################## Attachment ##################################
#if kIS_SUPPORT_ATTACHMENT
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
#endif

//################################## Custom attribute ##################################
#if kIS_SUPPORT_TOUCH
- (void)ic_setHightlight:(nullable ICHighlight *)hightlight;
- (void)ic_setHightlight:(nullable ICHighlight *)hightlight range:(NSRange)range;
#endif

@end

NS_ASSUME_NONNULL_END

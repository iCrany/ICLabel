//
//  NSMutableAttributedString+ICLabel.m
//  ICLabel
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
#if kIS_SUPPORT_ATTACHMENT
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
#endif

#if kIS_SUPPORT_TOUCH

#pragma mark - Custom attribute
- (void)ic_setHightlight:(ICHighlight *)hightlight {
    [self ic_setHightlight:hightlight range:NSMakeRange(0, self.length)];
}

- (void)ic_setHightlight:(ICHighlight *)hightlight range:(NSRange)range {
    [self ic_setAttribute:ICTextHighlightAttributeName value:hightlight range:range];
}

#endif

@end

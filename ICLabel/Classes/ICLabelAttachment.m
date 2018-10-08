//
//  ICLabelAttachment.m
//  iOSExample
//
//  Created by iCrany on 2018/9/5.
//  Copyright © 2018年 iCrany. All rights reserved.
//

#import "ICLabelAttachment.h"

CGFloat ic_ascentCallbacks(void *ref) {
    ICLabelAttachment *attachment = (__bridge ICLabelAttachment *)ref;
    CGSize attachmentSize = attachment.attachmentSize;
    CGFloat ascent = 0;
    
    switch (attachment.alignment) {
        case ICAttachmentAlignment_Top: {
            ascent = attachment.fontAscender;
            break;
        }
            
        case ICAttachmentAlignment_CenterY: {
            CGFloat fontHeight = attachment.fontAscender - attachment.fontDescender;
            CGFloat yOffset = attachment.fontAscender - fontHeight * 0.5;
            ascent = attachmentSize.height * 0.5 + yOffset;
            break;
        }
            
        case ICAttachmentAlignment_Bottom: {
            ascent = attachmentSize.height + attachment.fontDescender;
            break;
        }
            
        default: {
            ascent = attachmentSize.height;
            break;
        }
    }
    return ascent;
}

CGFloat ic_descentCallbacks(void *ref) {
    ICLabelAttachment *attachment = (__bridge ICLabelAttachment *)ref;
    CGSize attachmentSize = attachment.attachmentSize;
    CGFloat descent = 0;
    
    switch (attachment.alignment) {
        case ICAttachmentAlignment_Top: {
            descent = attachmentSize.height - attachment.fontAscender;
            break;
        }
            
        case ICAttachmentAlignment_CenterY: {
            CGFloat fontHeight = attachment.fontAscender - attachment.fontDescender;
            CGFloat yOffset = attachment.fontAscender - fontHeight * 0.5;
            CGFloat ascent = attachmentSize.height * 0.5 + yOffset;
            descent = attachmentSize.height - ascent;
            break;
        }
            
        case ICAttachmentAlignment_Bottom: {
            descent = -attachment.fontDescender;
            break;
        }
        default: {
            descent = 0;
            break;
        }
    }
    return descent;
}

CGFloat ic_widthCallbacks(void *ref) {
    ICLabelAttachment *attachment = (__bridge ICLabelAttachment *)ref;
    return attachment.attachmentSize.width;
}

void ic_deallocCallbacks(void *ref) {
    ICLabelAttachment *attachment = (__bridge_transfer ICLabelAttachment *)ref;
    attachment = nil;
}

@implementation ICLabelAttachment

#pragma mark - Public method
+ (ICLabelAttachment *)attachmentWithContent:(id)content
                                   alignment:(ICAttachmentAlignment)alignment
                               referenceFont:(UIFont *)referenceFont {
    return [ICLabelAttachment attachmentWithContent:content
                                       contentInset:UIEdgeInsetsZero
                                          alignment:alignment
                                      referenceFont:referenceFont];
}

+ (ICLabelAttachment *)attachmentWithContent:(id)content
                                contentInset:(UIEdgeInsets)contentInset
                                   alignment:(ICAttachmentAlignment)alignment
                               referenceFont:(UIFont *)referenceFont {
    ICLabelAttachment *attachment = [[ICLabelAttachment alloc] init];
    attachment.content = content;
    attachment.contentInsets = contentInset;
    attachment.alignment = alignment;
    attachment.fontDescender = referenceFont.descender;
    attachment.fontAscender = referenceFont.ascender;
    return attachment;
}

#pragma mark - Helper method
- (CGSize)attachmentSize {
    UIEdgeInsets contentInsets = self.contentInsets;
    CGSize contentSize = [self contentSize];
    
    CGSize retSize = CGSizeMake(contentInsets.left + contentSize.width + contentInsets.right,
                                contentInsets.top + contentSize.height + contentInsets.bottom);
    return retSize;
}

- (CGSize)contentSize {
    CGSize contentSize = CGSizeZero;
    
    if ([self.content isKindOfClass:[UIImage class]]) {
        UIImage *img = self.content;
        contentSize = [img size];
    } else if ([self.content isKindOfClass:[UIView class]]) {
        UIView *view = self.content;
        contentSize = view.frame.size;
    } else if ([self.content isKindOfClass:[CALayer class]]) {
        CALayer *layer = self.content;
        contentSize = layer.frame.size;
    }
    
    if (!CGSizeEqualToSize(self.limitSize, CGSizeZero)) { //限制 contentSize 的大小，这里没有做等比的缩放比较
        if (contentSize.width - self.limitSize.width > FLT_MIN) {
            contentSize.width = self.limitSize.width;
        }
        
        if (contentSize.height - self.limitSize.height > FLT_MIN) {
            contentSize.height = self.limitSize.height;
        }
    }
    return contentSize;
}

@end

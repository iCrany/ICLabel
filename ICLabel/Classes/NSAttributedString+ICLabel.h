//
//  NSAttributedString+ICLabel.h
//  ICLabel
//
//  Created by iCrany on 2018/12/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ICLabelMarco.h"

#if kIS_NEED_UTIL_METHOD

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (ICLabel)

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

#endif

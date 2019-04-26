//
//  ICLayoutFrame.h
//  ICLabel
//
//  Created by iCrany on 2019/4/23.
//

#import <Foundation/Foundation.h>

@class ICLayouter;
@class ICLayoutLine;

NS_ASSUME_NONNULL_BEGIN

@interface ICLayoutFrame : NSObject

@property (nonatomic, strong) NSAttributedString *attributedText;
@property (nonatomic, strong) NSAttributedString *truncationToken;
@property (nonatomic, strong, readonly) NSArray<ICLayoutLine *> *lines;

- (instancetype)initWithFrame:(CGRect)frame
                     layouter:(ICLayouter *)layouter
                        range:(NSRange)range;


/**
 开始渲染调用

 @param context 画布
 @param rect 实际的画布大小（可以理解成 drawRect:(CGRect)rect 中的 rect, 是没有内间距的）
 */
- (void)drawInContext:(CGContextRef)context rect:(CGRect)rect;

- (NSArray *)paragraphRanges;

/**
 根据 index 返回包含该下标的行

 @param index 下标
 @return 如有则返回对应的 ICLayoutLine, 否则返回 nil
 */
- (ICLayoutLine *)lineContainingIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END

//
//  ICLayoutLine.h
//  ICLabel
//
//  Created by iCrany on 2019/4/23.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICLayoutLine : NSObject

/**
 该行在整个渲染文本的[location, length]信息
 */
@property (nonatomic, readonly, assign) CFRange stringRange;
@property (nonatomic, readonly, assign) CGPoint lineOrigin; //baseline 坐标

@property (nonatomic, readonly, assign) CGFloat descender;
@property (nonatomic, readonly, assign) CGFloat ascender;
@property (nonatomic, readonly, assign) CGFloat leading;
@property (nonatomic, readonly, assign) CGFloat lineWidth;

- (instancetype)initWithLine:(CTLineRef)ctLine lineOrigin:(CGPoint)lineOrigin drawRect:(CGRect)drawRect;

- (void)drawInContext:(CGContextRef)context;


/**
 该方法的坐标系已转换成 UIKit 的坐标系了

 @return <#return value description#>
 */
- (CGRect)getLineBounds;

/**
 通过位置拿到点击的文字的下标

 @param position 点击的坐标
 @return 下标
 */
- (CFIndex)getStringIndexForPosition:(CGPoint)position;


/**
 获取某个字符在该行的 x 轴偏移量

 @param index 下标
 @return x 轴偏移量
 */
- (CGFloat)getOffsetForStringIndex:(CFIndex)index;

@end

NS_ASSUME_NONNULL_END

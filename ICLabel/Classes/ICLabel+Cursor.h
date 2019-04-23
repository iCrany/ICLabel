//
//  ICLabel+Cursor.h
//  ICLabel
//
//  Created by iCrany on 2019/4/23.
//

#import <ICLabel/ICLabel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICLabel (Cursor)

/**
 通过点击坐标的获取文字的下标，可以用于光标的添加功能
 
 @param point 点击的坐标
 @return 对应的文字下标，若没有找到则返回 NSNotFound
 */
- (NSInteger)closestCursorIndexToPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END

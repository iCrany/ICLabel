//
//  ICLabel+Cursor.m
//  ICLabel
//
//  Created by iCrany on 2019/4/23.
//

#import "ICLabel+Cursor.h"
#import <CoreText/CoreText.h>
#import "ICLabelMarco.h"

@implementation ICLabel (Cursor)
//
//- (NSInteger)closestCursorIndexToPoint:(CGPoint)point {
//    NSInteger retIndex = NSNotFound;
//    if (!_ctLines) return retIndex;
//    
//    //这里处理获取被点击区域的 CFIndex 坐标
//    NSInteger lineCount = CFArrayGetCount(_ctLines);
//    CGPoint origins[lineCount];
//    if (lineCount >= 0) {
//        CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, 0), origins);
//        for (int i = 0; i < lineCount; i++) {
//            CGPoint baselineOrigin = origins[i];
//            CTLineRef line = CFArrayGetValueAtIndex(_ctLines, i);
//            CGRect lineFrame = [self __getLineBoundsWithLine:line baseLineOrigin:baselineOrigin];
//            if (CGRectContainsPoint(lineFrame, point)) { //这里确定点击的行数，然后对应的找到该行被点击的文字在该行中的位置
//                CFIndex tapIndex = CTLineGetStringIndexForPosition(line, point);
//                CFIndex targetIndex = tapIndex;
//                
//                if (tapIndex != kCFNotFound) {
//                    CFRange thisLineRange = CTLineGetStringRange(line);
//                    NSAttributedString *thisLineAttr = [_attributedText attributedSubstringFromRange:NSMakeRange(thisLineRange.location, thisLineRange.length)];
//                    NSAttributedString *tapAttr = nil;
//                    if (tapIndex - thisLineRange.location >=0 && tapIndex - thisLineRange.location < thisLineAttr.length) {
//                        tapAttr = [thisLineAttr attributedSubstringFromRange:NSMakeRange(tapIndex - thisLineRange.location, 1)];
//                    }
//                    
//                    ICLog(@"thisLineAttr: %@", thisLineAttr.string);
//                    ICLog(@"lineFrame- %@ touchPoint- %@", [NSValue valueWithCGRect:lineFrame], [NSValue valueWithCGPoint:point]);
//                    ICLog(@"lineIndex: %d tapIndex: %ld tapAttr: %@", i, tapIndex, tapAttr.string);
//                    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, tapIndex, NULL);
//                    ICLog(@"tapIndex str(%@) xOffset: %lf touchPoint.x: %lf", tapAttr.string, xOffset, point.x);
//                    
//                    CFIndex fixedIndex = tapIndex;
//                    if (point.x - xOffset > FLT_MIN) {
//                        if (tapIndex - thisLineRange.location + 1 < thisLineAttr.length) {
//                            tapAttr = [thisLineAttr attributedSubstringFromRange:NSMakeRange(tapIndex - thisLineRange.location + 1, 1)];
//                        } else {
//                            tapAttr = nil;
//                        }
//                        ICLog(@"【fix】往右 + 1， newTapIndex: %ld tapAttr: %@", tapIndex + 1, tapAttr.string);
//                        fixedIndex = tapIndex + 1;
//                    } else {
//                        if (tapIndex - thisLineRange.location - 1 >= 0) {
//                            tapAttr = [thisLineAttr attributedSubstringFromRange:NSMakeRange(tapIndex - thisLineRange.location - 1, 1)];
//                        } else {
//                            tapAttr = nil;
//                        }
//                        ICLog(@"【fix】往左 - 1， newTapIndex: %ld tapAttr: %@", tapIndex - 1, tapAttr.string);
//                        fixedIndex = tapIndex - 1;
//                    }
//                    
//                    targetIndex = MIN(fixedIndex, tapIndex);
//                    if (targetIndex >= 0 && targetIndex < thisLineAttr.length) {
//                        tapAttr = [thisLineAttr attributedSubstringFromRange:NSMakeRange(targetIndex, 1)];
//                    }
//                    ICLog(@"targetIndex: %ld 最后识别的文字：%@", targetIndex, tapAttr.string);
//                }
//                return targetIndex;
//            }
//        }
//    }
//    return retIndex;
//}
//
///// 该方法的坐标系已转换成 UIKit 的坐标系了
//- (CGRect)__getLineBoundsWithLine:(CTLineRef)line baseLineOrigin:(CGPoint)baseLineOrigin {
//    CGFloat descender, ascender, leading = 0;
//    CGFloat lineWidth = CTLineGetTypographicBounds(line,
//                                                   &ascender,
//                                                   &descender,
//                                                   &leading);//获取该行的宽度
//    //坐标系的问题，坐标原点是左下角的，所以这里需要将坐标转换成 UIKit 坐标系
//    CGRect lineFrame = CGRectMake(baseLineOrigin.x,
//                                  CGRectGetHeight(self.bounds) - baseLineOrigin.y - ascender,
//                                  lineWidth,
//                                  ascender + fabs(descender));
//    return lineFrame;
//}

@end

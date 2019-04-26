//
//  ICLabel+Cursor.m
//  ICLabel
//
//  Created by iCrany on 2019/4/23.
//

#import "ICLabel+Cursor.h"
#import <CoreText/CoreText.h>
#import "ICLabelMarco.h"
#import "ICLayouter.h"
#import "ICLayoutFrame.h"
#import "ICLayoutLine.h"

@implementation ICLabel (Cursor)

- (NSInteger)closestCursorIndexToPoint:(CGPoint)point {
    NSInteger retIndex = NSNotFound;
    if (self.layoutFrame == nil) return retIndex;

    //这里处理获取被点击区域的 CFIndex 坐标
    NSInteger lineCount = self.layoutFrame.lines.count;
    for (int i = 0; i < lineCount; i++) {
        ICLayoutLine *line = self.layoutFrame.lines[i];
        CGRect lineFrame = [line getLineFrame];
        if (CGRectContainsPoint(lineFrame, point)) { //这里确定点击的行数，然后对应的找到该行被点击的文字在该行中的位置
            CFIndex tapIndex = [line getStringIndexForPosition:point];
            if (tapIndex != kCFNotFound) {
                CGFloat xOffset = [line getOffsetForStringIndex:tapIndex];
                CFIndex fixedIndex = tapIndex;
                if (point.x - xOffset > FLT_MIN) {
                    fixedIndex = tapIndex + 1;
                } else {
                    fixedIndex = tapIndex - 1;
                }
                tapIndex = MIN(fixedIndex, tapIndex);
            }
            return tapIndex;
        }
    }
    return retIndex;
}

@end

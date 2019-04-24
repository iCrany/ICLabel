//
//  ICLayoutLine.m
//  ICLabel
//
//  Created by iCrany on 2019/4/23.
//

#import "ICLayoutLine.h"
#import "ICGlyphRun.h"

@interface ICLayoutLine() {
    CTLineRef _line;
    NSArray *_glyphRuns;
    CGPoint _lineOrigin;
    
    CGFloat _descender;
    CGFloat _ascender;
    CGFloat _leading;
    CGFloat _lineWidth;
    CGRect _drawRect;
}

@end

@implementation ICLayoutLine

- (instancetype)initWithLine:(CTLineRef)ctLine
                  lineOrigin:(CGPoint)lineOrigin
                    drawRect:(CGRect)drawRect {
    self = [super init];
    if (self) {
        _line = ctLine;
        _lineOrigin = lineOrigin;
        _drawRect = drawRect;
        
        CFArrayRef glyRunList = CTLineGetGlyphRuns(ctLine);
        CFIndex glyRunCount = CFArrayGetCount(glyRunList);
        NSMutableArray *glyhRunList = [[NSMutableArray alloc] init];
        for (NSInteger index = 0; index < glyRunCount; index++) {
            CTRunRef glyphRun = CFArrayGetValueAtIndex(glyRunList, index);
            ICGlyphRun *run = [[ICGlyphRun alloc] initWithRun:glyphRun];
            [glyhRunList addObject:run];
        }
        _lineWidth = CTLineGetTypographicBounds(_line,
                                               &_ascender,
                                               &_descender,
                                               &_leading);
        _stringRange = CTLineGetStringRange(_line);
        _glyphRuns = [glyhRunList copy];
    }
    return self;
}

- (void)dealloc {
    if (_line) {
        CFRelease(_line);
    }
}

- (CGRect)getLineBounds {
    //坐标系的问题，坐标原点是左下角的，所以这里需要将坐标转换成 UIKit 坐标系
    CGRect lineFrame = CGRectMake(_lineOrigin.x,
                                  CGRectGetHeight(_drawRect) - _lineOrigin.y - _ascender,
                                  _lineWidth,
                                  _ascender + fabs(_descender));
    return lineFrame;
}

- (CFIndex)getStringIndexForPosition:(CGPoint)position {
    return CTLineGetStringIndexForPosition(_line, position);
}

- (CGFloat)getOffsetForStringIndex:(CFIndex)index {
    return CTLineGetOffsetForStringIndex(_line, index, NULL);
}

#pragma mark - Drawing
- (void)drawInContext:(CGContextRef)context {
    CTLineDraw(_line, context);
}

@end

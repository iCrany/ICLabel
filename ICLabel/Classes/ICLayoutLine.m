//
//  ICLayoutLine.m
//  ICLabel
//
//  Created by iCrany on 2019/4/23.
//

#import "ICLayoutLine.h"
#import "ICGlyphRun.h"
#import <CoreText/CoreText.h>

@interface ICLayoutLine() {
    CTLineRef _line;
    NSArray *_glyphRuns;
}

@end

@implementation ICLayoutLine

- (instancetype)initWithLine:(CTLineRef)ctLine {
    self = [super init];
    if (self) {
        _line = ctLine;
        
        //TODO: 构造出 ctRuns 的列表
        CFArrayRef glyRunList = CTLineGetGlyphRuns(ctLine);
        CFIndex glyRunCount = CFArrayGetCount(glyRunList);
        NSMutableArray *glyhRunList = [[NSMutableArray alloc] init];
        for (NSInteger index = 0; index < glyRunCount; index++) {
            ICGlyphRun *run = [[ICGlyphRun alloc] init];
            [glyhRunList addObject:run];
        }
        _glyphRuns = [glyhRunList copy];
    }
    return self;
}

#pragma mark - Drawing
- (void)drawInContext:(CGContextRef)context {
    CTLineDraw(_line, context);
}


@end

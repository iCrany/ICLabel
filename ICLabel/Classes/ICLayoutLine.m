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
}

@end

@implementation ICLayoutLine

- (instancetype)initWithLine:(CTLineRef)ctLine {
    self = [super init];
    if (self) {
        _line = ctLine;
        
        CFArrayRef glyRunList = CTLineGetGlyphRuns(ctLine);
        CFIndex glyRunCount = CFArrayGetCount(glyRunList);
        NSMutableArray *glyhRunList = [[NSMutableArray alloc] init];
        for (NSInteger index = 0; index < glyRunCount; index++) {
            CTRunRef glyphRun = CFArrayGetValueAtIndex(glyRunList, index);
            ICGlyphRun *run = [[ICGlyphRun alloc] initWithRun:glyphRun];
            [glyhRunList addObject:run];
        }
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

#pragma mark - Drawing
- (void)drawInContext:(CGContextRef)context {
    CTLineDraw(_line, context);
}

@end

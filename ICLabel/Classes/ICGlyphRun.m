//
//  ICGlyphRun.m
//  ICLabel
//
//  Created by iCrany on 2019/4/23.
//

#import "ICGlyphRun.h"

@interface ICGlyphRun() {
    CTRunRef _run;
    CGRect _drawRect;
}

@end

@implementation ICGlyphRun

- (instancetype)initWithRun:(CTRunRef)run drawRect:(CGRect)drawRect {
    self = [super init];
    if (self) {
        _run = run;
        _drawRect = drawRect;
    }
    return self;
}

@end

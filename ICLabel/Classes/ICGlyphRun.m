//
//  ICGlyphRun.m
//  ICLabel
//
//  Created by iCrany on 2019/4/23.
//

#import "ICGlyphRun.h"

@interface ICGlyphRun() {
    CTRunRef _run;
}

@end

@implementation ICGlyphRun

- (instancetype)initWithRun:(CTRunRef)run {
    self = [super init];
    if (self) {
        _run = run;
    }
    return self;
}

@end

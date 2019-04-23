//
//  ICLayouter.m
//  ICLabel
//
//  Created by iCrany on 2019/4/23.
//

#import "ICLayouter.h"
#import <CoreText/CoreText.h>

@interface ICLayouter() {
    CTFramesetterRef _framesetter;
}

@end

@implementation ICLayouter

- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString {
    self = [super init];
    if (self) {
        self.attributedString = attributedString;
    }
    return self;
}

- (void)__destoryFramesetter {
    if (_framesetter) {
        CFRelease(_framesetter);
    }
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
    if (self.attributedString != attributedString) {
        self.attributedString = attributedString;
        [self __destoryFramesetter];
    }
}

@end

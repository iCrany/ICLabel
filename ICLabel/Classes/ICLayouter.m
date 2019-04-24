//
//  ICLayouter.m
//  ICLabel
//
//  Created by iCrany on 2019/4/23.
//

#import "ICLayouter.h"
#import "ICLayoutFrame.h"

@interface ICLayouter() {
    CTFramesetterRef _framesetter;
    NSCache *_cache;
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
    _framesetter = nil;
}

- (ICLayoutFrame *)layoutFrameWithRect:(CGRect)frame range:(NSRange)range {
    ICLayoutFrame *newFrame = [[ICLayoutFrame alloc] initWithFrame:frame layouter:self range:range];
    return newFrame;
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
    if (_attributedString != attributedString) {
        _attributedString = attributedString;
        [self __destoryFramesetter];
    }
}

- (CTFramesetterRef)framesetter {
    if (!_framesetter) {
        _framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedString);
    }
    return _framesetter;
}

@end

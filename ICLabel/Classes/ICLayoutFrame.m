//
//  ICLayoutFrame.m
//  ICLabel
//
//  Created by iCrany on 2019/4/23.
//

#import "ICLayoutFrame.h"
#import <CoreText/CoreText.h>
#import "ICLayouter.h"
#import "ICLayoutLine.h"

@interface ICLayoutFrame() {
    CGRect _frame;
    CTFrameRef _ctFrame;
    ICLayouter *_layouter;
    NSArray *_lines;
}
@end

@implementation ICLayoutFrame

- (instancetype)initWithFrame:(CGRect)frame
                     layouter:(ICLayouter *)layouter
                        range:(NSRange)range {
    self = [super init];
    if (self) {
        _frame = frame;
        
        _layouter = layouter;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, frame);
        _ctFrame = CTFramesetterCreateFrame(layouter.framesetter, CFRangeMake(range.location, range.length), path, NULL);
        CFArrayRef ctLines = CTFrameGetLines(_ctFrame);
        NSInteger numberOfLines = CFArrayGetCount(ctLines);
        NSMutableArray *icLayoutLines = [[NSMutableArray alloc] init];
        for (NSInteger index = 0; index < numberOfLines; index++) {
            ICLayoutLine *line = [[ICLayoutLine alloc] init];
            [icLayoutLines addObject:line];
        }
        _lines = [icLayoutLines copy];
        CGPathRelease(path);
    }
    return self;
}

@end

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
    NSArray *_lines;
    ICLayouter *_layouter;
    NSInteger _numberOfLines;//这个是用户设置的 numberOfLines, 而不是布局后的 _lines 数组的个数
    NSArray *_paragraphRanges;//拆分成不同段落的数组
    
    CTFrameRef _ctInnerFrame; //用于计算最后一行是否需要进行截断处理的
    NSInteger _innerNumberOfLines; //实际需要多少行才能够排版好, 例如给定的 AttributedString 后，在高度不限制的情况下的排版函数
}
@end

@implementation ICLayoutFrame

- (instancetype)initWithFrame:(CGRect)frame
                     layouter:(ICLayouter *)layouter
                        range:(NSRange)range {
    self = [super init];
    if (self) {
        _frame = frame;
        _attributedText = [[layouter attributedString] copy];
        
        _layouter = layouter;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, frame);
        CFRange cfRange = CFRangeMake(range.location, range.length);
        _ctFrame = CTFramesetterCreateFrame(layouter.framesetter,
                                            cfRange,
                                            path,
                                            NULL);
        CFArrayRef ctLines = CTFrameGetLines(_ctFrame);
        CFIndex numberOfLines = CFArrayGetCount(ctLines);
        NSMutableArray *icLayoutLines = [[NSMutableArray alloc] initWithCapacity:numberOfLines];
        
        //获取 Line 的 baseLine origin 坐标
        CGPoint origins[numberOfLines];
        CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, 0), origins);
        
        for (NSInteger index = 0; index < numberOfLines; index++) {
            CTLineRef ctLine = CFArrayGetValueAtIndex(ctLines, index);
            ICLayoutLine *line = [[ICLayoutLine alloc] initWithLine:ctLine lineOrigin:origins[index] drawRect:frame];
            [icLayoutLines addObject:line];
        }
        _lines = [icLayoutLines copy];
        
        //用于判断是否需要截断处理的逻辑
        CGMutablePathRef innerPath = CGPathCreateMutable();
        CGPathAddRect(innerPath, NULL, CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, CGFLOAT_MAX));
        _ctInnerFrame = CTFramesetterCreateFrame(layouter.framesetter, cfRange, innerPath, NULL);
        CFArrayRef ctInnerLines = CTFrameGetLines(_ctInnerFrame);
        CFIndex innerNumberOfLines = CFArrayGetCount(ctInnerLines);
        _innerNumberOfLines = innerNumberOfLines;
        
        CGPathRelease(path);
        CGPathRelease(innerPath);
    }
    return self;
}
- (NSInteger)__calcNumberOfLine {//获取真实需要的行数，需要跟用户设置的 _numberOfLiens 参数进行对比才行
    NSInteger numberOfLines = _lines.count;
    numberOfLines = _numberOfLines > 0 ? MIN(_numberOfLines, numberOfLines) : numberOfLines;
    return numberOfLines;
}

- (BOOL)__isMoreThanNumberOfLineLimit { //判断是否超过了
    if (_numberOfLines == 0) return NO;
    if (_numberOfLines >= _innerNumberOfLines) return NO;
    return YES;
}

- (void)drawInContext:(CGContextRef)context rect:(CGRect)rect {
    NSInteger numberOfLines = [self __calcNumberOfLine];
    CGPoint lineOriginPoints[numberOfLines];
    CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, numberOfLines), lineOriginPoints);
    BOOL isMoreThanNumberOfLineLimit = [self __isMoreThanNumberOfLineLimit];
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        ICLayoutLine *line = _lines[lineIndex];
        CGPoint lineOrigins = lineOriginPoints[lineIndex];
        
        CGContextSetTextPosition(context, lineOrigins.x, lineOrigins.y);//更新一下 context 中的起始坐标，若该行坐标出现了问题就会导致出错行的位置错乱
        
        if (isMoreThanNumberOfLineLimit && lineIndex == numberOfLines - 1) {
            CFRange curLineRange = line.stringRange;
            NSAttributedString *trunctionTokenAttrStr = [_truncationToken mutableCopy];
            CTLineTruncationType truncationType = kCTLineTruncationEnd;
            NSMutableAttributedString *curLineAttrStr = [[_attributedText attributedSubstringFromRange:NSMakeRange(curLineRange.location, curLineRange.length)] mutableCopy]; //这一行中需要进行裁剪的 str 位置
            [curLineAttrStr appendAttributedString:trunctionTokenAttrStr];
            
            CTLineRef curCTLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)curLineAttrStr);
            CTLineRef truncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)trunctionTokenAttrStr);
            
            //经调试该接口是会主动自己做相关的截断操作，我们仅仅需要将 truncationToken 添加到需要进行裁断处理的当前行字符中去即可，不需要自己做截断字符串的动作
            CTLineRef truncationedLine = CTLineCreateTruncatedLine(curCTLine, rect.size.width, truncationType, truncationToken);
            
            //If the width of the line specified in truncationToken is greater, this function will return NULL if truncation is needed
            if (!truncationedLine) {
                truncationedLine = CFRetain(truncationToken);
            }
            CTLineDraw(truncationedLine, context); //单独绘制做裁断的这一行的数据
            
            CFRelease(curCTLine);
            CFRelease(truncationToken);
            CFRelease(truncationedLine);
            
        } else {
            [line drawInContext:context];
        }
    }
}

- (NSArray *)paragraphRanges {
    if (!_paragraphRanges) {
        NSString *str = [[self attributedText] string];
        if (str.length <= 0) return nil;
        
        NSRange paragraphRange = [self _rangeOfParagraphsContainingRange:NSMakeRange(0, 0) plainString:str];
        NSUInteger length = [str length];
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        while (paragraphRange.length) {
            [tmpArray addObject:[NSValue valueWithRange:paragraphRange]];
            NSUInteger nextParagraphBegin = NSMaxRange(paragraphRange);

            if (nextParagraphBegin >= length) {
                break;
            }

            // next paragraph
            paragraphRange = [self _rangeOfParagraphsContainingRange:NSMakeRange(nextParagraphBegin, 0) plainString:str];
        }
        _paragraphRanges = tmpArray;
    }
    return _paragraphRanges;
}

- (NSRange)_rangeOfParagraphsContainingRange:(NSRange)range plainString:(NSString *)plainString {
    CFIndex beginIndex;
    CFIndex endIndex;
    
    CFStringGetParagraphBounds((__bridge CFStringRef)plainString, CFRangeMake(range.location, range.length), &beginIndex, &endIndex, NULL);
    
    // endIndex is the first character of the following paragraph, so we don't need to add 1
    return NSMakeRange(beginIndex, endIndex - beginIndex);
}

- (ICLayoutLine *)lineContainingIndex:(NSUInteger)index {
    for (int i = 0; i < self.lines.count; i++) {
        ICLayoutLine *line = self.lines[i];
        if (NSLocationInRange(index, NSMakeRange(line.stringRange.location, line.stringRange.length))) {
            return line;
        }
    }
    return nil;
}

@end

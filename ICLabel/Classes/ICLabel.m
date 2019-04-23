//
//  ICLabel.m
//  ICLabel
//
//  Created by iCrany on 2018/8/14.
//  Copyright © 2018年 iCrany. All rights reserved.
//

#import "ICLabel.h"
#import <CoreText/CoreText.h>
#import "NSMutableAttributedString+ICLabel.h"
#import "ICLabelDrawService.h"
#import "ICLabelMarco.h"
#import "ICHighlight.h"
#import "ICLabelAttachment.h"
#import "ICLayoutLine.h"
#import "ICLayoutFrame.h"

#if DEBUG
static BOOL kIsInDebugMode = NO;
#endif

@interface ICLabel() {
    
    CTFrameRef _ctFrame;
    CFArrayRef _ctLines;
    CTFramesetterRef _framesetter;
    
    CTFrameRef __innerUseCTFrame; //该数组用于计算文本的实际的需要的 lines 等参数，而并不是在计算出 sizeThatFits 的宽度之后再去绘制的
    CFIndex __innerNumberOfLines; //实际需要的行数
    
    BOOL _isNeedRelayout; //是否需要重新绘制
    
    ICLayoutFrame *_layoutFrame;
}

#if kIS_SUPPORT_TOUCH
@property (nonatomic, strong) ICHighlight *curHightlight; //当前正在响应的位置
#endif

#if kIS_SUPPORT_ATTACHMENT
@property (nonatomic, strong) NSMutableArray<ICLabelAttachment *> *attachmentList;//存储附件的数组
#endif

@end

@implementation ICLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __setupInit];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self __setupInit];
    }
    return self;
}

#pragma mark - Private method
- (void)__setupInit {
    
    _isNeedRelayout = YES;
    self.userInteractionEnabled = NO; // default is NO
    
    _truncationToken = [[NSAttributedString alloc] initWithString:kEllipsisCharacter];

#if kIS_SUPPORT_TOUCH
    _curHightlight = nil;
#endif
    
#if kIS_SUPPORT_ATTACHMENT
    _attachmentList = [[NSMutableArray alloc] init];
#endif
    
}

- (void)__resetFrameWithString:(NSAttributedString *)attrString rect:(CGRect)rect {
    if (_ctFrame == nil || _isNeedRelayout) {
        _framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, nil, rect);
        _ctFrame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), path, NULL);
        _ctLines = CTFrameGetLines(_ctFrame);
        
        //begin - 主要是为了解决 sizeThatFits: 计算出最适合的宽度的时候，_ctLines 的数量恒等于 _numberOfLines 的情况，导致判断不了【展开】按钮是否需要显示
        CGMutablePathRef innerPath = CGPathCreateMutable();
        CGPathAddRect(innerPath, nil, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, CGFLOAT_MAX)); //暂时只支持宽度固定，计算高度的情景
        __innerUseCTFrame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), innerPath, NULL);
        CFArrayRef __innerCTLines = CTFrameGetLines(__innerUseCTFrame);
        __innerNumberOfLines = CFArrayGetCount(__innerCTLines); // 计算出实际需要的行数
        //end
        
        CGPathRelease(path);
        CGPathRelease(innerPath);
        
        _isNeedRelayout = NO;
    }
}

- (NSInteger)__calcNumberOfLine {
    NSInteger numberOfLines = CFArrayGetCount(_ctLines);
    numberOfLines = _numberOfLines > 0 ? MIN(_numberOfLines, numberOfLines) : numberOfLines;
    return numberOfLines;
}

- (BOOL)__isMoreThanNumberOfLineLimit {
    if (_numberOfLines == 0) return NO;
    if (_numberOfLines >= __innerNumberOfLines) return NO;
    return YES;
}

#if kIS_SUPPORT_TOUCH
- (CFIndex)__getClostestIndex:(CGPoint)touchPoint {
    CFIndex retIndex = kCFNotFound;
    if (!_ctLines) return retIndex;
    
    //这里处理获取被点击区域的 CFIndex 坐标
    NSInteger lineCount = CFArrayGetCount(_ctLines);
    CGPoint origins[lineCount];
    if (lineCount >= 0) {
        CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, 0), origins);
        for (int i = 0; i < lineCount; i++) {
            CGPoint baselineOrigin = origins[i];
            CTLineRef line = CFArrayGetValueAtIndex(_ctLines, i);
            CGRect lineFrame = [self __getLineBoundsWithLine:line baseLineOrigin:baselineOrigin];
            if (CGRectContainsPoint(lineFrame, touchPoint)) { //这里确定点击的行数，然后对应的找到该行被点击的文字在该行中的位置
                CFIndex tapIndex = CTLineGetStringIndexForPosition(line, touchPoint);
                CFIndex targetIndex = tapIndex;

                if (tapIndex != kCFNotFound) {
                    CFRange thisLineRange = CTLineGetStringRange(line);
                    NSAttributedString *thisLineAttr = [_attributedText attributedSubstringFromRange:NSMakeRange(thisLineRange.location, thisLineRange.length)];
                    NSAttributedString *tapAttr = nil;
                    if (tapIndex - thisLineRange.location >=0 && tapIndex - thisLineRange.location < thisLineAttr.length) {
                        tapAttr = [thisLineAttr attributedSubstringFromRange:NSMakeRange(tapIndex - thisLineRange.location, 1)];
                    }
                    
                    ICLog(@"thisLineAttr: %@", thisLineAttr.string);
                    ICLog(@"lineFrame- %@ touchPoint- %@", [NSValue valueWithCGRect:lineFrame], [NSValue valueWithCGPoint:touchPoint]);
                    ICLog(@"lineIndex: %d tapIndex: %ld tapAttr: %@", i, tapIndex, tapAttr.string);
                    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, tapIndex, NULL);
                    ICLog(@"tapIndex str(%@) xOffset: %lf touchPoint.x: %lf", tapAttr.string, xOffset, touchPoint.x);
                    
                    CFIndex fixedIndex = tapIndex;
                    if (touchPoint.x - xOffset > FLT_MIN) {
                        if (tapIndex - thisLineRange.location + 1 < thisLineAttr.length) {
                            tapAttr = [thisLineAttr attributedSubstringFromRange:NSMakeRange(tapIndex - thisLineRange.location + 1, 1)];
                        } else {
                            tapAttr = nil;
                        }
                        ICLog(@"【fix】往右 + 1， newTapIndex: %ld tapAttr: %@", tapIndex + 1, tapAttr.string);
                        fixedIndex = tapIndex + 1;
                    } else {
                        if (tapIndex - thisLineRange.location - 1 >= 0) {
                            tapAttr = [thisLineAttr attributedSubstringFromRange:NSMakeRange(tapIndex - thisLineRange.location - 1, 1)];
                        } else {
                            tapAttr = nil;
                        }
                        ICLog(@"【fix】往左 - 1， newTapIndex: %ld tapAttr: %@", tapIndex - 1, tapAttr.string);
                        fixedIndex = tapIndex - 1;
                    }
                    
                    targetIndex = MIN(fixedIndex, tapIndex); //TODO: 这里应该是点击事件的处理，并且要处理存在 emoji 的情况
                    if (targetIndex >= 0 && targetIndex < thisLineAttr.length) {
                        tapAttr = [thisLineAttr attributedSubstringFromRange:NSMakeRange(targetIndex, 1)];
                    }
                    ICLog(@"targetIndex: %ld 最后识别的文字：%@", targetIndex, tapAttr.string);
                }
                return targetIndex;
            }
        }
    }
    return retIndex;
}

/// 该方法的坐标系已转换成 UIKit 的坐标系了
- (CGRect)__getLineBoundsWithLine:(CTLineRef)line baseLineOrigin:(CGPoint)baseLineOrigin {
    CGFloat descender, ascender, leading = 0;
    CGFloat lineWidth = CTLineGetTypographicBounds(line,
                                                   &ascender,
                                                   &descender,
                                                   &leading);//获取该行的宽度
    //坐标系的问题，坐标原点是左下角的，所以这里需要将坐标转换成 UIKit 坐标系
    CGRect lineFrame = CGRectMake(baseLineOrigin.x,
                                  CGRectGetHeight(self.bounds) - baseLineOrigin.y - ascender,
                                  lineWidth,
                                  ascender + fabs(descender));
    return lineFrame;
}

#endif

#if kIS_SUPPORT_ATTACHMENT
- (void)__drawAttachmentsWithRect:(CGRect)rect {
    
    [_attachmentList enumerateObjectsUsingBlock:^(ICLabelAttachment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.content isKindOfClass:[UIView class]]) {
            UIView *attachmentView = obj.content;
            if (attachmentView.superview == self) {
                [attachmentView removeFromSuperview];
            }
        } else if ([obj.content isKindOfClass:[CALayer class]]) {
            CALayer *attachmentLayer = obj.content;
            if (attachmentLayer.superlayer == self.layer) {
                [attachmentLayer removeFromSuperlayer];
            }
        }
    }];
    [_attachmentList removeAllObjects]; //reset all
    
    if (!_ctFrame) return;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    if (!contextRef) return;
    NSInteger numberOfLines = [self __calcNumberOfLine]; //实际需要的绘制行数
    
    CFArrayRef lineList = CTFrameGetLines(_ctFrame);
    CGPoint lineOriginList[numberOfLines];
    CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, numberOfLines), lineOriginList); //注意该坐标的原点是左下角的
    
    for (CFIndex i = 0; i < numberOfLines; i++) {
        CTLineRef ctLine = CFArrayGetValueAtIndex(lineList, i);
        CGPoint ctLineOriginPoint = lineOriginList[i];
        
        CGFloat lineAscent = 0;
        CGFloat lineDescent = 0;
        CGFloat lineLeading = 0;
        CGFloat lineWidth = CTLineGetTypographicBounds(ctLine, &lineAscent, &lineDescent, &lineLeading);
        
#ifdef DEBUG
        if (kIsInDebugMode) {
            UIView *baselineView = [[UIView alloc] initWithFrame:CGRectMake(ctLineOriginPoint.x,
                                                                            rect.size.height - ctLineOriginPoint.y,
                                                                            lineWidth,
                                                                            1)];
            baselineView.backgroundColor = (i == 0 ? [UIColor redColor] : [UIColor blueColor]);
            [self addSubview:baselineView];
            
            UIView *capHeightView = [[UIView alloc] initWithFrame:CGRectMake(ctLineOriginPoint.x,
                                                                             rect.size.height - ctLineOriginPoint.y - self.font.capHeight,
                                                                             lineWidth, 1)];
            capHeightView.backgroundColor = [UIColor blackColor];
            [self addSubview:capHeightView];
            
            UIView *descenderView = [[UIView alloc] initWithFrame:CGRectMake(ctLineOriginPoint.x,
                                                                             rect.size.height - ctLineOriginPoint.y + lineDescent,
                                                                             lineWidth,
                                                                             1)];
            descenderView.backgroundColor = [UIColor greenColor];
            [self addSubview:descenderView];
            
            UIView *ascenderView = [[UIView alloc] initWithFrame:CGRectMake(ctLineOriginPoint.x,
                                                                            rect.size.height - ctLineOriginPoint.y - lineAscent,
                                                                            lineWidth,
                                                                            1)];
            ascenderView.backgroundColor = [UIColor orangeColor];
            [self addSubview:ascenderView];
            
            UIView *leadingView = [[UIView alloc] initWithFrame:CGRectMake(ctLineOriginPoint.x,
                                                                           rect.size.height - ctLineOriginPoint.y + lineDescent + lineLeading,
                                                                           lineWidth,
                                                                           1)];
            leadingView.backgroundColor = [UIColor brownColor];
            [self addSubview:leadingView];
        }
#endif

        if (_numberOfLines > 0) { //检测是否需要对截断的 truncationToken 进行附件的绘制动作
            BOOL isMoreThanNumberOfLineLimit = [self __isMoreThanNumberOfLineLimit];
            if (isMoreThanNumberOfLineLimit && i == numberOfLines - 1) {
                CFRange curLineRange = CTLineGetStringRange(ctLine);
                NSMutableAttributedString *curLineAttrStr = [[_attributedText attributedSubstringFromRange:NSMakeRange(curLineRange.location, curLineRange.length)] mutableCopy]; //这一行中需要进行裁剪的 str 位置
                ICLabelAttachment *attachment = [ICLabelDrawService drawTrunctionTokenWithCTX:contextRef
                                                                                        label:self
                                                                                         rect:rect
                                                                                       ctLine:ctLine
                                                                                  curLineAttr:curLineAttrStr
                                                                           trunctionTokenAttr:self.truncationToken
                                                                                lineBreakMode:self.lineBreakMode
                                                                            ctLineOriginPoint:ctLineOriginPoint];
                if (attachment) {
                    [self.attachmentList addObject:attachment];
                }
            }
        }
        
        CFArrayRef glyphRunList = CTLineGetGlyphRuns(ctLine);
        CFIndex glyphRunCount = CFArrayGetCount(glyphRunList);
        
        for (CFIndex runIndex = 0; runIndex < glyphRunCount; runIndex++) {
            CTRunRef ctRun = CFArrayGetValueAtIndex(glyphRunList, runIndex);
            NSDictionary *runAttrDict = (NSDictionary *)CTRunGetAttributes(ctRun);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttrDict valueForKey:(__bridge NSString *)kCTRunDelegateAttributeName];
            
            if (!delegate) continue;
            
            ICLabelAttachment *attachment = (ICLabelAttachment *)CTRunDelegateGetRefCon(delegate);
            if (attachment) {
                [self.attachmentList addObject:attachment];
            }
            
            CGFloat runAscent = 0;
            CGFloat runDescent = 0;
            CGFloat runLeading = 0;
            CTRunGetTypographicBounds(ctRun, CFRangeMake(0, 0), &runAscent, &runDescent, &runLeading);

            CGFloat runOriginalXOffset = CTLineGetOffsetForStringIndex(ctLine, CTRunGetStringRange(ctRun).location, NULL); //该 glyRun 的 x 坐标
            UIEdgeInsets attachmentInsets = attachment.contentInsets;
            CGSize contentSize = attachment.contentSize;
            
            CGFloat attachmentOriginX = ctLineOriginPoint.x + runOriginalXOffset + attachmentInsets.left; //该坐标系已经转换成了 UIKit 坐标系
            CGFloat attachmentOriginY = self.frame.size.height - ctLineOriginPoint.y - runAscent + attachmentInsets.top;
            
            CGRect attachmentFrame = CGRectMake(attachmentOriginX, //UIKit 坐标系计算出来的结果
                                                attachmentOriginY,
                                                contentSize.width,
                                                contentSize.height);
            
            if ([attachment.content isKindOfClass:[UIImage class]]) { //处理 UIImage 的类型, 使用的是 CoreText 的坐标系来计算
                UIImage *attachmentImage = attachment.content;
                attachmentOriginY = ctLineOriginPoint.y - runDescent + attachmentInsets.bottom;

                attachmentFrame = CGRectMake(attachmentOriginX,
                                             attachmentOriginY,
                                             contentSize.width,
                                             contentSize.height);

                CGContextSaveGState(contextRef);
                CGContextDrawImage(contextRef, attachmentFrame, attachmentImage.CGImage); //这个坐标系还是在左下角的
                CGContextRestoreGState(contextRef);

            } else if ([attachment.content isKindOfClass:[UIView class]]) { //处理 UIView 的类型
                UIView *attachmentView = attachment.content;
                attachmentView.frame = attachmentFrame;
                attachmentView.userInteractionEnabled = NO;
                if (attachmentView.superview == nil) { //防止重复添加
                    [self addSubview:attachmentView];
                }
            } else if ([attachment.content isKindOfClass:[CALayer class]]) { //处理 CALayer 的类型
                CALayer *attachmentLayer = attachment.content;
                attachmentLayer.frame = attachmentFrame;
                if (attachmentLayer.superlayer == nil) { //防止重复添加
                    [self.layer addSublayer:attachmentLayer];
                }
            }
        }
    }
    UIGraphicsEndImageContext();
}
#endif

- (void)__drawText:(NSAttributedString *)attrString rect:(CGRect)rect context:(CGContextRef)context {
    if (_ctFrame == nil) return;
    
    if (_numberOfLines > 0) {
        NSInteger numberOfLines = [self __calcNumberOfLine];
        CGPoint lineOriginPoints[numberOfLines];
        CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, numberOfLines), lineOriginPoints);
        BOOL isMoreThanNumberOfLineLimit = [self __isMoreThanNumberOfLineLimit];
        
        for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
            CTLineRef line = CFArrayGetValueAtIndex(_ctLines, lineIndex);
            CGPoint lineOrigins = lineOriginPoints[lineIndex];
            
            CGContextSetTextPosition(context, lineOrigins.x, lineOrigins.y);//更新一下 context 中的起始坐标，若该行坐标出现了问题就会导致出错行的位置错乱

            if (isMoreThanNumberOfLineLimit && lineIndex == numberOfLines - 1) {
                CFRange curLineRange = CTLineGetStringRange(line);
                NSAttributedString *trunctionTokenAttrStr = [self.truncationToken mutableCopy];
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
                CTLineDraw(line, context);
            }
        }
    } else {
        //粗粒度的进行绘制操作
        CTFrameDraw(_ctFrame, context);
    }
}

#pragma mark - Override method
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 坐标转换
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == nil) return;
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.attributedText && self.attributedText.length > 0) {
        [self __resetFrameWithString:self.attributedText rect:rect];//检测 CTFrame 参数是否已更新
#if kIS_SUPPORT_ATTACHMENT
        [self __drawAttachmentsWithRect:rect];//绘制附件
#endif
        [self __drawText:self.attributedText rect:rect context:context];//绘制文字
    }
    
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
}

- (void)dealloc {
    if (_ctFrame) { CFRelease(_ctFrame); }
    if (__innerUseCTFrame) { CFRelease(__innerUseCTFrame); }
    if (_framesetter) { CFRelease(_framesetter); }
}

#pragma mark - Event handler
#if kIS_SUPPORT_TOUCH
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.curHightlight == nil) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint locationInView = [touch locationInView:touch.view];
#if DEBUG
        [self __touchPointView:NO centerPoint:locationInView];
#endif
        if (self.curHightlight == nil) {
            CFIndex clostestIndex = [self __getClostestIndex:locationInView];
            if (clostestIndex != kCFNotFound) {
                NSDictionary *dict = [self.attributedText attributesAtIndex:clostestIndex longestEffectiveRange:nil inRange:NSMakeRange(0, self.attributedText.length)];
                ICHighlight *hightlight = dict[ICTextHighlightAttributeName];
                self.curHightlight = hightlight;
            }
        }
    }
    
    if (self.curHightlight) {
        [self setNeedsDisplay];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint locationInView = [touch locationInView:touch.view];
#if DEBUG
    [self __touchPointView:NO centerPoint:locationInView];
#endif
    
    CFIndex clostestIndex = [self __getClostestIndex:locationInView];
    if (clostestIndex != kCFNotFound) {
        NSDictionary *dict = [self.attributedText attributesAtIndex:clostestIndex longestEffectiveRange:nil inRange:NSMakeRange(0, self.attributedText.length)];
        ICHighlight *hightlight = dict[ICTextHighlightAttributeName];
        self.curHightlight = hightlight;
    } else {
        self.curHightlight = nil;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
#if DEBUG
    [self __touchPointView:YES centerPoint:CGPointZero];
#endif
    if (self.curHightlight.tapAction) {
        self.curHightlight.tapAction();
        self.curHightlight = nil; //reset
        
        [self setNeedsDisplay];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
#if DEBUG
    [self __touchPointView:YES centerPoint:CGPointZero];
#endif
    if (self.curHightlight) {
        self.curHightlight = nil;
        [self setNeedsDisplay];
    }
    
    [super touchesCancelled:touches withEvent:event];
}
#endif

#pragma mark - Public method
- (CGSize)sizeThatFits:(CGSize)size {
    
    if (_attributedText == nil || _attributedText.length <= 0) return CGSizeZero;
    NSAttributedString *drawAttributedString = [_attributedText copy];
    
    //该方法调用的时候 drawRect: 方法有可能还没有被调用，所以这里创建一个临时的局部变量
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)drawAttributedString);
    CFRange stringRange = CFRangeMake(0, 0);
    
    if (_numberOfLines > 0 && framesetter) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, nil, CGRectMake(0, 0, size.width, size.height));
        CTFrameRef ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil);
        
        CFArrayRef ctLines = CTFrameGetLines(ctFrame);
        NSInteger lineCount = CFArrayGetCount(ctLines);
        
        if (lineCount > 0) {
            NSInteger lastVisibleLineIndex = MIN(_numberOfLines, lineCount) - 1;
            CTLineRef lastCTLine = CFArrayGetValueAtIndex(ctLines, lastVisibleLineIndex);//最后一行 CTLine 对象
            CFRange lastCTLineRange = CTLineGetStringRange(lastCTLine);
            stringRange = CFRangeMake(stringRange.location, lastCTLineRange.location + lastCTLineRange.length + stringRange.length);
        }
        
        CGPathRelease(path);
        CFRelease(ctFrame);
    }
    
    //该接口计算出来的宽度有那么一丢丢不准确(现象就是靠右边的文字或者emoji会绘制不出来)，所以暂时使用 ceilf 来向上取整，但是高度就暂时没有发现有计算不准确的现象发现~
    //高度的话也有可能会有不准的时候，例如 ...展开 字体为 UIFont.systemFont(size:15) 这种属性，高度并没有 sizeToFits 的形式
    CFRange fixRange = CFRangeMake(0, 0);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, stringRange, nil, size, &fixRange);
    
    if (framesetter) {
        CFRelease(framesetter);
    }

    return CGSizeMake(ceilf(coreTextSize.width), ceilf(coreTextSize.height));
}

- (void)relayoutText {
    _isNeedRelayout = YES;
    [self setNeedsDisplay];
}

#pragma mark - Getter/setter
- (void)setAttributedText:(NSMutableAttributedString *)attributedString {
    if (![attributedString isEqualToAttributedString:_attributedText]) {
        _attributedText = attributedString;
        [self relayoutText];
    }
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    if (_numberOfLines != numberOfLines) {
        _numberOfLines = numberOfLines;
        [self relayoutText];
    }
}

- (void)setTruncationToken:(NSAttributedString *)truncationToken {
    _truncationToken = truncationToken;
    [self relayoutText];
}

@end

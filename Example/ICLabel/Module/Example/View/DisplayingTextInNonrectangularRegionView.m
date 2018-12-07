//
//  DisplayingTextInNonrectangularRegionView.m
//  iOSExample
//
//  Created by iCrany on 2017/10/31.
//  Copyright © 2017 iCrany. All rights reserved.
//

#import "DisplayingTextInNonrectangularRegionView.h"
#import <CoreText/CTFont.h>
#import <CoreText/CTLine.h>
#import <CoreText/CTStringAttributes.h>
#import <CoreText/CTFramesetter.h>

@implementation DisplayingTextInNonrectangularRegionView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

// Create a path in the shape of a donut.
static void AddSquashedDonutPath(CGMutablePathRef path, const CGAffineTransform *m, CGRect rect) {
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);

    CGFloat radiusH = width / 3.0;
    CGFloat radiusV = height / 3.0;

    CGPathMoveToPoint(path, m, rect.origin.x, rect.origin.y + height - radiusV);
    CGPathAddQuadCurveToPoint(path, m, rect.origin.x, rect.origin.y + height,
            rect.origin.x + radiusH, rect.origin.y + height);
    CGPathAddLineToPoint(path, m, rect.origin.x + width - radiusH,
            rect.origin.y + height);
    CGPathAddQuadCurveToPoint(path, m, rect.origin.x + width,
            rect.origin.y + height,
            rect.origin.x + width,
            rect.origin.y + height - radiusV);
    CGPathAddLineToPoint(path, m, rect.origin.x + width,
            rect.origin.y + radiusV);
    CGPathAddQuadCurveToPoint(path, m, rect.origin.x + width, rect.origin.y,
            rect.origin.x + width - radiusH, rect.origin.y);
    CGPathAddLineToPoint(path, m, rect.origin.x + radiusH, rect.origin.y);
    CGPathAddQuadCurveToPoint(path, m, rect.origin.x, rect.origin.y,
            rect.origin.x, rect.origin.y + radiusV);
    CGPathCloseSubpath(path);

    CGPathAddEllipseInRect(path, m,
            CGRectMake(rect.origin.x + width / 2.0 - width / 5.0,
                    rect.origin.y + height / 2.0 - height / 5.0,
                    width / 5.0 * 2.0, height / 5.0 * 2.0));
}

// Generate the path outside of the drawRect call so the path is calculated only once.
- (NSArray *)paths {
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, 10.0, 10.0);
    AddSquashedDonutPath(path, NULL, bounds);

    NSMutableArray *result = [NSMutableArray arrayWithObject:CFBridgingRelease(path)];
    return result;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    // Initialize a graphics context in iOS.
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Flip the context coordinates in iOS only.
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    // Set the text matrix.
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);

    // Initialize an attributed string.
    CFStringRef textString = CFSTR("Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.");

    // Create a mutable attributed string.
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);

    // Copy the textString into the newly created attrString.
    CFAttributedStringReplaceString(attrString, CFRangeMake(0, 0), textString);

    // Create a color that will be added as an attribute to the attrString.
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {1.0, 0.0, 0.0, 0.8};
    CGColorRef red = CGColorCreate(rgbColorSpace, components);
    CGColorSpaceRelease(rgbColorSpace);

    // Set the color of the first 13 chars to red.
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, 13), kCTForegroundColorAttributeName, red);

    // Create the framesetter with the attributed string.
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);

    // Create the array of paths in which to draw the text.
    NSArray *paths = [self paths];

    CFIndex startIndex = 0;

    // In OS X, use NSColor instead of UIColor.
#define GREEN_COLOR [UIColor greenColor]
#define YELLOW_COLOR [UIColor yellowColor]
#define BLACK_COLOR [UIColor blackColor]

    // Set the background of the path to green.
    CGContextSetFillColorWithColor(context, [GREEN_COLOR CGColor]);

    // For each path in the array of paths...
    for (id object in paths) {
        CGPathRef path = (__bridge CGPathRef) object;

        CGContextAddPath(context, path);
        CGContextFillPath(context);

        CGContextDrawPath(context, kCGPathStroke);

        // Create a frame for this path and draw the text.
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(startIndex, 0), path, NULL);
        CTFrameDraw(frame, context);

        // Start the next frame at the first character not visible in this frame.
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        startIndex += frameRange.length;
        CFRelease(frame);
    }

#undef GREEN_COLOR
#undef YELLOW_COLOR
#undef BLACK_COLOR

    CFRelease(attrString);
    CFRelease(framesetter);
}

@end

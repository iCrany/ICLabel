//
//  ColumnarLayoutView.m
//  iOSExample
//
//  Created by iCrany on 2017/10/31.
//  Copyright © 2017 iCrany. All rights reserved.
//

#import "ColumnarLayoutView.h"
#import <CoreText/CTFont.h>
#import <CoreText/CTLine.h>
#import <CoreText/CTStringAttributes.h>
#import <CoreText/CTFramesetter.h>

@implementation ColumnarLayoutView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

/**
 * 这里只是定义列数的，每一列的宽度就是屏幕的宽度 / 列数
 */
- (CFArrayRef)createColumnsWithColumnCount:(int)columnCount {
    int column;

    CGRect *columnRects = (CGRect *) calloc(columnCount, sizeof(*columnRects));
    // Set the first column to cover the entire view.
    columnRects[0] = self.bounds;

    // Divide the columns equally across the frame's width.
    CGFloat columnWidth = CGRectGetWidth(self.bounds) / columnCount;
    for (column = 0; column < columnCount - 1; column++) {
        NSLog(@"columnRects[%d]: %@", column, [NSValue valueWithCGRect:columnRects[column]]);
        CGRectDivide(columnRects[column], &columnRects[column], &columnRects[column + 1], columnWidth, CGRectMinXEdge);
        NSLog(@"columnRects[%d]: %@, columnRects[%d]: %@", column, [NSValue valueWithCGRect:columnRects[column]], column + 1, [NSValue valueWithCGRect:columnRects[column + 1]]);
    }

    // Inset all columns by a few pixels of margin.
    for (column = 0; column < columnCount; column++) {
        columnRects[column] = CGRectInset(columnRects[column], 8.0, 15.0);
    }

    // Create an array of layout paths, one for each column.
    CFMutableArrayRef array = CFArrayCreateMutable(kCFAllocatorDefault, columnCount, &kCFTypeArrayCallBacks);

    for (column = 0; column < columnCount; column++) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, columnRects[column]);
        NSLog(@"columnRects[%d]: %@", column, [NSValue valueWithCGRect:columnRects[column]]);
        CFArrayInsertValueAtIndex(array, column, path);
        CFRelease(path);
    }
    free(columnRects);
    return array;
}

// Override drawRect: to draw the attributed string into columns.
// (In OS X, the drawRect: method of NSView takes an NSRect parameter,
//  but that parameter is not used in this listing.)
- (void)drawRect:(CGRect)rect {

    NSLog(@"ColumnarLayoutView drawRect bounds: %@", [NSValue valueWithCGRect:self.bounds]);
    // Initialize a graphics context in iOS.
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Flip the context coordinates in iOS only.
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    // Initializing a graphic context in OS X is different:
    // CGContextRef context =
    //     (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];

    // Set the text matrix.
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);

    // Create a descriptor.
    NSDictionary *fontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
            @"Courier", (NSString *) kCTFontFamilyNameAttribute,
            @"Bold", (NSString *) kCTFontStyleNameAttribute,
            [NSNumber numberWithFloat:16.0], (NSString *) kCTFontSizeAttribute,
                    nil];
    CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef) fontAttributes);

    // Create a font using the descriptor.
    CTFontRef font = CTFontCreateWithFontDescriptor(descriptor, 0.0, NULL);
    CFRelease(descriptor);

    CFStringRef keys[] = {kCTFontAttributeName};
    CFTypeRef values[] = {font};

    CFStringRef string = CFSTR("Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.");
    CFDictionaryRef attributes = CFDictionaryCreate(kCFAllocatorDefault, (const void **) &keys, (const void **) &values, sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);

    CFAttributedStringRef attrString = CFAttributedStringCreate(kCFAllocatorDefault, string, attributes);

    // Create the framesetter with the attributed string.
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef) attrString);

    // Call createColumnsWithColumnCount function to create an array of
    // three paths (columns).
    CFArrayRef columnPaths = [self createColumnsWithColumnCount:1];

    CFIndex pathCount = CFArrayGetCount(columnPaths);
    CFIndex startIndex = 0;
    int column;

    // Create a frame for each column (path).
    for (column = 0; column < pathCount; column++) {
        // Get the path for this column.
        CGPathRef path = (CGPathRef) CFArrayGetValueAtIndex(columnPaths, column);

        // Create a frame for this column and draw it.
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(startIndex, 0), path, NULL);
        CTFrameDraw(frame, context);

        // Start the next frame at the first character not visible in this frame.
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        startIndex += frameRange.length;
        CFRelease(frame);

    }
    CFRelease(columnPaths);
    CFRelease(framesetter);
}

@end

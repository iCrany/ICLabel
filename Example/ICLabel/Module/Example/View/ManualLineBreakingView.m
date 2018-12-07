//
//  ManualLineBreakingView.m
//  iOSExample
//
//  Created by iCrany on 2017/10/31.
//  Copyright © 2017 iCrany. All rights reserved.
//

#import "ManualLineBreakingView.h"
#import <CoreText/CTFont.h>
#import <CoreText/CTLine.h>
#import <CoreText/CTStringAttributes.h>
#import <CoreText/CTFramesetter.h>

@implementation ManualLineBreakingView

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

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    // Flip the context coordinates in iOS only.
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    // Initializing a graphic context in OS X is different:
    // CGContextRef context =
    //     (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];

    // Set the text matrix.
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);

    double width = self.bounds.size.width;
    // Create a descriptor.
    NSDictionary *fontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
            @"Courier", (NSString *) kCTFontFamilyNameAttribute,
            @"Bold", (NSString *) kCTFontStyleNameAttribute,
            [NSNumber numberWithFloat:16.0],
            (NSString *) kCTFontSizeAttribute,
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

    // Create a typesetter using the attributed string.
    CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString(attrString);

    // Find a break for line from the beginning of the string to the given width.
    CFIndex start = 0;

    NSUInteger strLength = ((__bridge NSString *)string).length;
    double yOffset = 20.0;
    CGPoint textPosition = CGPointZero;

    while (start < strLength) {
        CFIndex count = CTTypesetterSuggestLineBreak(typesetter, start, width);

        // Use the returned character count (to the break) to create the line.
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));

        // Get the offset needed to center the line.
        float flush = 0.5; // centered
//        flush = 0.0;//left, 左对齐
//        flush = 1.0;//right，右对齐
        double penOffset = CTLineGetPenOffsetForFlush(line, flush, width);
        textPosition.y = textPosition.y + yOffset;//设置 frame 的参数

        NSLog(@"textPosition: %@", [NSValue valueWithCGPoint:textPosition]);
        NSLog(@"ManualLineBreakingView count: %ld, (%lf, %lf)", count, textPosition.x + penOffset, textPosition.y);

        // Move the given text drawing position by the calculated offset and draw the line.
        CGContextSetTextPosition(context, textPosition.x + penOffset, self.bounds.size.height - textPosition.y);
        CTLineDraw(line, context);

        // Move the index beyond the line break.
        start += count;
    }

    NSLog(@"start: %ld length: %ld", start, strLength);
}

@end

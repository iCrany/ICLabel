//
//  SimpleTextLabelView.m
//  iOSExample
//
//  Created by iCrany on 2017/10/31.
//  Copyright © 2017 iCrany. All rights reserved.
//

#import "SimpleTextLabelView.h"
#import <CoreText/CTFont.h>
#import <CoreText/CTLine.h>
#import <CoreText/CTStringAttributes.h>

@implementation SimpleTextLabelView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    // Initialize the string, font, and context
    CFStringRef string = CFSTR("Hello, World! I know nothing.");
    CTFontRef font;
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Flip the context coordinates, in iOS only.
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    // Set the text matrix.
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);

    // Create a descriptor.
    NSDictionary *fontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
            @"Courier", (NSString *) kCTFontFamilyNameAttribute,
            @"Bold", (NSString *) kCTFontStyleNameAttribute,
            [NSNumber numberWithFloat:16.0],
            (NSString *) kCTFontSizeAttribute,
                    nil];
    CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef) fontAttributes);

    // Create a font using the descriptor.
    font = CTFontCreateWithFontDescriptor(descriptor, 0.0, NULL);
    CFRelease(descriptor);

    CFStringRef keys[] = {kCTFontAttributeName};
    CFTypeRef values[] = {font};

    CFDictionaryRef attributes = CFDictionaryCreate(kCFAllocatorDefault, (const void **) &keys, (const void **) &values, sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);

    CFAttributedStringRef attrString = CFAttributedStringCreate(kCFAllocatorDefault, string, attributes);
    CFRelease(string);

    CTLineRef line = CTLineCreateWithAttributedString(attrString);

    // Set text position and draw the line into the graphics context
    CGContextSetTextPosition(context, 10.0, self.bounds.size.height - 20.0);
    CTLineDraw(line, context);
    CFRelease(line);

}


@end

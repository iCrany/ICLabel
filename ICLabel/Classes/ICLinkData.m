//
//  ICLinkData.m
//  iOSExample
//
//  Created by iCrany on 2018/8/21.
//  Copyright © 2018年 iCrany. All rights reserved.
//

#import "ICLinkData.h"

@interface ICLinkData()

@property (nonatomic, strong) NSString *linkStr;

@end

@implementation ICLinkData

- (instancetype)initWithLinkStr:(NSString *)linkStr
                      linkRange:(NSRange)linkRange {
    self = [super init];
    if (self) {
        self.linkStr = linkStr;
        self.linkRange = linkRange;
        self.linkFont = [UIFont systemFontOfSize:15];
        self.linkColor = [UIColor blueColor];
        self.responseLinkRange = NSMakeRange(0, self.linkStr.length);
    }
    return self;
}

- (instancetype)initWithLinkStr:(NSString *)linkStr
                      linkRange:(NSRange)linkRange
              responseLinkRange:(NSRange)responseLinkRange {
    self = [self initWithLinkStr:linkStr linkRange:linkRange];
    if (self) {
        self.responseLinkRange = responseLinkRange;
    }
    return self;
}

- (instancetype)initWithLinkStr:(NSString *)linkStr
                      linkRange:(NSRange)linkRange
                       linkFont:(UIFont *)linkFont
                      linkColor:(UIColor *)linkColor {
    self = [self initWithLinkStr:linkStr linkRange:linkRange];
    if (self) {
        self.linkFont = linkFont;
        self.linkStr = linkStr;
    }
    return self;
}

#pragma mark - Override method

@end

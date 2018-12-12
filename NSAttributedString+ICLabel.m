//
//  NSAttributedString+ICLabel.m
//  DTCoreText
//
//  Created by iCrany on 2018/12/12.
//

#import "NSAttributedString+ICLabel.h"
#import "NSMutableAttributedString+ICLabel.h"

@implementation NSAttributedString (ICLabel)

- (CGRect)ic_boundRectWithSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines {
    NSMutableAttributedString *attrStr = [self mutableCopy];
    return [attrStr ic_boundRectWithSize:size numberOfLines:numberOfLines];
}

@end

//
//  ICLayoutFrame.h
//  ICLabel
//
//  Created by iCrany on 2019/4/23.
//

#import <Foundation/Foundation.h>

@class ICLayouter;
NS_ASSUME_NONNULL_BEGIN

@interface ICLayoutFrame : NSObject

@property (nonatomic, strong) NSAttributedString *attributedText;
@property (nonatomic, strong) NSAttributedString *truncationToken;

- (instancetype)initWithFrame:(CGRect)frame
                     layouter:(ICLayouter *)layouter
                        range:(NSRange)range;

- (void)drawInContext:(CGContextRef)context rect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END

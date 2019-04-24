//
//  ICLayouter.h
//  ICLabel
//
//  Created by iCrany on 2019/4/23.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@class ICLayoutFrame;

NS_ASSUME_NONNULL_BEGIN

@interface ICLayouter : NSObject

@property (nonatomic, strong) NSAttributedString *attributedString;

@property (nonatomic, readonly) CTFramesetterRef framesetter;

- (ICLayoutFrame *)layoutFrameWithRect:(CGRect)frame range:(NSRange)range;

@end

NS_ASSUME_NONNULL_END

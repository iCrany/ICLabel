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

- (instancetype)initWithFrame:(CGRect)frame
                     layouter:(ICLayouter *)layouter
                        range:(NSRange)range;

@end

NS_ASSUME_NONNULL_END

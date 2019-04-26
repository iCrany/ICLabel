//
//  ICGlyphRun.h
//  ICLabel
//
//  Created by iCrany on 2019/4/23.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICGlyphRun : NSObject

- (instancetype)initWithRun:(CTRunRef)run drawRect:(CGRect)drawRect;

@end

NS_ASSUME_NONNULL_END

//
//  ICLayoutLine.h
//  ICLabel
//
//  Created by iCrany on 2019/4/23.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICLayoutLine : NSObject

@property (nonatomic, readonly, assign) CFRange stringRange;

- (instancetype)initWithLine:(CTLineRef)ctLine;

- (void)drawInContext:(CGContextRef)context;

@end

NS_ASSUME_NONNULL_END

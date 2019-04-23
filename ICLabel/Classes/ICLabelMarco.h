//
//  ICLabelMarco.h
//  ICLabel
//
//  Created by iCrany on 2018/9/27.
//  Copyright © 2018年 iCrany. All rights reserved.
//

#ifndef ICLabelMarco_h
#define ICLabelMarco_h

static NSString *const kEllipsisCharacter = @"\u2026";
static unichar kPlaceHolder = 0xFFFC;

/////////////////////// Custom NSAttributedStringKey ///////////////////////
static NSString *const ICTextHighlightAttributeName = @"ICTextHighlight";

#ifdef DEBUG
# define ICLog(format, ...) NSLog((@"" "[%s]" "[%d]" format), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define ICLog(...) do { } while (0)
#endif

// 是否支持附件的形式，可以用于减包
#define kIS_SUPPORT_ATTACHMENT 0

// 是否支持点击事件，可以用于减包
#define kIS_SUPPORT_TOUCH 0

// 是否需要 Category 中的一些便捷方法，可以用于减包
#define kIS_NEED_UTIL_METHOD 0

#endif /* ICLabelMarco_h */

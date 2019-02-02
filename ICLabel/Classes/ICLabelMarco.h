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

#endif /* ICLabelMarco_h */

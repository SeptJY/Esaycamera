//
//  JYNSString+Extension.m
//  Sept相机UI
//
//  Created by 王荣兴 on 15/11/19.
//  Copyright © 2015年 九月. All rights reserved.
//

#import "JYNSString+Extension.h"

@implementation NSString (Extension)

// 计算文字尺寸
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *arrts = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:arrts context:nil].size;
}

@end

//
//  JYLanguageTool.h
//  SeptOfCamera
//
//  Created by Sept on 15/12/28.
//  Copyright © 2015年 九月. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYLanguageTool : UIView

+ (NSBundle *)bundle;   // 获取当前资源文件

+ (void)initUserLanguage;   // 初始化语言文件

+ (NSString *)userLanguage;   // 获取应用当前语言

+ (void)setUserlanguage:(NSString *)language;   // 设置当前语言

@end

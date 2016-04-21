//
//  UIImage+CKExtension.h
//  YUME
//
//  Created by Chenjy on 15/8/21.
//  Copyright (c) 2015年 Vieach_Ckiney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CKExtension)
/**
 *  图片缩放
 *  @return
 */
//按固定的width等比例缩放（UIImage),返回CGSize
+ (CGSize)sizeWithImage:(UIImage *)sourceImage scaledToWidth:(float)width;
//按固定的i_height等比例缩放（UIImage）,返回CGSize
+ (CGSize)sizeWithHeightImage:(UIImage *)sourceImage scaledToWidth:(float)height;
//按固定的width等比例缩放（sourceSize）
+ (CGSize)sizeWithSize:(CGSize)sourceSize scaledToWidth:(float)width;
//按固定的height等比例缩放（sourceSize）
+ (CGSize)sizeWithHeightSize:(CGSize)sourceSize scaledToHeight:(float)height;
//按固定的width等比例缩放（UIImage）, 返回图片
+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float)width;

//用色值转换为图片
+ (UIImage *)imageWithColor:(UIColor *)color;

//图片中间等比例 拉伸
+ (UIImage *)middleStretchableImageWithKey:(NSString *)key;

//图片 角度 旋转
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

+ (instancetype)resizableWithImageName:(NSString *)imageName;

+ (UIImage *)getImage:(NSURL *)videoURL;


@end

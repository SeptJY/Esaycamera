//
//  UIImage+CKExtension.m
//  YUME
//
//  Created by Chenjy on 15/8/21.
//  Copyright (c) 2015年 Vieach_Ckiney. All rights reserved.
//

#import "UIImage+CKExtension.h"

#import <AVFoundation/AVFoundation.h>

@implementation UIImage (CKExtension)
//按固定的width等比例缩放（UIImage),返回CGSize
+ (CGSize)sizeWithImage:(UIImage *)sourceImage scaledToWidth:(float)width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    CGSize size = CGSizeMake(newWidth, newHeight);
    return size;
}
//按固定的i_height等比例缩放（UIImage）,返回CGSize
+ (CGSize)sizeWithHeightImage:(UIImage *)sourceImage scaledToWidth:(float)height
{
    float oldHeight = sourceImage.size.height;
    float scaleFactor = height / oldHeight;
    
    float newWight = sourceImage.size.width * scaleFactor;
    float newHeight = oldHeight * scaleFactor;
    
    CGSize size = CGSizeMake(newWight, newHeight);
    return size;
}
//按固定的width等比例缩放（sourceSize）
+ (CGSize)sizeWithSize:(CGSize)sourceSize scaledToWidth:(float)width
{
    float oldWidth = sourceSize.width;
    float scaleFactor = width / oldWidth;
    float newHeight = sourceSize.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    CGSize size = CGSizeMake(newWidth, newHeight);
    return size;
}
//按固定的height等比例缩放（sourceSize）
+ (CGSize)sizeWithHeightSize:(CGSize)sourceSize scaledToHeight:(float)height
{
    float oldHeight = sourceSize.height;
    float scaleFactor = height / oldHeight;
    float newWidth = sourceSize.width * scaleFactor;
    float newHeight = oldHeight * scaleFactor;
    CGSize size = CGSizeMake(newWidth,newHeight);
    return size;
}
//按固定的width等比例缩放（UIImage）, 返回图片
+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float)width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth - 2, newHeight - 2));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//图片中间等比例 拉伸
+ (UIImage *)middleStretchableImageWithKey:(NSString *)key;
{
    UIImage *image = [UIImage imageNamed:key];
    return [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
}

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (instancetype)resizableWithImageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    
}

// 通过URl获取一张图片
+ (UIImage *)getImage:(NSURL *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}

@end

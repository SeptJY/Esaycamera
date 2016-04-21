//
//  JYResolutionData.m
//  SeptEsayCamera
//
//  Created by Sept on 16/3/19.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYResolutionData.h"

@implementation JYResolutionData

static id _instace;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    dispatch_once (&onceToken, ^{
        
        _instace = [super allocWithZone:zone];
    });
    
    return _instace;
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    
    return _instace;
}

- (instancetype)copeWithZone:(NSZone *)zone
{
    return _instace;
}

//// 设置分辨率view的选择图片
//- (BOOL)resolutionBackImageViewHiddenWith:(NSInteger)tag
//{
//    switch (tag) {
//        case 60:
//            return NO;
//            break;
//        case 61:
//            return NO;
//            break;
//        case 62:
//            return NO;
//            break;
//        case 63:
//            return NO;
//            break;
//            
//        default:
//            return NO;
//            break;
//    }
//}

// 设置contentView的cell.btn的title
- (NSString *)resolutionBackImageBtnTitleWith:(NSInteger)tag
{
    switch (tag) {
        case 60:
            return @"640x480";
            break;
        case 61:
            return @"1280x720";
            break;
        case 62:
            return @"1920x1080";
            break;
        case 63:
            return @"3840x2160";
            break;
            
        default:
            return @"1920x1080";
            break;
    }
}

// 设置相机的分辨率
- (NSString *)resolutionBackSessionPresionWith:(NSInteger)tag
{
    switch (tag) {
        case 60:
            return AVCaptureSessionPreset640x480;
            break;
        case 61:
            return AVCaptureSessionPreset1280x720;
            break;
        case 62:
            return AVCaptureSessionPresetHigh;
            break;
        case 63:
            return AVCaptureSessionPreset3840x2160;
            break;
            
        default:
            return AVCaptureSessionPresetHigh;
            break;
    }
}

// 设置相机的视频保存size
- (CGSize)resolutionBackVideoSizeWith:(NSInteger)tag
{
    switch (tag) {
        case 60:
            return CGSizeMake(640.0, 480.0);
            break;
        case 61:
            return CGSizeMake(1280.0, 720.0);
            break;
        case 62:
            return CGSizeMake(1920.0, 1080.0);
            break;
        case 63:
            return CGSizeMake(3840.0, 2160.0);
            break;
            
        default:
            return CGSizeMake(1920.0, 1080.0);;
            break;
    }
}

@end

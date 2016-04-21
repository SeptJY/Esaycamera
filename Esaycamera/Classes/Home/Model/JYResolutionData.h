//
//  JYResolutionData.h
//  SeptEsayCamera
//
//  Created by Sept on 16/3/19.
//  Copyright © 2016年 九月. All rights reserved.
//

// 通过保存的btn的tag返回分辨率设置UI 

#import <Foundation/Foundation.h>

@interface JYResolutionData : NSObject

+ (instancetype)sharedManager;

// 设置分辨率view的选择图片
//- (BOOL)resolutionBackImageViewHiddenWith:(NSInteger)tag;

// 设置JYSettingView的cell.btn的title
- (NSString *)resolutionBackImageBtnTitleWith:(NSInteger)tag;

// 设置相机的分辨率
- (NSString *)resolutionBackSessionPresionWith:(NSInteger)tag;

// 设置相机的视频保存size
- (CGSize)resolutionBackVideoSizeWith:(NSInteger)tag;

@end

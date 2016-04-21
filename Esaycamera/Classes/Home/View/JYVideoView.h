//
//  JYVideoView.h
//  SeptEsayCamera
//
//  Created by Sept on 16/3/17.
//  Copyright © 2016年 九月. All rights reserved.
//

// 录像、拍照、图片选择按钮的背景View

#import <UIKit/UIKit.h>

@protocol JYVideoViewDelegate <NSObject>

@optional
- (void)videoViewButtonOnClick:(UIButton *)btn;

@end

@interface JYVideoView : UIView

@property (weak, nonatomic) id<JYVideoViewDelegate> delegate;

@property (strong, nonatomic) NSData *imageData;

@property (assign, nonatomic) BOOL btnSeleted;

@property (strong, nonatomic) NSURL *imgUrl;

@property (assign, nonatomic) BOOL isVideo;

/** 重复录制的提示开启和停止 */
- (void)startResetVideoing;
- (void)stopResetVideoing;


@end

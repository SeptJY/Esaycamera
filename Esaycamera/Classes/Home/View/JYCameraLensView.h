//
//  JYCameraLensView.h
//  Esaycamera
//
//  Created by Sept on 16/4/14.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYCameraLensViewDelegate <NSObject>

@optional
- (void)cameraLensViewCellBtnOnClick:(UIButton *)btn;

@end

@interface JYCameraLensView : UIView

@property (weak, nonatomic) id<JYCameraLensViewDelegate> delegate;

- (void)cameraLensViewShowOneCell;

@end

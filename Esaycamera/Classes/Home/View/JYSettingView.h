//
//  JYSettingView.h
//  SeptEsayCamera
//
//  Created by Sept on 16/3/17.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYSettingViewDelegate <NSObject>

@optional
- (void)settingViewSwitchOnClick:(UISwitch *)mSwitch;

- (void)settingViewResetBtnOnClick:(UIButton *)btn;

- (void)settingViewLabelDirectionBtnOnClick:(UIButton *)btn;

/** 设置对比度 */
- (void)settingViewCustomSliderValueChange:(UISlider *)slider;

@end

@interface JYSettingView : UIView

@property (weak, nonatomic) id<JYSettingViewDelegate> delegate;

/** 设置语言、蓝牙、分辨率的按钮title  tag:是区分哪个title要设置 */
- (void)setDirectionBtnTitle:(NSString *)title andTag:(NSInteger)tag;

@end

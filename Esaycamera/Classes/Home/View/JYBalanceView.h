//
//  JYBalanceView.h
//  SeptOnCamera
//
//  Created by Sept on 16/1/19.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYBalanceViewDelegate <NSObject>

@optional
//- (void)whiteBalanceWithTemp:(CGFloat)temp andTint:(CGFloat)tint;
//
///** 设置相机白平衡模式 */
//- (void)balanceViewAutoBtnOnClick:(UIButton *)btn;
- (void)whiteBalanceCustomSliderValueChange:(UISlider *)slider;

- (void)whiteBalanceCustomSliderAutoBtnOnClick:(UIButton *)btn;

/** 天气滤镜 */
- (void)wetherButtonOnClick:(UIButton *)btn;

@end

@interface JYBalanceView : UIView

@property (weak, nonatomic) id<JYBalanceViewDelegate>delegate;

/** 获取系统相机反馈的白平衡属性实时反应到slider控件中
 value: slider的值
 tag  : 区分是哪个slider的value
 */
- (void)whiteBalanceSetCustomSliderValue:(CGFloat)value andCustomSliderTag:(NSInteger)tag;

- (instancetype)initWithWidth:(CGFloat)width;

@end

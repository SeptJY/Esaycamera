//
//  JYExpsureView.h
//  SeptOnCamera
//
//  Created by Sept on 16/1/19.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYExpsureViewDelegate <NSObject>

@optional
- (void)expsureViewCustomSliderValueChange:(UISlider *)slider;

- (void)expsureViewCustomSliderAutoBtnOnClick:(UIButton *)btn;

@end

@interface JYExpsureView : UIView

@property (weak, nonatomic) id<JYExpsureViewDelegate> delegate;

/** 获取系统相机反馈的曝光属性实时反应到slider控件中
    value: slider的值
     tag : 区分是哪个slider的value
 */
- (void)exposureSetCustomSliderValue:(CGFloat)value andCustomSliderTag:(NSInteger)tag;

@end

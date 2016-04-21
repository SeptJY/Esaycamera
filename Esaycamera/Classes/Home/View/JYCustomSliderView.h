//
//  JYCustomSliderView.h
//  SeptWeiYing
//
//  Created by Sept on 16/3/11.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CustomSliderBtnModel) {
    CustomSliderAutoAndManual,      // 手动和自动
    CustomSliderNoTitle,            // 没有标题
    CustomSliderReset,              // 复位
};

@protocol JYCustomSliderViewDelegate <NSObject>

@optional
/** slider的监听事件 */
- (void)customSliderValueChange:(UISlider *)slider;

/** 设置slider的enabled属性、btn的selected的属性 */
- (void)customSliderAutoBtnOnClick:(UIButton *)btn;

@end

@interface JYCustomSliderView : UIView

@property (weak, nonatomic) id<JYCustomSliderViewDelegate>delegate;

+ (instancetype)customSliderViewWithTitle:(NSString *)sizeTitle;

/** slider的最小值 、最大值、 当前值*/
@property (assign, nonatomic) CGFloat minimumValue;
@property (assign, nonatomic) CGFloat maximumValue;
@property (assign, nonatomic) CGFloat value;

/** label 的text */
@property (strong, nonatomic) NSString *title;

/** 设置slider的tag */
@property (assign, nonatomic) NSInteger sliderTag;

@property (assign, nonatomic) BOOL btnEnabled;

@property (assign, nonatomic) BOOL sliderEnabled;

@property (strong, nonatomic) NSString *btnTitle;

@property (assign, nonatomic) BOOL btnSeleted;

@property (assign, nonatomic) CustomSliderBtnModel btnModel;

@end

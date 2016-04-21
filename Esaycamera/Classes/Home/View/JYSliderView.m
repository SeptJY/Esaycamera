//
//  JYSliderView.m
//  SeptEsayCamera
//
//  Created by Sept on 16/3/22.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYSliderView.h"

@interface JYSliderView ()


@end

@implementation JYSliderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"JYSliderView" owner:nil options:nil] lastObject];

        [self.slider setThumbImage:[UIImage imageNamed:@"home_yuanquan_icon"] forState:UIControlStateNormal];
        [self.slider setThumbImage:[UIImage imageNamed:@"home_yuanquan_icon"] forState:UIControlStateSelected];
    }
    return self;
}

- (IBAction)minusBtnOnClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderViewMinusBtnOnClick:)]) {
        [self.delegate sliderViewMinusBtnOnClick:sender];
    }
}

- (IBAction)addBtnOnClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderViewAddBtnOnClick:)]) {
        [self.delegate sliderViewAddBtnOnClick:sender];
    }
}

- (IBAction)sliderChangeValue:(UISlider *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderViewChangeValue:)]) {
        [self.delegate sliderViewChangeValue:sender];
    }
}

@end

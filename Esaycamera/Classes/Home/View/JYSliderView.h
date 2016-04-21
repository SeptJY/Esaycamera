//
//  JYSliderView.h
//  SeptEsayCamera
//
//  Created by Sept on 16/3/22.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYSliderViewDelegate <NSObject>

@optional
- (IBAction)sliderViewChangeValue:(UISlider *)sender;

- (IBAction)sliderViewMinusBtnOnClick:(UIButton *)sender;

- (IBAction)sliderViewAddBtnOnClick:(UIButton *)sender;

@end

@interface JYSliderView : UIView

@property (weak, nonatomic) id<JYSliderViewDelegate>delegate;

//@property (assign, nonatomic) CGFloat value;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

//
//  JYSliderImageView.h
//  SeptEsayCamera
//
//  Created by Sept on 16/3/23.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYSliderImageViewDelegate <NSObject>

@optional
- (void)sliderImageViewValueChange:(UISlider *)sender;

@end

@interface JYSliderImageView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) id<JYSliderImageViewDelegate>delegate;

@end

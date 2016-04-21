//
//  JYSliderImageView.m
//  SeptEsayCamera
//
//  Created by Sept on 16/3/23.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYSliderImageView.h"

@implementation JYSliderImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"JYSliderImageView" owner:nil options:nil] lastObject];
        
        self.backgroundColor = [UIColor clearColor];
        
        [self.slider setThumbImage:[UIImage imageNamed:@"home_yuanquan_icon"] forState:UIControlStateNormal];
        [self.slider setThumbImage:[UIImage imageNamed:@"home_yuanquan_icon"] forState:UIControlStateSelected];
    }
    return self;
}


- (IBAction)sliderValueChange:(UISlider *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderImageViewValueChange:)]) {
        [self.delegate sliderImageViewValueChange:sender];
    }
}

@end

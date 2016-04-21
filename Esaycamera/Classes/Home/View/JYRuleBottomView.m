//
//  JYRuleBottomView.m
//  SeptEsayCamera
//
//  Created by Sept on 16/3/17.
//  Copyright © 2016年 九月. All rights reserved.
//

// 刻度尺的背景view

#import "JYRuleBottomView.h"

@interface JYRuleBottomView()

@property (strong, nonatomic) UIView *smallView;

@end

@implementation JYRuleBottomView

- (UIView *)bigView
{
    if (!_bigView) {
        
        _bigView = [[UIView alloc] init];
        
        _bigView.backgroundColor = [UIColor cyanColor];
        
        [self addSubview:_bigView];
    }
    return _bigView;
}

- (UIView *)smallView
{
    if (!_smallView) {
        
        _smallView = [[UIView alloc] init];
        
        _smallView.backgroundColor = [UIColor blueColor];
        
        [self.bigView addSubview:_smallView];
    }
    return _smallView;
}

- (void)layoutSubviews
{
    CGFloat bigW = self.width;
    CGFloat bigH = 30;
    CGFloat bigY = (self.height - 30) * 0.5;
    
    self.bigView.frame = CGRectMake(0, bigY, bigW, bigH);
    
    self.smallView.frame = CGRectMake(2, 2, self.bigView.width - 4, self.bigView.height - 4);
}

@end

//
//  JYResolutionView.m
//  SeptEsayCamera
//
//  Created by Sept on 16/3/17.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYResolutionView.h"

#import "JYDirectionCell.h"

@interface JYResolutionView () <JYDirectionCellDelegate>

@property (strong, nonatomic) JYDirectionCell *cell640x480;

@property (strong, nonatomic) JYDirectionCell *cell1280x720;

@property (strong, nonatomic) JYDirectionCell *cell1920x1080;

@property (strong, nonatomic) JYDirectionCell *cell3840x2160;

@end

@implementation JYResolutionView

- (JYDirectionCell *)cell640x480
{
    if (!_cell640x480) {
        
        _cell640x480 = [[JYDirectionCell alloc] initWithTitle:@"640x480"];
        _cell640x480.btnTag = 60;
        _cell640x480.delegate = self;
        _cell640x480.tag = 70;
        _cell640x480.imageHidden = !([[NSUserDefaults standardUserDefaults] integerForKey:@"imageViewSeleted"] == _cell640x480.btnTag);
        
        [self addSubview:_cell640x480];
    }
    return _cell640x480;
}

- (JYDirectionCell *)cell1280x720
{
    if (!_cell1280x720) {
        
        _cell1280x720 = [[JYDirectionCell alloc] initWithTitle:@"1280x720"];
        _cell1280x720.btnTag = 61;
        _cell1280x720.delegate = self;
        _cell1280x720.tag = 71;
        _cell1280x720.imageHidden = !([[NSUserDefaults standardUserDefaults] integerForKey:@"imageViewSeleted"] == _cell1280x720.btnTag);
        
        [self addSubview:_cell1280x720];
    }
    return _cell1280x720;
}

- (JYDirectionCell *)cell1920x1080
{
    if (!_cell1920x1080) {
        
        _cell1920x1080 = [[JYDirectionCell alloc] initWithTitle:@"1920x1080"];
        _cell1920x1080.btnTag = 62;
        _cell1920x1080.delegate = self;
        _cell1920x1080.tag = 72;
        _cell1920x1080.imageHidden = !([[NSUserDefaults standardUserDefaults] integerForKey:@"imageViewSeleted"] == _cell1920x1080.btnTag || ([[NSUserDefaults standardUserDefaults] integerForKey:@"imageViewSeleted"] == 0));
        
        [self addSubview:_cell1920x1080];
    }
    return _cell1920x1080;
}

- (JYDirectionCell *)cell3840x2160
{
    if (!_cell3840x2160) {
        
        _cell3840x2160 = [[JYDirectionCell alloc] initWithTitle:@"3840x2160"];
        _cell3840x2160.btnTag = 63;
        _cell3840x2160.delegate = self;
        _cell3840x2160.tag = 73;
        _cell3840x2160.imageHidden = !([[NSUserDefaults standardUserDefaults] integerForKey:@"imageViewSeleted"] == _cell3840x2160.btnTag);
        
        [self addSubview:_cell3840x2160];
    }
    return _cell3840x2160;
}

- (void)directionCellBtnOnClick:(UIButton *)btn
{
    for (int i = 0; i < 4; i ++) {
        JYDirectionCell *cell = (JYDirectionCell *)[self viewWithTag:70 + i];
        cell.imageHidden = YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(directionCellBtnOnClick:)])
    {
        [self.delegate directionCellBtnOnClick:btn];
    }
}

- (void)layoutSubviews
{
    self.cell640x480.frame = CGRectMake(JYSpaceWidth, JYCortrolWidth * 0, self.width - JYSpaceWidth, JYCortrolWidth);
    
    self.cell1280x720.frame = CGRectMake(JYSpaceWidth, JYCortrolWidth * 1, self.width - JYSpaceWidth, JYCortrolWidth);
    
    self.cell1920x1080.frame = CGRectMake(JYSpaceWidth, JYCortrolWidth * 2, self.width - JYSpaceWidth, JYCortrolWidth);
    
    self.cell3840x2160.frame = CGRectMake(JYSpaceWidth, JYCortrolWidth * 3, self.width - JYSpaceWidth, JYCortrolWidth);
}

@end

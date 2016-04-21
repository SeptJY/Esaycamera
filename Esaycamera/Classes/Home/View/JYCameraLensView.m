//
//  JYCameraLensView.m
//  Esaycamera
//
//  Created by Sept on 16/4/14.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYCameraLensView.h"

#import "JYDirectionCell.h"

@interface JYCameraLensView () <JYDirectionCellDelegate>

@property (strong, nonatomic) JYDirectionCell *oneCell;

@property (strong, nonatomic) JYDirectionCell *twoCell;

@property (strong, nonatomic) JYDirectionCell *threeCell;

@end

@implementation JYCameraLensView

- (JYDirectionCell *)oneCell
{
    if (!_oneCell) {
        
        _oneCell = [[JYDirectionCell alloc] initWithTitle:@"默认x1"];
        _oneCell.btnTag = 80;
        _oneCell.delegate = self;
        _oneCell.tag = 90;
        
        [self addSubview:_oneCell];
    }
    return _oneCell;
}

- (JYDirectionCell *)twoCell
{
    if (!_twoCell) {
        
        _twoCell = [[JYDirectionCell alloc] initWithTitle:@"增距镜x2"];
        _twoCell.btnTag = 81;
        _twoCell.delegate = self;
        _twoCell.tag = 91;
        
        [self addSubview:_twoCell];
    }
    return _twoCell;
}

- (JYDirectionCell *)threeCell
{
    if (!_threeCell) {
        
        _threeCell = [[JYDirectionCell alloc] initWithTitle:@"待定x3"];
        _threeCell.btnTag = 82;
        _threeCell.delegate = self;
        _threeCell.tag = 92;
        
        [self addSubview:_threeCell];
    }
    return _threeCell;
}

- (void)directionCellBtnOnClick:(UIButton *)btn
{
    for (int i = 90; i < 93; i ++) {
        JYDirectionCell *cell = (JYDirectionCell *)[self viewWithTag: i];
        cell.imageHidden = YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraLensViewCellBtnOnClick:)]) {
        [self.delegate cameraLensViewCellBtnOnClick:btn];
    }
}

- (void)cameraLensViewShowOneCell
{
    self.twoCell.imageHidden = YES;
    self.threeCell.imageHidden = YES;
    self.oneCell.imageHidden = NO;
}

- (void)layoutSubviews
{
    CGFloat y = (self.height - 3 * JYCortrolWidth) * 0.5;
    
    self.oneCell.frame = CGRectMake(JYSpaceWidth, y + JYCortrolWidth * 0, self.width - JYSpaceWidth, JYCortrolWidth);
    
    self.twoCell.frame = CGRectMake(JYSpaceWidth, y + JYCortrolWidth * 1, self.width - JYSpaceWidth, JYCortrolWidth);
    
    self.threeCell.frame = CGRectMake(JYSpaceWidth, y + JYCortrolWidth * 2, self.width - JYSpaceWidth, JYCortrolWidth);
}

@end

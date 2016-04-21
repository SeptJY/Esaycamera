//
//  JYDirectionCell.m
//  SeptEsayCamera
//
//  Created by Sept on 16/3/17.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYDirectionCell.h"

@interface JYDirectionCell()

@property (strong, nonatomic) UIButton *btn;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation JYDirectionCell

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

- (UIView *)lineView
{
    if (!_lineView) {
        
        _lineView = [[UIView alloc] init];
        
        _lineView.backgroundColor = [UIColor yellowColor];
        
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (UIButton *)btn
{
    if (!_btn) {
        
        _btn = [[UIButton alloc] init];
        
        _btn.titleLabel.font = setBoldFont(15);
        [_btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [_btn setTitle:NSLocalizedString(self.title, nil) forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(directionCellBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_btn];
    }
    return _btn;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    [self.btn setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
}

- (void)setBtnTag:(NSInteger)btnTag
{
    _btnTag = btnTag;
    
    self.btn.tag = btnTag;
}

- (void)setImageHidden:(BOOL)imageHidden
{
    _imageHidden = imageHidden;
    
    self.imageView.hidden = imageHidden;
}

- (void)directionCellBtnOnClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(directionCellBtnOnClick:)]) {
        [self.delegate directionCellBtnOnClick:btn];
    }
    
    if (screenH >= 375 || btn.tag != 63) {
        self.imageView.hidden = NO;
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_right_icon"]];
        _imageView.hidden = YES;
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (void)layoutSubviews
{
    self.lineView.frame = CGRectMake(0, self.height - 1, self.width, 1);
    
    self.imageView.frame = CGRectMake(self.width - self.imageView.image.size.width - JYSpaceWidth, (self.height - self.imageView.image.size.height) * 0.5, self.imageView.image.size.width, self.imageView.image.size.height);
    
    self.btn.frame = CGRectMake(JYSpaceWidth, 0, self.imageView.x - 10, self.height - 1);
    self.btn.contentEdgeInsets = UIEdgeInsetsMake(0, -self.width + 120, 0, 0);
}

@end

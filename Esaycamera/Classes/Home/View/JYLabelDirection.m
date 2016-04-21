//
//  JYLabelDirection.m
//  SeptWeiYing
//
//  Created by Sept on 16/3/16.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYLabelDirection.h"

@interface JYLabelDirection()

@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) UIButton *btn;

@property (strong, nonatomic) NSString *sizeText;

@property (strong, nonatomic) UIView *lineView;

@end

@implementation JYLabelDirection

- (instancetype)initWithTitle:(NSString *)lableText
{
    self = [super init];
    if (self) {
        
        self.sizeText = lableText;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UILabel *)label
{
    if (!_label) {
        
        _label = [[UILabel alloc] init];
        
        _label.textColor = [UIColor yellowColor];
//        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = setBoldFont(15);
        
        [self addSubview:_label];
    }
    return _label;
}

- (UIButton *)btn
{
    if (!_btn) {
        
        _btn = [[UIButton alloc] init];
        
        [_btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        _btn.titleLabel.font = setFont(12);
        [_btn setImage:[UIImage imageNamed:@"rightIdentifier"] forState:UIControlStateNormal];
        
        [_btn addTarget:self action:@selector(labelDirectionBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_btn];
    }
    return _btn;
}

- (void)setBtnTag:(NSInteger)btnTag
{
    _btnTag = btnTag;
    
    self.btn.tag = btnTag;
}

- (void)setTitleLabel:(NSString *)titleLabel
{
    _titleLabel = titleLabel;
    
    self.label.text = NSLocalizedString(titleLabel, nil);
}

- (void)labelDirectionBtnOnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(labelDirectionBtnOnClick:)]) {
        [self.delegate labelDirectionBtnOnClick:btn];
    }
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

- (void)setTitleBtn:(NSString *)titleBtn
{
    _titleBtn = titleBtn;
    
    [self.btn setTitle:NSLocalizedString(titleBtn, nil) forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    CGSize labelSize = [NSString sizeWithText:self.sizeText font:self.label.font maxSize:CGSizeMake(100, 50)];
    
    CGFloat labelX = JYSpaceWidth;
    CGFloat labelY = (self.height - labelSize.height) * 0.5;
    
    self.label.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
    
    CGFloat btnX = self.label.x + self.label.width + 50;
    CGFloat btnY = 0;
    CGFloat btnW = self.width - btnX;
    CGFloat btnH = self.height;
    
    self.btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    self.btn.contentEdgeInsets = UIEdgeInsetsMake(0, self.width - 165 , 0, 0);
    self.btn.titleEdgeInsets = UIEdgeInsetsMake(0, -120, 0, 0);
    
    self.lineView.frame = CGRectMake(0, self.height - 1, self.width, 1);
    
}

@end

//
//  JYLabelSwitch.m
//  SeptWeiYing
//
//  Created by Sept on 16/3/16.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYLabelSwitch.h"

@interface JYLabelSwitch()

@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) UISwitch *mSwitch;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) NSString *sizeTitle;

@end

@implementation JYLabelSwitch

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.sizeTitle = title;
    }
    return self;
}

- (UILabel *)label
{
    if (!_label) {
        
        _label = [[UILabel alloc] init];
        
        _label.text = NSLocalizedString(self.title, nil);
        _label.textColor = [UIColor yellowColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = setBoldFont(15);
        
        [self addSubview:_label];
    }
    return _label;
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

- (UISwitch *)mSwitch
{
    if (!_mSwitch) {
        
        _mSwitch = [[UISwitch alloc] init];
        
        [_mSwitch addTarget:self action:@selector(switchOnClick:) forControlEvents:UIControlEventValueChanged];
        _mSwitch.onTintColor = [UIColor yellowColor];
        
        [self addSubview:_mSwitch];
    }
    return _mSwitch;
}

- (void)setSwitchTag:(NSInteger)switchTag
{
    _switchTag = switchTag;
    
    self.mSwitch.tag = switchTag;
}

- (void)switchOnClick:(UISwitch *)mSwitch
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchOnClick:)]) {
        [self.delegate switchOnClick:mSwitch];
    }
}

- (void)setTitle:(NSString *)title
{
    self.label.text = NSLocalizedString(title, nil);
}

- (void)setMSwitchOn:(BOOL)mSwitchOn
{
    _mSwitchOn = mSwitchOn;
    
    self.mSwitch.on = mSwitchOn;
}

- (void)layoutSubviews
{
    CGSize labelSize = [NSString sizeWithText:self.sizeTitle font:self.label.font maxSize:CGSizeMake(100, 50)];
    
    CGFloat labelX = JYSpaceWidth;
    CGFloat labelY = (self.height - labelSize.height) * 0.5;
    
    self.label.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
//
    CGFloat switchX = self.width - 51;
    CGFloat switchY = (self.height - 31) * 0.5;
//
    self.mSwitch.frame = CGRectMake(switchX, switchY, 51, 31);
    self.mSwitch.transform = CGAffineTransformMakeScale(.65, .65);
    
    self.lineView.frame = CGRectMake(0, self.height - 1, self.width, 1);
}

@end

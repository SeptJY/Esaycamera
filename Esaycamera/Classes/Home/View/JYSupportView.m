//
//  JYSupportView.m
//  SeptEsayCam
//
//  Created by Sept on 16/4/5.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYSupportView.h"

@interface JYSupportView ()

@property (strong, nonatomic) UIButton *imgBtn;

@property (strong, nonatomic) UIButton *nameBtn;

@property (strong, nonatomic) UILabel *appLabel;
@property (strong, nonatomic) UILabel *v_appLabel;

@property (strong, nonatomic) UILabel *yjLabel;
@property (strong, nonatomic) UILabel *v_yjLabel;

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *w_nameLabel;

@end

@implementation JYSupportView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:@"changeLanguage" object:nil];
    }
    return self;
}

- (void)changeLanguage
{
    [self.nameBtn setTitle:[[JYLanguageTool bundle] localizedStringForKey:@"无线跟焦器" value:nil table:@"Localizable"] forState:UIControlStateNormal];
    
    self.yjLabel.text = [[JYLanguageTool bundle] localizedStringForKey:@"硬件版本:" value:nil table:@"Localizable"];
}

- (UIButton *)imgBtn
{
    if (!_imgBtn) {
        
        _imgBtn = [[UIButton alloc] init];
        
        [_imgBtn addTarget:self action:@selector(pushEsaycamWebView) forControlEvents:UIControlEventTouchUpInside];
//        _imgBtn.backgroundColor = [UIColor cyanColor];
        [_imgBtn setImage:[UIImage imageNamed:@"home_suporrt_icon"] forState:UIControlStateNormal];
        
        [self addSubview:_imgBtn];
    }
    return _imgBtn;
}

- (UIButton *)nameBtn
{
    if (!_nameBtn) {
        
        _nameBtn = [[UIButton alloc] init];
        [_nameBtn setBackgroundImage:[UIImage imageNamed:@"home_support_btn_bg_icon"] forState:UIControlStateNormal];
        [_nameBtn setBackgroundImage:[UIImage imageNamed:@"home_support_btn_bg_icon_selected"] forState:UIControlStateHighlighted];
        [_nameBtn setTitle:NSLocalizedString(@"无线跟焦器", nil) forState:UIControlStateNormal];
        [_nameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nameBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        _nameBtn.titleLabel.font = setFont(10);
        
        [_nameBtn addTarget:self action:@selector(pushEsaycamWebView) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_nameBtn];
    }
    return _nameBtn;
}

- (UILabel *)appLabel
{
    if (!_appLabel) {
        
        UIFont *font = (screenW == 480) ? setFont(13) : setFont(17);
        
        _appLabel = [self createLableWithText:@"ESAYCAME:" color:[UIColor yellowColor] font:font];
    }
    return _appLabel;
}

- (UILabel *)v_appLabel
{
    if (!_v_appLabel) {
        UIFont *font = (screenW == 480) ? setFont(11) : setFont(15);
        _v_appLabel = [self createLableWithText:@"Version 1.1.0" color:[UIColor whiteColor] font:font];
        
        [self addSubview:_v_appLabel];
    }
    return _v_appLabel;
}

- (UILabel *)yjLabel
{
    if (!_yjLabel) {
        UIFont *font = (screenW == 480) ? setFont(13) : setFont(17);
        _yjLabel = [self createLableWithText:@"硬件版本:" color:[UIColor yellowColor] font:font];
    }
    return _yjLabel;
}

- (UILabel *)v_yjLabel
{
    if (!_v_yjLabel) {
        UIFont *font = (screenW == 480) ? setFont(11) : setFont(15);
        _v_yjLabel = [self createLableWithText:@"Version 1.1.0" color:[UIColor whiteColor] font:font];
    }
    return _v_yjLabel;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        UIFont *font = (screenW == 480) ? setFont(13) : setFont(17);
        _nameLabel = [self createLableWithText:@"硬件名称:" color:[UIColor yellowColor] font:font];
    }
    return _nameLabel;
}

- (UILabel *)w_nameLabel
{
    if (!_w_nameLabel) {
        UIFont *font = (screenW == 480) ? setFont(11) : setFont(15);
        _w_nameLabel = [self createLableWithText:@"无线跟焦器" color:[UIColor whiteColor] font:font];
    }
    return _w_nameLabel;
}

- (UILabel *)createLableWithText:(NSString *)text color:(UIColor *)color font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] init];
    
    label.text = NSLocalizedString(text, nil);
    label.textColor = color;
    label.font = font;
    
    [self addSubview:label];
    
    return label;
}

- (void)pushEsaycamWebView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushEsaycamWebView)]) {
        [self.delegate pushEsaycamWebView];
    }
}

- (void)layoutSubviews
{
    CGFloat margin = 15;
    
    self.imgBtn.frame = CGRectMake(margin, margin, self.width * 0.5 - 30, self.height - 15);
    
    CGSize labelSize = [NSString sizeWithText:self.appLabel.text font:self.appLabel.font maxSize:CGSizeMake(200, 50)];
    CGFloat labelX = self.width * 0.5 + (self.width * 0.5 - 2 * labelSize.width) / 2;
    
    self.yjLabel.frame = CGRectMake(labelX, (self.height - labelSize.height) * 0.5, labelSize.width, labelSize.height);
    self.v_yjLabel.frame = CGRectMake(self.yjLabel.x + labelSize.width + 5, self.yjLabel.y, labelSize.width, labelSize.height);
    
    self.appLabel.frame = CGRectMake(labelX, self.yjLabel.y - labelSize.height - 20, labelSize.width, labelSize.height);
    
    self.v_appLabel.frame = CGRectMake(self.v_yjLabel.x, self.yjLabel.y - labelSize.height - 20, labelSize.width, labelSize.height);
    
    self.nameBtn.frame = CGRectMake((self.width * 0.5 - 120) * 0.5 + self.width * 0.5, self.yjLabel.y + labelSize.height + 30, 120, 28);
}

@end

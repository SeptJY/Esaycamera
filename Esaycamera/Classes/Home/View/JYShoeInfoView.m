//
//  JYShoeInfoView.m
//  Esaycamera
//
//  Created by Sept on 16/4/6.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYShowInfoView.h"

@interface JYShowInfoView ()

//@property (strong, nonatomic) UILabel *dzLabel;
@property (strong, nonatomic) UILabel *dzNumLabel;

@property (strong, nonatomic) UILabel *rateLabel;
@property (strong, nonatomic) UILabel *rateNumLabel;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIImageView *bgImageView;

@property (strong, nonatomic) UIView *lineView;

@end

@implementation JYShowInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:BG_ALPHA];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        
        _imageView.image = [UIImage imageNamed:@"home_core_blue_disconnect"];
        
        [self.bgImageView addSubview:_imageView];
    }
    return _imageView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        
        _lineView = [[UIView alloc] init];
        
        _lineView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        
        _bgImageView = [[UIImageView alloc] init];
        
        _bgImageView.image = [UIImage imageNamed:@"home_show_info_icon"];
        
        [self addSubview:_bgImageView];
    }
    return _bgImageView;
}

- (void)setImage:(NSString *)image
{
    _image = image;
    
    self.imageView.image = [UIImage imageNamed:image];
}

//- (UILabel *)dzLabel
//{
//    if (!_dzLabel) {
//        
//        _dzLabel = [self createLableText:@"Dz:" color:[UIColor whiteColor] font:setFont(14)];
//        
//    }
//    return _dzLabel;
//}


- (UILabel *)dzNumLabel
{
    if (!_dzNumLabel) {
        
        _dzNumLabel = [self createLableText:@"x1" color:[UIColor yellowColor] font:setFont(14)];
        
    }
    return _dzNumLabel;
}

- (void)setDzText:(NSString *)dzText
{
    _dzText = dzText;
    
    self.dzNumLabel.text = dzText;
}

- (void)setRaNum:(CGFloat)raNum
{
    _raNum = raNum;
//    NSLog(@"--%f -%@", raNum, [NSString stringWithFormat:@"x%.1f", raNum * 0.1]);
    
    self.rateNumLabel.text = [NSString stringWithFormat:@"x%.1f", raNum * 0.1];
//    NSLog(@"%@", [NSString stringWithFormat:@"x%.1f", dzNum]);
}

- (UILabel *)rateLabel
{
    if (!_rateLabel) {
        
        _rateLabel = [self createLableText:@"Ra:" color:[UIColor whiteColor] font:setFont(14)];
        
    }
    return _rateLabel;
}

- (UILabel *)rateNumLabel
{
    if (!_rateNumLabel) {
        
        _rateNumLabel = [self createLableText:@"x1.0" color:[UIColor yellowColor] font:setFont(14)];
    }
    return _rateNumLabel;
}


- (UILabel *)createLableText:(NSString *)text color:(UIColor *)color font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] init];
    
    label.font = font;
    label.text = NSLocalizedString(text, nil);
    label.textColor = color;
    
    [self.bgImageView addSubview:label];
    
    return label;
}


- (void)layoutSubviews
{
    self.bgImageView.frame = self.bounds;
    
    CGSize lableSize = [NSString sizeWithText:@"x4.5" font:self.rateLabel.font maxSize:CGSizeMake(100, 50)];
    
    self.imageView.frame = CGRectMake(5, (self.height - 25) * 0.5, 20, 25);
    
    self.rateLabel.frame = CGRectMake(JYSpaceWidth + self.imageView.x + self.imageView.width, (self.height - lableSize.height) * 0.5, lableSize.width, lableSize.height);
    
    self.rateNumLabel.frame = CGRectMake(self.rateLabel.x + self.rateLabel.width, self.rateLabel.y, lableSize.width + 5, lableSize.height);
    
    self.lineView.frame = CGRectMake(self.rateNumLabel.x + self.rateNumLabel.width, 5, 1, self.height - 10);
    
//    self.rateLabel.frame = CGRectMake(JYSpaceWidth + self.dzNumLabel.x + self.dzNumLabel.width, self.dzLabel.y, lableSize.width, lableSize.height);
//    
    self.dzNumLabel.frame = CGRectMake(self.lineView.x + 10, self.rateNumLabel.y, lableSize.width + 5, lableSize.height);
}

@end

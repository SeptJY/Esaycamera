//
//  JYCustomSliderView.m
//  SeptWeiYing
//
//  Created by Sept on 16/3/11.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYCustomSliderView.h"

// 控件高度
#define HEIGHT_SUBVIEWS 20
// 间隙宽度
#define SPACE_WIDTH 8

@interface JYCustomSliderView()

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) UISlider *slider;

@property (strong, nonatomic) UIButton *btn;

@property (strong, nonatomic) NSString *sizeTitle;

@end

@implementation JYCustomSliderView

+ (instancetype)customSliderViewWithTitle:(NSString *)sizeTitle
{
    return [[self alloc] initWithTitle:sizeTitle];
}

- (instancetype)initWithTitle:(NSString *)sizeTitle
{
    self = [super init];
    if (self) {
        
        self.sizeTitle = sizeTitle;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:@"changeLanguage" object:nil];
    }
    return self;
}

/** 切换语言 */
- (void)changeLanguage
{
    if (self.btnModel == CustomSliderAutoAndManual) {
        [self.btn setTitle:[[JYLanguageTool bundle] localizedStringForKey:@"自动" value:nil table:@"Localizable"] forState:UIControlStateSelected];
        [self.btn setTitle:[[JYLanguageTool bundle] localizedStringForKey:@"手动" value:nil table:@"Localizable"] forState:UIControlStateNormal];
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

- (UILabel *)label
{
    if (!_label) {
        
        _label = [[UILabel alloc] init];
        
        _label.font = setBoldFont(15);
        _label.textColor = [UIColor yellowColor];
        _label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_label];
    }
    return _label;
}

- (UIButton *)btn
{
    if (!_btn) {
        
        _btn = [[UIButton alloc] init];
        
        [_btn setBackgroundColor:[UIColor yellowColor]];
        _btn.titleLabel.font = setFont(10);
        [_btn setTitleColor:setColor(127, 127, 127) forState:UIControlStateSelected];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [_btn setTitle:NSLocalizedString(@"手动", nil) forState:UIControlStateNormal];
        [_btn setTitle:NSLocalizedString(@"自动", nil) forState:UIControlStateSelected];
        [_btn addTarget:self action:@selector(customSliderAutoBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn.selected = YES;
        
        [self addSubview:_btn];
    }
    return _btn;
}

- (UISlider *)slider
{
    if (!_slider) {
        
        _slider = [[UISlider alloc] init];
        
        [_slider setThumbImage:[UIImage imageWithImage:[UIImage imageNamed:@"home_slider_thump_icon"] scaledToWidth:15] forState:UIControlStateNormal];
        
        [_slider setThumbImage:[UIImage imageWithImage:[UIImage imageNamed:@"home_slider_thump_icon"] scaledToWidth:15] forState:UIControlStateHighlighted];
        _slider.tintColor = [UIColor yellowColor];
        [_slider addTarget:self action:@selector(customSliderValueChange:) forControlEvents:UIControlEventValueChanged];
        _slider.enabled = NO;
        
        [self addSubview:_slider];
    }
    return _slider;
}

/** 设置slider的最 大 值 */
- (void)setMaximumValue:(CGFloat)maximumValue
{
    _maximumValue = maximumValue;
    
    self.slider.maximumValue = maximumValue;
}

/** 设置slider的最 小 值 */
- (void)setMinimumValue:(CGFloat)minimumValue
{
    _minimumValue = minimumValue;
    
    self.slider.minimumValue = minimumValue;
}

/** 设置slider的当前值 */
- (void)setValue:(CGFloat)value
{
    _value = value;
    
    self.slider.value = value;
}

/** 设置label的text */
- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.label.text = NSLocalizedString(title, nil);
}

/** 设置 slider、btn 的tag */
- (void)setSliderTag:(NSInteger)sliderTag
{
    _sliderTag = sliderTag;
    
    self.slider.tag = sliderTag;
    
    self.btn.tag = sliderTag - 20;
}

/** 设置按钮是否可使用 */
- (void)setBtnEnabled:(BOOL)btnEnabled
{
    _btnEnabled = btnEnabled;
    
    self.btn.enabled = btnEnabled;
    
    [self.btn setTitle:NSLocalizedString(@"", nil) forState:UIControlStateNormal];
}

- (void)setSliderEnabled:(BOOL)sliderEnabled
{
    _sliderEnabled = sliderEnabled;
    
    self.slider.enabled = sliderEnabled;
}

- (void)setBtnSeleted:(BOOL)btnSeleted
{
    _btnSeleted = btnSeleted;
    
    self.btn.selected = btnSeleted;
}

- (void)setBtnModel:(CustomSliderBtnModel)btnModel
{
    _btnModel = btnModel;
    switch (btnModel) {
        case CustomSliderNoTitle:
            [self.btn setTitle:NSLocalizedString(@"", nil) forState:UIControlStateSelected];
            self.btn.userInteractionEnabled = NO;
            break;
        case CustomSliderAutoAndManual:
            
            break;
        case CustomSliderReset:
            [self.btn setTitle:@"Reset" forState:UIControlStateSelected];
            break;
            
        default:
            break;
    }
}

/** 设置slider的enabled属性、btn的selected的属性 */
- (void)customSliderAutoBtnOnClick:(UIButton *)btn
{
    if (btn.tag == 43 || btn.tag == 32) {   // 当点击曝光补偿的时候
        self.slider.value = (self.slider.maximumValue + self.slider.minimumValue) * 0.5;
    } else
    {
        btn.selected = !btn.selected;
        self.slider.enabled = !btn.selected;
    }
    
    // 设置代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(customSliderAutoBtnOnClick:)]) {
        [self.delegate customSliderAutoBtnOnClick:btn];
    }
}

- (void)customSliderValueChange:(UISlider *)slider
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customSliderValueChange:)]) {
        [self.delegate customSliderValueChange:slider];
    }
}

- (void)layoutSubviews
{
    // 1.设置label的frame
    CGSize labelSize = [NSString sizeWithText:self.sizeTitle font:self.label.font maxSize:CGSizeMake(100, 50)];
    
    self.label.frame = CGRectMake(10, (self.height - labelSize.height) * 0.5, labelSize.width, labelSize.height);
    
    // 2.设置竖线的frame
    CGFloat lineX = self.label.x + self.label.width + SPACE_WIDTH;
    CGFloat lineY = (self.height - HEIGHT_SUBVIEWS) * 0.5;
    CGFloat lineW = 2;
    CGFloat lineH = HEIGHT_SUBVIEWS;
    
    self.lineView.frame = CGRectMake(lineX, lineY, lineW, lineH);
    
    // 3.设置button的frame
    CGFloat btnW = HEIGHT_SUBVIEWS * 16 / 9;
    CGFloat btnH = HEIGHT_SUBVIEWS;
    CGFloat btnX = self.width - btnW - SPACE_WIDTH;
    CGFloat btnY = self.lineView.y;
    
    self.btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    // 设置slider的frame
    CGFloat sliderX = self.lineView.x - 1;
    CGFloat sliderY = (self.height - 31) * 0.5 - 0.5;
    CGFloat sliderW = self.btn.x - self.lineView.x + 3;
    CGFloat sliderH = 31;
    
    self.slider.frame = CGRectMake(sliderX, sliderY, sliderW, sliderH);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeLanguage" object:nil];
}

@end

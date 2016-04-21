//
//  JYBalanceView.m
//  SeptOnCamera
//
//  Created by Sept on 16/1/19.
//  Copyright © 2016年 九月. All rights reserved.
//

// 注：色温的范围 （3000 ~ 8000）
// 注：色彩的范围 （-150 ~ 150）

#import "JYBalanceView.h"

static void *JYTEMP_AND_TINT_VALUES = &JYTEMP_AND_TINT_VALUES;
static void *JYSELF_HIDDEN = &JYSELF_HIDDEN;

@interface JYBalanceView () <JYCustomSliderViewDelegate>

@property (strong, nonatomic) JYCustomSliderView *tempSlider;

@property (strong, nonatomic) JYCustomSliderView *tintSlider;

@property (strong, nonatomic) JYCustomSliderView *saturationSlider;

@property (assign, nonatomic) CGFloat widthBtn;

@end

@implementation JYBalanceView

- (instancetype)initWithWidth:(CGFloat)width
{
    self = [super init];
    if (self) {
        
        self.widthBtn = width;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:@"changeLanguage" object:nil];
        
        //        [[JYSeptManager sharedManager] addObserver:self forKeyPath:@"temperatureAndTintValues" options:NSKeyValueObservingOptionNew context:JYTEMP_AND_TINT_VALUES];
        
        [self addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:JYSELF_HIDDEN];
        
        [self createWetherButton];
    }
    return self;
}

#pragma mark -------------------------> 懒加载tempSlider、tintSlider、saturationSlider
- (JYCustomSliderView *)tempSlider
{
    if (!_tempSlider) {
        
        _tempSlider = [JYCustomSliderView customSliderViewWithTitle:@"Saturation"];
        _tempSlider.delegate = self;
        _tempSlider.maximumValue = 8000;
        _tempSlider.minimumValue = 3000;
        _tempSlider.value = 5500;
        _tempSlider.title = @"色   温";
        _tempSlider.sliderTag = 50;
        
        [self addSubview:_tempSlider];
    }
    return _tempSlider;
}

- (JYCustomSliderView *)tintSlider
{
    if (!_tintSlider) {
        
        _tintSlider = [JYCustomSliderView customSliderViewWithTitle:@"Saturation"];
        _tintSlider.delegate = self;
        _tintSlider.maximumValue = 150;
        _tintSlider.minimumValue = -150;
        _tintSlider.value = 0;
        _tintSlider.title = @"色   调";
        _tintSlider.sliderTag = 51;
        
        [self addSubview:_tintSlider];
    }
    return _tintSlider;
}

- (JYCustomSliderView *)saturationSlider
{
    if (!_saturationSlider) {
        
        _saturationSlider = [JYCustomSliderView customSliderViewWithTitle:@"Saturation"];
        _saturationSlider.delegate = self;
        _saturationSlider.maximumValue = 2;
        _saturationSlider.minimumValue = 0;
        _saturationSlider.value = 1;
        _saturationSlider.title = @"饱 和 度";
        _saturationSlider.sliderTag = 52;
        _saturationSlider.sliderEnabled = YES;
        _saturationSlider.btnModel = CustomSliderReset;
        
        [self addSubview:_saturationSlider];
    }
    return _saturationSlider;
}

- (void)whiteBalanceSetCustomSliderValue:(CGFloat)value andCustomSliderTag:(NSInteger)tag
{
    switch (tag) {
        case 50:   // 色温
            self.tempSlider.value = value;
            break;
        case 51:   // 色调
            self.tintSlider.value = value;
            break;
        case 52:   // 饱和度
            self.saturationSlider.value = value;
            break;
            
        default:
            break;
    }
}


#pragma mark -------------------------> JYCustomSliderViewDelegate
- (void)customSliderValueChange:(UISlider *)slider
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(whiteBalanceCustomSliderValueChange:)]) {
        [self.delegate whiteBalanceCustomSliderValueChange:slider];
    }
//    NSLog(@"%f -- %f", slider.value, (1900 - slider.value) / 100.0 * 0.7);
    if (slider.value >= 1800 && slider.value <= 2000) {
        UIButton *btn = [self viewWithTag:80];
        btn.alpha = 1.0;
    } else if (slider.value >= 3700 && slider.value <= 3900)
    {
        UIButton *btn = [self viewWithTag:81];
        btn.alpha = 1.0;
    } else if (slider.value >= 5300 && slider.value <= 5500)
    {
        UIButton *btn = [self viewWithTag:82];
        btn.alpha = 1.0;
    } else if (slider.value >= 6900 && slider.value <= 7100)
    {
        UIButton *btn = [self viewWithTag:83];
        btn.alpha = 1.0;
    } else if (slider.value >= 9800 && slider.value <= 10000)
    {
        UIButton *btn = [self viewWithTag:84];
        btn.alpha = 1.0;
    } else
    {
        UIButton *btn1 = [self viewWithTag:80];
        btn1.alpha = 0.3;
        UIButton *btn2 = [self viewWithTag:81];
        btn2.alpha = 0.3;
        UIButton *btn3 = [self viewWithTag:82];
        btn3.alpha = 0.3;
        UIButton *btn4 = [self viewWithTag:83];
        btn4.alpha = 0.3;
        UIButton *btn5 = [self viewWithTag:84];
        btn5.alpha = 0.3;
    }
}

- (void)customSliderAutoBtnOnClick:(UIButton *)btn
{
    // 1.设置代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(whiteBalanceCustomSliderAutoBtnOnClick:)]) {
        [self.delegate whiteBalanceCustomSliderAutoBtnOnClick:btn];
    }
    
    // 2.点击色温、和色调的时候
    if (btn.tag == 30 || btn.tag == 31) {
        
        // 2.1 遍历所有滤镜天气，设置透明度为0.4；
        for (int i = 0; i < 5; i ++) {
            UIButton *allBtn = [self viewWithTag:80 + i];
            allBtn.alpha = 0.4;
        }
    }
}

#pragma mark -------------------------> 创建气候按钮
/** 创建五个按钮 -- 气候 */
- (void)createWetherButton
{
    NSArray *titleArray = @[@"ic_wb_fluorescent", @"ic_wb_incandescent", @"ic_wb_daylight", @"ic_wb_cloudy", @"A"];
    
    CGFloat btnW = 30;
    CGFloat btnH = btnW;
    CGFloat btnY = 10;
    CGFloat space = (self.widthBtn - titleArray.count * btnW) / (titleArray.count + 1);
    
    for (int i = 0; i < titleArray.count; i ++) {
        
        CGFloat btnX = space + i * (btnW + space);
        
        UIButton *btn = [[UIButton alloc] init];
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        btn.backgroundColor = [UIColor yellowColor];
        btn.layer.cornerRadius = btnW / 2;
        btn.alpha = 0.4;
        btn.tag = 80 + i;
//        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d", i + 12]] forState:UIControlStateNormal];
//        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:titleArray[i]] forState:UIControlStateNormal];
//        btn.titleLabel.font = setFont(10);
//        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(wetherButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }
}

/** 设置天气滤镜 */
- (void)wetherButtonOnClick:(UIButton *)btn
{
    // 1.设置代理，在homeCtl中设置白平衡的模式为手动
    if (self.delegate && [self.delegate respondsToSelector:@selector(wetherButtonOnClick:)]) {
        [self.delegate wetherButtonOnClick:btn];
    }
    // 2.遍历所有按钮的背景亮度为0.4
    for (int i = 0; i < 5; i ++) {
        UIButton *allBtn = [self viewWithTag:80 + i];
        allBtn.alpha = 0.4;
    }
    // 当前点击的按钮背景亮度为1.0
    btn.alpha = 1.0;
    
    // 3.设置slider的为可用、btn不选中状态
    self.tempSlider.sliderEnabled = YES;
    self.tintSlider.sliderEnabled = YES;
    self.tintSlider.btnSeleted = NO;
    self.tempSlider.btnSeleted = NO;
    
    switch (btn.tag) {
        case 80:      // 荧光
            self.tempSlider.value = 3642.0;
            self.tintSlider.value = 50.0;
            break;
        case 81:      // 白炽灯
            self.tempSlider.value = 3400.0;
            self.tintSlider.value = 25.0;
            break;
        case 82:      // 晴天
            self.tempSlider.value = 5400;
            self.tintSlider.value = 0.0;
            break;
        case 83:      // 阴天
            self.tempSlider.value = 4886.0;
            self.tintSlider.value = 52.0;
            break;
        case 84:      // 蓝天
            self.tintSlider.btnSeleted = YES;
            self.tempSlider.btnSeleted = YES;
            self.tintSlider.sliderEnabled = NO;
            self.tempSlider.sliderEnabled = NO;
            break;
            
        default:
            break;
    }
}

/** 监听语言切换 */
- (void)changeLanguage
{
    self.tempSlider.title = [[JYLanguageTool bundle] localizedStringForKey:@"色   温" value:nil table:@"Localizable"];
    
    self.tintSlider.title = [[JYLanguageTool bundle] localizedStringForKey:@"色   调" value:nil table:@"Localizable"];
    
    self.saturationSlider.title = [[JYLanguageTool bundle] localizedStringForKey:@"饱 和 度" value:nil table:@"Localizable"];
}

/** KVC */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context == JYSELF_HIDDEN) {
        if (self.hidden == 0) {
            [[JYSeptManager sharedManager] addObserver:self forKeyPath:@"temperatureAndTintValues" options:NSKeyValueObservingOptionNew context:JYTEMP_AND_TINT_VALUES];
        }
    }else if (context == JYTEMP_AND_TINT_VALUES) {
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -------------------------> 设置frame
- (void)layoutSubviews
{
    UIButton *btn = [self viewWithTag:80];
    
    CGFloat sliderH = 50;
    CGFloat space_height = (self.height - (btn.y + btn.height + 20) - 3 * sliderH) / 2;
    
    CGFloat sliderY = btn.y + btn.height + 10;
    // 色温
    self.tempSlider.frame = CGRectMake(0, sliderY, self.width, sliderH);
    
    // 色调
    self.tintSlider.frame = CGRectMake(0, sliderY + (sliderH + space_height), self.width, sliderH);
    
    // 饱和度
    self.saturationSlider.frame = CGRectMake(0, sliderY + (sliderH + space_height) * 2, self.width, sliderH);
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[JYSeptManager sharedManager] removeObserver:self forKeyPath:@"temperatureAndTintValues" context:JYTEMP_AND_TINT_VALUES];
}

@end

//
//  JYSettingView.m
//  SeptEsayCamera
//
//  Created by Sept on 16/3/17.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYSettingView.h"

#import "JYLabelDirection.h"
#import "JYLabelSwitch.h"
#import "JYCustomSliderView.h"

#define DIRECTION_SIZE_LABEL @"Resolution"
#define SWITCH_SIZE_LABEL @"Position"

static void *COREBLUE_NAME = &COREBLUE_NAME;

@interface JYSettingView () <JYLabelSwitchDelegate, JYCustomSliderViewDelegate, JYLabelDirectionDelegate>

@property (strong, nonatomic) JYLabelDirection *blueDirection;

@property (strong, nonatomic) JYLabelDirection *resolutionDirection;

@property (strong, nonatomic) JYLabelDirection *languageDirection;

//@property (strong, nonatomic) JYLabelSwitch *positionSwitch;

@property (strong, nonatomic) JYLabelSwitch *girldSwitch;

@property (strong, nonatomic) JYLabelSwitch *flashSwitch;

@property (strong, nonatomic) JYCustomSliderView *alphaSlide;

@property (strong, nonatomic) JYLabelDirection *direction;

@property (strong, nonatomic) JYLabelDirection *suportDirection;

@property (strong, nonatomic) JYLabelDirection *chooseDirection;

@property (strong, nonatomic) JYLabelDirection *lastVideo;

/** 恢复默认设置 */
@property (strong, nonatomic) UIButton *resetBtn;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation JYSettingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.opacity = ([[NSUserDefaults standardUserDefaults] floatForKey:@"opacity"] == 0) ? 1 : [[NSUserDefaults standardUserDefaults] floatForKey:@"opacity"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:@"changeLanguage" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreDefaults) name:@"RestoreDefaults" object:nil];
        
        // 设置蓝牙连接之后显示连接蓝牙的名称
        [[JYSeptManager sharedManager] addObserver:self forKeyPath:@"perName" options:NSKeyValueObservingOptionNew context:COREBLUE_NAME];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == COREBLUE_NAME) {    // 设置连接蓝牙的显示名称
        self.blueDirection.titleBtn = [JYSeptManager sharedManager].perName;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)restoreDefaults
{
    self.alphaSlide.value = 1.0;
    self.layer.opacity = 1.0;
    
    [[NSUserDefaults standardUserDefaults] setFloat:1.0 forKey:@"opacity"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.resolutionDirection.titleBtn = @"1920x1080";
    // 62是1920x1080分辨率按钮的tag
    [[NSUserDefaults standardUserDefaults] setInteger:62 forKey:@"imageViewSeleted"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _girldSwitch.mSwitchOn = NO;
    // 保存设置
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"grladView_hidden"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)changeLanguage
{
    self.blueDirection.titleLabel = [[JYLanguageTool bundle] localizedStringForKey:@"  蓝   牙" value:nil table:@"Localizable"];
    
    self.resolutionDirection.titleLabel = [[JYLanguageTool bundle] localizedStringForKey:@"  分辨率 " value:nil table:@"Localizable"];
    
    self.languageDirection.titleLabel = [[JYLanguageTool bundle] localizedStringForKey:@"  语   言" value:nil table:@"Localizable"];
    
    self.direction.titleLabel = [[JYLanguageTool bundle] localizedStringForKey:@"手轮方向" value:nil table:@"Localizable"];
    
    self.chooseDirection.titleLabel = [[JYLanguageTool bundle] localizedStringForKey:@"附加镜头" value:nil table:@"Localizable"];
    
    self.suportDirection.titleLabel = [[JYLanguageTool bundle] localizedStringForKey:@"硬件支持" value:nil table:@"Localizable"];
    
//    self.positionSwitch.title = [[JYLanguageTool bundle] localizedStringForKey:@"摄像头" value:nil table:@"Localizable"];
    
    self.flashSwitch.title = [[JYLanguageTool bundle] localizedStringForKey:@"闪光灯" value:nil table:@"Localizable"];
    
    self.girldSwitch.title = [[JYLanguageTool bundle] localizedStringForKey:@"九宫格" value:nil table:@"Localizable"];
    
    self.alphaSlide.title = [[JYLanguageTool bundle] localizedStringForKey:@"对比度" value:nil table:@"Localizable"];
    
    self.languageDirection.titleBtn = [[JYLanguageTool bundle] localizedStringForKey:self.languageDirection.titleBtn value:nil table:@"Localizable"];
    if ([self.direction.titleBtn isEqualToString:@"正"] || [self.direction.titleBtn isEqualToString:@"Positive"]) {
        self.direction.titleBtn = [[JYLanguageTool bundle] localizedStringForKey:@"正" value:nil table:@"Localizable"];
    } else {
        self.direction.titleBtn = [[JYLanguageTool bundle] localizedStringForKey:@"反" value:nil table:@"Localizable"];
    }
    
    [self.resetBtn setTitle:[[JYLanguageTool bundle] localizedStringForKey:@"恢复默认设置" value:nil table:@"Localizable"] forState:UIControlStateNormal];
    
    if ([self.blueDirection.titleBtn isEqualToString:@"未连接"] || [self.blueDirection.titleBtn isEqualToString:@"Not connected"]) {
        self.blueDirection.titleBtn = [[JYLanguageTool bundle] localizedStringForKey:@"未连接" value:nil table:@"Localizable"];
    }
}

/** 蓝牙 */
- (JYLabelDirection *)blueDirection
{
    if (!_blueDirection) {
        
        _blueDirection = [[JYLabelDirection alloc] initWithTitle:DIRECTION_SIZE_LABEL];
        _blueDirection.titleBtn = @"未连接";
        _blueDirection.btnTag = 50;
        _blueDirection.titleLabel = @"  蓝   牙";
        _blueDirection.delegate = self;
        _blueDirection.tag = 80;
        
        [self addSubview:_blueDirection];
    }
    return _blueDirection;
}

/** 分辨率 */
- (JYLabelDirection *)resolutionDirection
{
    if (!_resolutionDirection) {
        
        _resolutionDirection = [[JYLabelDirection alloc] initWithTitle:DIRECTION_SIZE_LABEL];
        _resolutionDirection.titleBtn = [[JYResolutionData sharedManager] resolutionBackImageBtnTitleWith:[[NSUserDefaults standardUserDefaults] integerForKey:@"imageViewSeleted"]];
        _resolutionDirection.btnTag = 51;
        _resolutionDirection.titleLabel = @"  分辨率 ";
        _resolutionDirection.delegate = self;
        _blueDirection.tag = 81;
        
        [self addSubview:_resolutionDirection];
    }
    return _resolutionDirection;
}

/** 硬件支持 */
- (JYLabelDirection *)suportDirection
{
    if (!_suportDirection) {
        
        _suportDirection = [[JYLabelDirection alloc] initWithTitle:DIRECTION_SIZE_LABEL];
        _suportDirection.titleLabel = @"硬件支持";
        _suportDirection.btnTag = 54;
        _suportDirection.delegate = self;
        _suportDirection.tag = 82;
        
        [self addSubview:_suportDirection];
    }
    return _suportDirection;
}

/** 语言选择 */
- (JYLabelDirection *)languageDirection
{
    if (!_languageDirection) {
        
        _languageDirection = [[JYLabelDirection alloc] initWithTitle:DIRECTION_SIZE_LABEL];
        _languageDirection.titleBtn = ([JYSeptManager sharedManager].isEnglish == YES) ? @"English" : @"简体中文";
        _languageDirection.titleLabel = @"  语   言";
        _languageDirection.btnTag = 52;
        _languageDirection.delegate = self;
        _blueDirection.tag = 83;
        
        [self addSubview:_languageDirection];
    }
    return _languageDirection;
}

/** 手轮方向 */
- (JYLabelDirection *)direction
{
    if (!_direction) {
        
        _direction = [[JYLabelDirection alloc] initWithTitle:DIRECTION_SIZE_LABEL];
        _direction.titleBtn = ([[NSUserDefaults standardUserDefaults] integerForKey:BlueDerection] == 1) ? @"反" : @"正";
        _direction.titleLabel = @"手轮方向";
        _direction.btnTag = 53;
        _direction.delegate = self;
        _direction.tag = 84;
        
        [self addSubview:_direction];
    }
    return _direction;
}

/** 附加镜头 */
- (JYLabelDirection *)chooseDirection
{
    if (!_chooseDirection) {
        
        _chooseDirection = [[JYLabelDirection alloc] initWithTitle:DIRECTION_SIZE_LABEL];
        _chooseDirection.titleLabel = @"附加镜头";
        _chooseDirection.btnTag = 55;
        _chooseDirection.delegate = self;
        _chooseDirection.tag = 85;
        
        [self addSubview:_chooseDirection];
    }
    return _chooseDirection;
}

/** 附加镜头 */
- (JYLabelDirection *)lastVideo
{
    if (!_lastVideo) {
        
        _lastVideo = [[JYLabelDirection alloc] initWithTitle:DIRECTION_SIZE_LABEL];
        _lastVideo.titleLabel = @"最后一次";
        _lastVideo.btnTag = 56;
        _lastVideo.delegate = self;
        _lastVideo.tag = 86;
        
        [self addSubview:_lastVideo];
    }
    return _lastVideo;
}

- (void)setDirectionBtnTitle:(NSString *)title andTag:(NSInteger)tag
{
    switch (tag) {
        case 80:   // 蓝牙
            self.blueDirection.titleBtn = NSLocalizedString(title, nil);
            break;
            
        case 81:   // 分辨率
            self.resolutionDirection.titleBtn = NSLocalizedString(title, nil);
            break;
            
        case 82:   // 语言切换
            self.languageDirection.titleBtn = NSLocalizedString(title, nil);
            break;
            
        default:
            break;
    }
}

/** 摄像头 */
//- (JYLabelSwitch *)positionSwitch
//{
//    if (!_positionSwitch) {
//        
//        _positionSwitch = [[JYLabelSwitch alloc] initWithTitle:SWITCH_SIZE_LABEL];
//        _positionSwitch.switchTag = 40;
//        _positionSwitch.delegate = self;
//        _positionSwitch.title = @"摄像头";
//        
//        [self addSubview:_positionSwitch];
//    }
//    return _positionSwitch;
//}

/** 九宫格 */
- (JYLabelSwitch *)girldSwitch
{
    if (!_girldSwitch) {
        
        _girldSwitch = [[JYLabelSwitch alloc] initWithTitle:SWITCH_SIZE_LABEL];
        _girldSwitch.switchTag = 41;
        _girldSwitch.delegate = self;
        _girldSwitch.title = @"九宫格";
        _girldSwitch.mSwitchOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"grladView_hidden"];
        
        [self addSubview:_girldSwitch];
    }
    return _girldSwitch;
}

/** 闪光灯 */
- (JYLabelSwitch *)flashSwitch
{
    if (!_flashSwitch) {
        
        _flashSwitch = [[JYLabelSwitch alloc] initWithTitle:SWITCH_SIZE_LABEL];
        _flashSwitch.switchTag = 42;
        _flashSwitch.delegate = self;
        _flashSwitch.title = @"闪光灯";
        
        [self addSubview:_flashSwitch];
    }
    return _flashSwitch;
}

/** 对比度 */
- (JYCustomSliderView *)alphaSlide
{
    if (!_alphaSlide) {
        
        _alphaSlide = [JYCustomSliderView customSliderViewWithTitle:@"Contrast"];
        _alphaSlide.title = @"对比度";
        _alphaSlide.maximumValue = 1;
        _alphaSlide.minimumValue = 0.2;
        _alphaSlide.value = ([[NSUserDefaults standardUserDefaults] floatForKey:@"opacity"] == 0) ? 1 : [[NSUserDefaults standardUserDefaults] floatForKey:@"opacity"];;
        _alphaSlide.sliderEnabled = YES;
        _alphaSlide.delegate = self;
        _alphaSlide.btnModel = CustomSliderNoTitle;
        
        [self addSubview:_alphaSlide];
    }
    return _alphaSlide;
}

- (UIButton *)resetBtn
{
    if (!_resetBtn) {
        
        _resetBtn = [[UIButton alloc] init];
        
        [_resetBtn setTitle:NSLocalizedString(@"恢复默认设置", nil) forState:UIControlStateNormal];
        _resetBtn.titleLabel.font = setBoldFont(15);
        [_resetBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        
        [_resetBtn addTarget:self action:@selector(settingViewResetBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_resetBtn];
    }
    return _resetBtn;
}

/** 恢复所有的默认设置 */
- (void)settingViewResetBtnOnClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingViewResetBtnOnClick:)]) {
        [self.delegate settingViewResetBtnOnClick:btn];
    }
}

#pragma mark -------------------------> 自定义View的代理设置
/** JYLabelSwitchDelegate 摄像头，闪光灯，九宫格 */
- (void)switchOnClick:(UISwitch *)mSwitch
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingViewSwitchOnClick:)]) {
        [self.delegate settingViewSwitchOnClick:mSwitch];
    }
}

/**  JYCustomSliderViewDelegate 设置空间的对比度 */
- (void)customSliderValueChange:(UISlider *)slider
{
    self.layer.opacity = slider.value;
    
    [[NSUserDefaults standardUserDefaults] setFloat:slider.value forKey:@"opacity"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingViewCustomSliderValueChange:)]) {
        [self.delegate settingViewCustomSliderValueChange:slider];
    }
}

/** JYLabelDirectionDelegate 选项 */
- (void)labelDirectionBtnOnClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingViewLabelDirectionBtnOnClick:)]) {
        [self.delegate settingViewLabelDirectionBtnOnClick:btn];
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

- (void)layoutSubviews
{
    CGFloat viewW = self.width - 2 * JYSpaceWidth;
    
    self.blueDirection.frame = CGRectMake(JYSpaceWidth, 0, viewW, JYCortrolWidth);
    
    self.resolutionDirection.frame = CGRectMake(JYSpaceWidth, JYCortrolWidth, viewW, JYCortrolWidth);
    
    self.languageDirection.frame = CGRectMake(JYSpaceWidth, JYCortrolWidth * 2, viewW, JYCortrolWidth);
    
    self.direction.frame = CGRectMake(JYSpaceWidth, JYCortrolWidth * 3, viewW, JYCortrolWidth);
    
    self.suportDirection.frame = CGRectMake(JYSpaceWidth, JYCortrolWidth * 4, viewW, JYCortrolWidth);
    
    self.chooseDirection.frame = CGRectMake(JYSpaceWidth, JYCortrolWidth * 5, viewW, JYCortrolWidth);
    
    self.lastVideo.frame = CGRectMake(JYSpaceWidth, JYCortrolWidth * 6, viewW, JYCortrolWidth);
    
    self.flashSwitch.frame = CGRectMake(JYSpaceWidth, JYCortrolWidth * 7, viewW, JYCortrolWidth);
    
    self.girldSwitch.frame = CGRectMake(JYSpaceWidth, JYCortrolWidth * 8, viewW, JYCortrolWidth);
    
    self.alphaSlide.frame = CGRectMake(JYSpaceWidth, JYCortrolWidth * 9, viewW, JYCortrolWidth);
    
    self.lineView.frame = CGRectMake(JYSpaceWidth, (JYCortrolWidth * 10) -1, viewW, 1);
    
    self.resetBtn.frame = CGRectMake(JYSpaceWidth, JYCortrolWidth * 10, viewW, JYCortrolWidth);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeLanguage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RestoreDefaults" object:nil];
    
    [[JYSeptManager sharedManager] removeObserver:self forKeyPath:@"perName" context:COREBLUE_NAME];
}

@end

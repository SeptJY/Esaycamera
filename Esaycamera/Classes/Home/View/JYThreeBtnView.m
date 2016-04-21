//
//  JYThreeBtnView.m
//  SeptEsayCamera
//
//  Created by Sept on 16/3/17.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYThreeBtnView.h"

@interface JYThreeBtnView ()

@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *exposureBtn;

@end

@implementation JYThreeBtnView

+ (instancetype)threeBtnView
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"JYThreeBtnView" owner:nil options:nil] lastObject];
        
        [self.settingBtn setTitle:NSLocalizedString(@"设置", nil) forState:UIControlStateNormal];
        [self.balanceBtn setTitle:NSLocalizedString(@"白平衡", nil) forState:UIControlStateNormal];
        [self.exposureBtn setTitle:NSLocalizedString(@"曝光", nil) forState:UIControlStateNormal];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:@"changeLanguage" object:nil];
    }
    return self;
}

- (void)changeLanguage
{
    [self.settingBtn setTitle:[[JYLanguageTool bundle] localizedStringForKey:@"设置" value:nil table:@"Localizable"] forState:UIControlStateNormal];
    
    [self.balanceBtn setTitle:[[JYLanguageTool bundle] localizedStringForKey:@"白平衡" value:nil table:@"Localizable"] forState:UIControlStateNormal];
    
    [self.exposureBtn setTitle:[[JYLanguageTool bundle] localizedStringForKey:@"曝光" value:nil table:@"Localizable"] forState:UIControlStateNormal];
}

- (IBAction)threeViewButtonOnClick:(UIButton *)sender
{
    // 1.遍历所有按钮 清空背景颜色
    for (int i = 0; i < 3; i ++) {
        UIButton *btn = [self viewWithTag:30 + i];
        btn.backgroundColor = [UIColor clearColor];
        btn.selected = NO;
    }
    // 2.设置选中按钮的背景颜色
    sender.backgroundColor = [UIColor yellowColor];
    sender.selected = !sender.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(threeViewButtonOnClick:)]) {
        [self.delegate threeViewButtonOnClick:sender];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeLanguage" object:nil];
}

@end

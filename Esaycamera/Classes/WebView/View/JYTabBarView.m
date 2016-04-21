//
//  JYTabBarView.m
//  Esaycamera
//
//  Created by Sept on 16/4/5.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYTabBarView.h"

@interface JYTabBarView ()

@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *refeshBtn;

@end

@implementation JYTabBarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"JYTabBarView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (IBAction)tabBarBtnOnClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarBtnOnClick:)]) {
        [self.delegate tabBarBtnOnClick:sender];
    }
}

- (void)refeshBtn:(BOOL)refesh forwardBtn:(BOOL)forward backBtn:(BOOL)back
{
    self.refeshBtn.enabled = refesh;
    self.forwardBtn.enabled = forward;
    self.backBtn.enabled = back;
}

@end

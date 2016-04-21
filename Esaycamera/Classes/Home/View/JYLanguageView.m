//
//  JYLanguageView.m
//  SeptEsayCamera
//
//  Created by Sept on 16/3/18.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYLanguageView.h"

#import "JYDirectionCell.h"

@interface JYLanguageView () <JYDirectionCellDelegate>

@property (strong, nonatomic) JYDirectionCell *chinaCell;

@property (strong, nonatomic) JYDirectionCell *englishCell;

@property (assign, nonatomic) BOOL isFirst;
@property (copy, nonatomic) NSString *curentLan;

@end

@implementation JYLanguageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 设置语言切换通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:@"changeLanguage" object:nil];
        
        [JYLanguageTool initUserLanguage];//初始化应用语言
    }
    return self;
}

/** 切换语言 */
- (void)changeLanguage
{
    self.chinaCell.title = [[JYLanguageTool bundle] localizedStringForKey:@"简体中文" value:nil table:@"Localizable"];
    
    self.englishCell.title = [[JYLanguageTool bundle] localizedStringForKey:@"英文" value:nil table:@"Localizable"];
    
}

- (JYDirectionCell *)chinaCell
{
    if (!_chinaCell) {
        
        _chinaCell = [[JYDirectionCell alloc] initWithTitle:@"简体中文"];
        _chinaCell.btnTag = 80;
        _chinaCell.delegate = self;
        _chinaCell.tag = 70;
        _chinaCell.imageHidden = [JYSeptManager sharedManager].isEnglish;
        
        [self addSubview:_chinaCell];
    }
    return _chinaCell;
}

- (JYDirectionCell *)englishCell
{
    if (!_englishCell) {
        
        _englishCell = [[JYDirectionCell alloc] initWithTitle:@"英文"];
        _englishCell.btnTag = 81;
        _englishCell.delegate = self;
        _englishCell.tag = 70;
        _englishCell.imageHidden = ![JYSeptManager sharedManager].isEnglish;
        
        [self addSubview:_englishCell];
    }
    return _englishCell;
}

- (void)directionCellBtnOnClick:(UIButton *)btn
{
    // 1.掩藏所有的图片
    self.chinaCell.imageHidden = YES;
    self.englishCell.imageHidden = YES;
    
    // 2.设置代理,点击之后掩藏JYLanguegaView和显示scrollView
    if (self.delegate && [self.delegate respondsToSelector:@selector(languageViewDirectionCellBtnOnClick:)]) {
        [self.delegate languageViewDirectionCellBtnOnClick:btn];
    }
    
    switch (btn.tag) {
        case 80:
            [JYLanguageTool setUserlanguage:@"zh-Hans"];
            break;
            
        case 81:
            [JYLanguageTool setUserlanguage:@"en"];
            break;
            
        default:
            break;
    }
    
    //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage" object:nil];
}

- (void)layoutSubviews
{
    self.chinaCell.frame = CGRectMake(JYSpaceWidth, (self.height - 2 * JYCortrolWidth) / 2, self.width - JYSpaceWidth, JYCortrolWidth);
    
    self.englishCell.frame = CGRectMake(JYSpaceWidth, self.chinaCell.y + JYCortrolWidth, self.width - JYSpaceWidth, JYCortrolWidth);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeLanguage" object:nil];
}

@end

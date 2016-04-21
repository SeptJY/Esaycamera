//
//  JYLanguageView.h
//  SeptEsayCamera
//
//  Created by Sept on 16/3/18.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYLanguageViewDelegate <NSObject>

@optional
- (void)languageViewDirectionCellBtnOnClick:(UIButton *)btn;

@end

@interface JYLanguageView : UIView

@property (weak, nonatomic) id<JYLanguageViewDelegate> delegate;

@end

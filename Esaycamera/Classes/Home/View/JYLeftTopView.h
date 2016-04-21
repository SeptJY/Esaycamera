//
//  JYLeftTopView.h
//  SeptWeiYing
//
//  Created by Sept on 16/3/9.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYLeftTopViewDelegate <NSObject>

@optional
- (void)leftTopViewQuickOrSettingBtnOnClick:(UIButton *)btn;

@end

@interface JYLeftTopView : UIView

@property (weak, nonatomic) id<JYLeftTopViewDelegate> delegate;

@property (strong, nonatomic) UILabel *label;

@property (assign, nonatomic) BOOL isShow;

@property (assign, nonatomic) BOOL imgHidden;

@end

//
//  JYTabBarView.h
//  Esaycamera
//
//  Created by Sept on 16/4/5.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYTabBarViewDelegate <NSObject>

@optional
- (void)tabBarBtnOnClick:(UIButton *)sender;

@end

@interface JYTabBarView : UIView

@property (weak, nonatomic) id<JYTabBarViewDelegate>delegate;

- (void)refeshBtn:(BOOL)refesh forwardBtn:(BOOL)forward backBtn:(BOOL)back;

@end

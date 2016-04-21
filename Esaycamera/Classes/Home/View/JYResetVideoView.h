//
//  JYResetVideoView.h
//  Esaycamera
//
//  Created by Sept on 16/4/20.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYResetVideoViewDelegate <NSObject>

@optional
- (void)resetVideoDirectionCellBtnOnClick:(UIButton *)btn;

@end

@interface JYResetVideoView : UIView

@property (weak, nonatomic) id<JYResetVideoViewDelegate> delegate;

@end

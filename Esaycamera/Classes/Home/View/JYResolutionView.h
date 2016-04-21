//
//  JYResolutionView.h
//  SeptEsayCamera
//
//  Created by Sept on 16/3/17.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYResolutionViewDelegate <NSObject>

@optional
- (void)directionCellBtnOnClick:(UIButton *)btn;

@end

@interface JYResolutionView : UIView

@property (weak, nonatomic) id<JYResolutionViewDelegate>delegate;

@end

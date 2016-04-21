//
//  JYThreeBtnView.h
//  SeptEsayCamera
//
//  Created by Sept on 16/3/17.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYThreeBtnViewDelegate <NSObject>

@optional
- (void)threeViewButtonOnClick:(UIButton *)sender;

@end

@interface JYThreeBtnView : UIView

@property (weak, nonatomic) id<JYThreeBtnViewDelegate> delegate;

+ (instancetype)threeBtnView;

@end

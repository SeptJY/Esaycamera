//
//  JYLabelDirection.h
//  SeptWeiYing
//
//  Created by Sept on 16/3/16.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYLabelDirectionDelegate <NSObject>

@optional
- (void)labelDirectionBtnOnClick:(UIButton *)btn;

@end

@interface JYLabelDirection : UIView

@property (strong, nonatomic) NSString *titleBtn;

@property (strong, nonatomic) NSString *titleLabel;

- (instancetype)initWithTitle:(NSString *)sizeText;

@property (assign, nonatomic) NSInteger btnTag;

@property (weak, nonatomic) id<JYLabelDirectionDelegate>delegate;



@end

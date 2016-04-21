//
//  JYLabelSwitch.h
//  SeptWeiYing
//
//  Created by Sept on 16/3/16.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYLabelSwitchDelegate <NSObject>

@optional
- (void)switchOnClick:(UISwitch *)mSwitch;

@end

@interface JYLabelSwitch : UIView

- (instancetype)initWithTitle:(NSString *)title;

@property (weak, nonatomic) id<JYLabelSwitchDelegate> delegate;

@property (assign, nonatomic) NSInteger switchTag;

@property (strong, nonatomic) NSString *title;

@property (assign, nonatomic) BOOL mSwitchOn;

@end

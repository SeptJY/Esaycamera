//
//  JYDirectionCell.h
//  SeptEsayCamera
//
//  Created by Sept on 16/3/17.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYDirectionCellDelegate <NSObject>

@optional
- (void)directionCellBtnOnClick:(UIButton *)btn;

@end

@interface JYDirectionCell : UIView

- (instancetype)initWithTitle:(NSString *)title;

@property (weak, nonatomic) id<JYDirectionCellDelegate> delegate;

@property (assign, nonatomic) NSInteger btnTag;

@property (assign, nonatomic) BOOL imageHidden;

@property (strong, nonatomic) NSString *title;

@end

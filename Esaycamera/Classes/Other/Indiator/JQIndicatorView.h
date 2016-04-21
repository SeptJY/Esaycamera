//
//  JQIndicatorView.h
//  JQIndicatorViewDemo
//
//  Created by James on 15/7/21.
//  Copyright (c) 2015年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JQIndicatorType){
    JQIndicatorTypeMusic1,
    JQIndicatorTypeMusic2,
    JQIndicatorTypeBounceSpot1,
    JQIndicatorTypeBounceSpot2,
    JQIndicatorTypeCyclingLine,
    JQIndicatorTypeCyclingCycle
};

@interface JQIndicatorView : UIView

- (instancetype)initWithType:(JQIndicatorType)type;
- (instancetype)initWithType:(JQIndicatorType)type tintColor:(UIColor *)color;
- (instancetype)initWithType:(JQIndicatorType)type tintColor:(UIColor *)color size:(CGSize)size;


- (void)startAnimating;
- (void)stopAnimating;

@property BOOL isAnimating;


@end

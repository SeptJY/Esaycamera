//
//  JQBounceSpot1Animation.m
//  JQIndicatorViewDemo
//
//  Created by James on 15/7/21.
//  Copyright (c) 2015年 JQ. All rights reserved.
//

#import "JQBounceSpot1Animation.h"

@interface JQBounceSpot1Animation ()

@property CALayer *spotLayer;

@end

@implementation JQBounceSpot1Animation


- (void)configAnimationAtLayer:(CALayer *)layer withTintColor:(UIColor *)color size:(CGSize)size{
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake(0, 0, size.width, size.height);
    replicatorLayer.position = CGPointMake(0,0);
    replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
    [layer addSublayer:replicatorLayer];
    [self addCyclingSpotAnimationLayerAtLayer:replicatorLayer withTintColor:color size:size];
    
    NSInteger numOfDot = 10;   // 点的个数
    replicatorLayer.instanceCount = numOfDot;
    CGFloat angle = (M_PI * 2)/numOfDot;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    replicatorLayer.instanceDelay = 1.5/numOfDot;
}


#pragma mark - Cycling indicator animation

- (void)addCyclingSpotAnimationLayerAtLayer:(CALayer *)layer withTintColor:(UIColor *)color size:(CGSize)size{
    self.spotLayer = [CALayer layer];
    self.spotLayer.bounds = CGRectMake(0, 0, size.width/6, size.width/6);
    self.spotLayer.position = CGPointMake(size.width/2, 5);
    self.spotLayer.cornerRadius = self.spotLayer.bounds.size.width/2;
    self.spotLayer.backgroundColor = color.CGColor;
    self.spotLayer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1);

    [layer addSublayer:self.spotLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @1;
    animation.toValue = @0.1;
    animation.duration = 1.5;
    animation.repeatCount = CGFLOAT_MAX;
    
    [self.spotLayer addAnimation:animation forKey:@"animation"];
}

- (void)removeAnimation{
    [self.spotLayer removeAnimationForKey:@"animation"];
}



@end

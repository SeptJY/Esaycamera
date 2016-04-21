//
//  JQIndicatorView.m
//  JQIndicatorViewDemo
//
//  Created by James on 15/7/21.
//  Copyright (c) 2015年 JQ. All rights reserved.
//

#import "JQIndicatorView.h"

#import "JQBounceSpot1Animation.h"

#define JQIndicatorDefaultTintColor [UIColor colorWithRed:0.049 green:0.849 blue:1.000 alpha:1.000]
#define JQIndicatorDefaultSize CGSizeMake(30,30)

@interface JQIndicatorView ()

@property id<JQIndicatorAnimationProtocol> animation;
@property JQIndicatorType type;
@property CGSize size;
@property UIColor *loadingTintColor;

- (void)setToNormalState;
- (void)setToFadeOutState;
- (void)fadeOutWithAnimation:(BOOL)animated;

@end

@implementation JQIndicatorView

- (instancetype)initWithType:(JQIndicatorType)type{
    return [self initWithType:type tintColor:JQIndicatorDefaultTintColor];
}

- (instancetype)initWithType:(JQIndicatorType)type tintColor:(UIColor *)color{
    return [self initWithType:type tintColor:color size:JQIndicatorDefaultSize];
}

- (instancetype)initWithType:(JQIndicatorType)type tintColor:(UIColor *)color size:(CGSize)size{
    if (self = [super init]) {
        self.type = type;
        self.loadingTintColor = color;
        self.size = size;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    return self;
}

#pragma mark - Animation

- (void)startAnimating{
    self.layer.sublayers = nil;
    [self setToNormalState];
    self.animation = [self animationForIndicatorType:JQIndicatorTypeBounceSpot1];
    if ([self.animation respondsToSelector:@selector(configAnimationAtLayer:withTintColor:size:)]) {
        
        [self.animation configAnimationAtLayer:self.layer withTintColor:self.loadingTintColor size:self.size];
    }
    self.isAnimating = YES;
}

- (void)stopAnimating{
    if (self.isAnimating == YES) {
        if ([self.animation respondsToSelector:@selector(removeAnimation)]) {
            [self.animation removeAnimation];
            self.isAnimating = NO;
            self.animation = nil;
        }
        [self fadeOutWithAnimation:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (id<JQIndicatorAnimationProtocol>)animationForIndicatorType:(JQIndicatorType)type{
    return [[JQBounceSpot1Animation alloc] init];
}

#pragma mark - Indicator animation methods

- (void)setToNormalState{
    self.layer.backgroundColor = [UIColor grayColor].CGColor;
    self.layer.speed = 1.0f;
    self.layer.opacity = 1.0;
}

- (void)setToFadeOutState{
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.layer.sublayers = nil;
    self.layer.opacity = 0.f;
}

- (void)fadeOutWithAnimation:(BOOL)animated{
    if (animated) {
        CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeAnimation.delegate = self;
        fadeAnimation.beginTime = CACurrentMediaTime();
        fadeAnimation.duration = 0.35;
        fadeAnimation.toValue = @(0);
        [self.layer addAnimation:fadeAnimation forKey:@"fadeOut"];
    }
}

#pragma mark - CAAnimation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self setToFadeOutState];
}

#pragma mark - Did enter background

- (void)appWillEnterBackground{
    if (self.isAnimating == YES) {
        [self.animation removeAnimation];
    }
}

- (void)appWillBecomeActive{
    if (self.isAnimating == YES) {
        [self startAnimating];
    }
}
@end

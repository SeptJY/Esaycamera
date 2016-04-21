//
//  JQIndicatorAnimationProtocol.h
//  JQIndicatorViewDemo
//
//  Created by James on 15/7/21.
//  Copyright (c) 2015年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol JQIndicatorAnimationProtocol <NSObject>

- (void)configAnimationAtLayer:(CALayer *)layer withTintColor:(UIColor *)color size:(CGSize)size;
- (void)removeAnimation;

@end

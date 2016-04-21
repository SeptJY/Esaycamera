//
//  JYSeptDelegate.h
//  Sept数据库
//
//  Created by admin on 15/12/28.
//  Copyright © 2015年 Sept. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
@class JYPeripheral;

@interface JYSeptManager : NSObject

+ (instancetype)sharedManager;

@property (assign, nonatomic) CGFloat baisValue;

@property (assign, nonatomic) CGFloat ISOValue;

@property (assign, nonatomic) CGFloat timeValue;

@property (assign, nonatomic) CGFloat focusValue;

@property (assign, nonatomic) CGFloat offsetValue;

@property (assign, nonatomic) BOOL isAutoFocus;

@property (assign, nonatomic) BOOL isEnglish;

@property (copy, nonatomic) NSString *perName;     // 蓝牙名称

@property (assign, nonatomic) AVCaptureWhiteBalanceTemperatureAndTintValues temperatureAndTintValues;

/** 归档蓝牙数据 */
- (void)saveCoreBlueWith:(JYPeripheral *)pre;

@end

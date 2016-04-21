//
//  JYTestController.h
//  Esaycamera
//
//  Created by Sept on 16/4/8.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CoreBlueUseModel1) {
    CoreBlueUseModel1Focus,
//    CoreBlueUseModel1Duration,
    CoreBlueUseModel1DurationAndFucus,
    CoreBlueUseModel1DurationAndZoom,
    CoreBlueUseModel1ZOOM,
    CoreBlueUseModel1RepeatRecording,
};

typedef NS_ENUM(NSUInteger, CamereFangDaModel) {
    CamereFangDaModelAuto,
    CamereFangDaModelLock,
    CamereFangDaModelHidden,
};

static void * CapturingStillImageContext = &CapturingStillImageContext;
static void * SessionRunningContext = &SessionRunningContext;
static void * CaptureLensPositionContext = &CaptureLensPositionContext;
static void * DeviceWhiteBalanceGains = &DeviceWhiteBalanceGains;
static void * DeviceExposureTargetBias = &DeviceExposureTargetBias;
static void * DeviceExposureISO = &DeviceExposureISO;
static void * DeviceExposureDuration = &DeviceExposureDuration;
static void * DeviceExposureOffset = &DeviceExposureOffset;
static void * IMAGE_RULE_Y = &IMAGE_RULE_Y;
static void * FoucsChange = &FoucsChange;
static void * VideoZoomChange = &VideoZoomChange;

@interface JYMainController : UIViewController

@end

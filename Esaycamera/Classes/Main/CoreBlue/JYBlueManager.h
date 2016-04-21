//
//  JYBlueManager1.h
//  SeptOnCamera
//
//  Created by Sept on 16/1/27.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSUInteger, CoreBlueType) {
    CoreBlueTypeDefult,
    CoreBlueTypeAdd,
    CoreBlueTypeMinus,
};

typedef enum {
    JYBlueManagerLensOne,
    JYBlueManagerLensTwo,
    JYBlueManagerLensThree,
}JYBlueManagerLens;

typedef NS_ENUM(NSUInteger, CoreBlueDerection) {
    CoreBlueDerectionClockwise,   // 顺时针
    CoreBlueDerectionAntiClockwise,  // 逆时针
};

typedef enum{
    JYResetVideoTypeOne,    // 线性
    JYResetVideoTypeTwo,    // 两点
}JYResetVideoType;

@protocol JYBlueManagerDelegate <NSObject>

@optional
/** 告诉蓝牙显示界面刷新tableView */
- (void)blueManagerToTableViewReloadData;

/** 提示用户设备断开 */
- (void)blueManagerPeripheralDidConnect;
/** 提示用户设备连接成功 */
- (void)blueManagerPeripheralConnectSuccess;

/** 返回刻度尺的Y坐标 */
- (void)blueManagerReturnFoucuValue:(CGFloat)value;

/** 蓝牙发送的指令和查询指令 */
- (void)blueManagerOthersCommandWith:(NSInteger)num;

- (void)coreBlueInfoLogWith:(int)addNum minsNum:(int)minusNum;

- (void)blueToolReturnRSSIValue:(int)num;

- (void)coreBlueAddOrMinus:(CoreBlueType)type;

- (void)blueManagerResetVideo:(NSInteger)type andNum:(NSInteger)num;

@end

@interface JYBlueManager : NSObject

@property (strong, nonatomic) NSMutableArray *peripherals;
@property (strong, nonatomic) CBPeripheral *connectPeripheral;
@property (strong, nonatomic) CBCentralManager *centralManager;

@property (weak, nonatomic) id<JYBlueManagerDelegate>delegate;

/** 为了使蓝牙的数据与手势数据同步 */
@property (assign, nonatomic) CGFloat moveDistance;

/** 为了使蓝牙的数据与手势数据同步 */
@property (assign, nonatomic) CGFloat videoZoom;

/** 跟焦器手轮转动速度 */
@property (assign, nonatomic) CGFloat speed;

/** 附加镜头倍率 */
@property (assign, nonatomic) JYBlueManagerLens managerLens;

+ (instancetype)blueManager;

/** 连接一个给定的外设 */
- (void)connect:(CBPeripheral *)peripheral;

/** 断开一个给定的外设 */
- (void)disconnect:(CBPeripheral *)peripheral;

- (int)findBLKAppPeripherals:(int)timeout;
/**
 *  发送数据到蓝牙设备
 *
 *  @param blueTool 当前类
 *  @param str      需要发送的数据
 */
- (void)blueToolWriteValue:(NSString *)str;

@property (assign, nonatomic) CoreBlueDerection derection;

@property (assign, nonatomic) JYResetVideoType videoType;

@end

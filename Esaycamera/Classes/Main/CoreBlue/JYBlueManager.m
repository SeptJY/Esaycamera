//
//  JYBlueManager1.m
//  SeptOnCamera
//
//  Created by Sept on 16/1/27.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYBlueManager.h"

static void * ADD_MOVE_DISTANCE_ADD = &ADD_MOVE_DISTANCE_ADD;
static void * MINUS_MOVE_DISTANCE_ADD = &MINUS_MOVE_DISTANCE_ADD;

static void * ADD_ZOOM_ADD = &ADD_ZOOM_ADD;
static void * MINUS_ZOOM_MINUS = &MINUS_ZOOM_MINUS;

@interface JYBlueManager() <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (copy, nonatomic) NSMutableString *reciveData;
@property (copy, nonatomic) NSString *strData;

@property (strong, nonatomic) CBCharacteristic *characteristic;

@property (assign, nonatomic) int iSExit;

@property (assign, nonatomic) NSRange aRange;   // aa的范围
@property (assign, nonatomic) NSRange bRange;   // bb的范围

@property (assign, nonatomic) int  allAdd;
@property (assign, nonatomic) int  allMinus;
@property (assign, nonatomic) int  testNum;

@property (assign, nonatomic) CoreBlueType blueType;

@end

@implementation JYBlueManager

@synthesize peripherals;
@synthesize connectPeripheral;
@synthesize centralManager;
@synthesize reciveData;

+ (instancetype)blueManager
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        self.testNum = 0;
        self.moveDistance = SHOW_Y;
        self.videoZoom = 0;
        
        // 设置蓝牙显示的方向
        self.derection = ([[NSUserDefaults standardUserDefaults] integerForKey:BlueDerection] == 1) ? CoreBlueDerectionAntiClockwise : CoreBlueDerectionClockwise;
    }
    return self;
}

/*
 * 连接一个给定的外设
 */
- (void)connect:(CBPeripheral *)peripheral
{
//    NSLog(@"name = %@, %ld", peripheral.name, (long)peripheral.state);
    if (!(peripheral.state == CBPeripheralStateConnected)) {
        [centralManager connectPeripheral:peripheral options:nil];
    }
}

/*
 * 断开一个给定的外设
 */
- (void)disconnect:(CBPeripheral *)peripheral
{
    [centralManager cancelPeripheralConnection:peripheral];
}

- (int)findBLKAppPeripherals:(int)timeout
{
//    NSLog(@"%d", centralManager.state);
    if ([centralManager state] != CBCentralManagerStatePoweredOn) {
//        printf("CoreBluetooth is not correctly initialized !\n");
        return -1;
    }
    
//    [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    
    //[manager scanForPeripheralsWithServices:[NSArray arrayWithObject:serviceUUID] options:0]; // start Scanning
    [centralManager scanForPeripheralsWithServices:nil options:0];
    return 0;
}

#pragma mark - basic operations for SerialGATT service  对于serialgatt服务基本操作
-(void) write:(CBPeripheral *)peripheral data:(NSData *)data
{
    [self writeValue:SERVICE_UUID characteristicUUID:CHAR_UUID p:peripheral data:data];
}

-(void) notify: (CBPeripheral *)peripheral on:(BOOL)on
{
    [self notification:SERVICE_UUID characteristicUUID:CHAR_UUID p:peripheral on:YES];
}

#pragma mark - CBCentralManager Delegates

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@">>>CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@">>>CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
        {
//            NSLog(@">>>CBCentralManagerStatePoweredOn");
            //开始扫描周围的外设
            /*
             第一个参数nil就是扫描周围所有的外设，扫描到外设后会进入
             - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
             */
//            NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
//
//            [central scanForPeripheralsWithServices:nil options:options];
            [centralManager scanForPeripheralsWithServices:nil options:0];
        }
            
    
            break;
        default:
            break;
    }
}

//扫描到设备会进入方法
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (!peripherals) {
        
        peripherals = [[NSMutableArray alloc] initWithObjects:peripheral, nil];
        
        // 刷新tableView
        [self blueManagerToTableViewReloadData];
    }
    // 搜索到新的设备才会进入
    {
        if((__bridge CFUUIDRef )peripheral.identifier == NULL) return;
        //if(peripheral.name == NULL) return;
        //if(peripheral.name == nil) return;
        if(peripheral.name.length < 1) return;
        // 添加新的外设到peripherals数组
        for (int i = 0; i < [peripherals count]; i++) {
            CBPeripheral *p = [peripherals objectAtIndex:i];
            if((__bridge CFUUIDRef )p.identifier == NULL) continue;
            CFUUIDBytes b1 = CFUUIDGetUUIDBytes((__bridge CFUUIDRef )p.identifier);
            CFUUIDBytes b2 = CFUUIDGetUUIDBytes((__bridge CFUUIDRef )peripheral.identifier);
            if (memcmp(&b1, &b2, 16) == 0) {
                // 这些都是相同的，并取代旧的外设信息
                [peripherals replaceObjectAtIndex:i withObject:peripheral];
                
                [self blueManagerToTableViewReloadData];
                return;
            }
        }
//        printf("New peripheral is found...\n");
        [peripherals addObject:peripheral];
//        NSLog(@"peripherals = %@", peripherals);
//        [self blueManagerToTableViewReloadData];
        return;
    }
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    connectPeripheral = peripheral;
    connectPeripheral.delegate = self;
    
//    [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(peripheralDidUpdate:) userInfo:nil repeats:YES];
    
    [connectPeripheral discoverServices:nil];
    //[self notify:peripheral on:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(blueManagerPeripheralConnectSuccess)]) {
        [self.delegate blueManagerPeripheralConnectSuccess];
    }
    
//    NSLog(@">>>成功连接到名称为%@的设备-\n", connectPeripheral.name);
}

/** 蓝牙连接断开的时候调用的函数 */
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
//    NSLog(@"%@ -蓝牙断开连接", connectPeripheral.name);
    if(connectPeripheral != nil)
        connectPeripheral = nil;
    
    // 提示用户设备断开
    [self peripheralDidConnect];
    // 重新扫描设备
    [centralManager scanForPeripheralsWithServices:nil options:0];
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接蓝牙失败 %@: %@\n", [peripheral name], [error localizedDescription]);
}

#pragma mark - CBPeripheral delegates

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
//    printf("in updateValueForCharacteristic function\n");
    
    if (error) {
        printf("updateValueForCharacteristic failed\n");
        return;
    }
    [self userDataToEqualValueUpdated:@"FFE1" value:characteristic.value];
    
    self.characteristic = characteristic;
}

/*
 *  @discussion 获取设备的service的特征值
 */
-(void) getAllCharacteristicsFromKeyfob:(CBPeripheral *)p{
    for (int i=0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
//        printf("Fetching characteristics for service with UUID : %s\r\n",[self CBUUIDToString:s.UUID]);
        [p discoverCharacteristics:nil forService:s];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (!error) {
//        printf("Services of peripheral with UUID : %s found\r\n",[self UUIDToString:(__bridge CFUUIDRef )peripheral.identifier]);
        [self getAllCharacteristicsFromKeyfob:peripheral];
    }
    else {
        printf("Service discovery was unsuccessfull !\r\n");
    }
}

// 定时器刷新连接的蓝牙信号
- (void)peripheralDidUpdate:(CBPeripheral *)peripheral
{
    [connectPeripheral readRSSI];
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    NSLog(@"%@ = %ld",peripheral.name, (long)[RSSI integerValue]);
    [self performSelector:@selector(peripheralDidUpdate:) withObject:peripheral afterDelay:2.0];

    if (!error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(blueToolReturnRSSIValue:)]) {
            [self.delegate blueToolReturnRSSIValue:[RSSI intValue]];
        }
    } else {
        NSLog(@"读取RSSI error = %@", error);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (!error) {
        printf("Characteristics of service with UUID : %s found\r\n",[self CBUUIDToString:service.UUID]);
        for(int i = 0; i < service.characteristics.count; i++) { //Show every one
//            CBCharacteristic *c = [service.characteristics objectAtIndex:i];
//            printf("Found characteristic %s\r\n",[ self CBUUIDToString:c.UUID]);
        }
        char t[16];
        t[0] = (SERVICE_UUID >> 8) & 0xFF;
        t[1] = SERVICE_UUID & 0xFF;
        NSData *data = [[NSData alloc] initWithBytes:t length:16];
        CBUUID *uuid = [CBUUID UUIDWithData:data];
        //CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count - 1)];
        if([self compareCBUUID:service.UUID UUID2:uuid]) {
            printf("Try to open notify --- 订阅通知(才能接收到蓝牙发送的数据) \n");
            [self notify:peripheral on:YES];
        }
    }
    else {
        printf("Characteristic discorvery unsuccessfull !\r\n");
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (!error) {
//        printf("Updated notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[self UUIDToString:(__bridge CFUUIDRef )peripheral.identifier]);
    }
    else {
        printf("Error in setting notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[self UUIDToString:(__bridge CFUUIDRef )peripheral.identifier]);
        printf("Error code was %s\r\n",[[error description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
    }
}


- (void)userDataToEqualValueUpdated:(NSString *)UUID value:(NSData *)data
{
//    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//    NSLog(@"%@", value);
    
    [self blueManagerProcessingDataWith:[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
}

/** 解析蓝牙发送的数据 */
- (void)blueManagerProcessingDataWith:(NSString *)str
{
    // 拼接接收到的字符串数据
    reciveData = (reciveData == nil) ? [NSMutableString stringWithFormat:@"%@", str] : [NSMutableString stringWithFormat:@"%@%@", reciveData, str];
//    NSLog(@"%lu", (unsigned long)reciveData.length);
    
    self.iSExit = 0;
    
    while (reciveData.length >= 10 && self.iSExit <= 10) {
        
        self.iSExit += 1;
        
        self.aRange = [reciveData rangeOfString:@"a"];
        self.bRange = [reciveData rangeOfString:@"b"];
        
        if (self.aRange.location > 100000) {
            reciveData = nil;
//            NSLog(@"self.aRange.location > 100000");
            [self blueToolWriteValue:[NSString stringWithFormat:@"a99010000b"]];
        } else if (self.aRange.location != 0)
        {
            [reciveData deleteCharactersInRange:NSMakeRange(0, self.aRange.location)];
//            NSLog(@"self.aRange.location != 0");
            [self blueToolWriteValue:[NSString stringWithFormat:@"a99010000b"]];
            
        } else if (self.bRange.location > 100000)
        {
            [reciveData deleteCharactersInRange:NSMakeRange(0, 1)];
//            NSLog(@"self.bRange.location > 100000");
            [self blueToolWriteValue:[NSString stringWithFormat:@"a99010000b"]];
            
        } else if (self.bRange.location - self.aRange.location < 9)
        {
            
            [reciveData deleteCharactersInRange:NSMakeRange(0, self.bRange.location + 1)];
//            NSLog(@"self.bRange.location - self.aRange.location < 9");
            [self blueToolWriteValue:[NSString stringWithFormat:@"a99010000b"]];
            
        }
        else
        {
            if (reciveData.length >= 10) {
                //                NSLog(@"-- %@", self.receiveData);
                self.strData = [reciveData substringWithRange:NSMakeRange(0, 10)];
                [reciveData deleteCharactersInRange:NSMakeRange(0, self.bRange.location + 1)];
                //                NSLog(@"self.receiveData.length > 10");
                //                NSLog(@"%@ -- %@", self.mNewStr, self.receiveData);
            }else
            {
                self.strData = [NSString stringWithFormat:@"%@", reciveData];
                reciveData = nil;
            }
            
            [self didRusultDataWithNewStr:self.strData];
        }
    }
}

/**
  str:解析后的蓝牙数据
 */
- (void)didRusultDataWithNewStr:(NSString *)str
{
    switch ([[str substringWithRange:NSMakeRange(1, 4) ] integerValue]) {
        case 201:   // 开始拍照
            [self blueManagerOthersCommandWith:201];
            break;
        case 301:   // 开始录像
            [self blueManagerOthersCommandWith:301];
//            NSLog(@"开始录像 = %@", str);
            break;
        case 302:   // 暂停录像
            [self blueManagerOthersCommandWith:302];
//            NSLog(@"暂停录像 = %@", str);
            break;
        case 501:   // 查询对焦值
            [self blueManagerOthersCommandWith:501];
            break;
        case 503:   // 查询录像时间
            [self blueManagerOthersCommandWith:503];
            break;
        case 502:   // 查询相机状态
            [self blueManagerOthersCommandWith:502];
            break;
        case 1001:   // 当前手机倍率
            self.speed = (CGFloat)[[str substringWithRange:NSMakeRange(5, 4)] integerValue];
            [self blueManagerOthersCommandWith:1001];
//            NSLog(@"%f -- %@", self.speed, str);
            break;
        case 101:   // 开始自增
//            NSLog(@"str += %@", str);
            [self addAndMinusMoveDistanceWithStr:str context:ADD_MOVE_DISTANCE_ADD];
            break;
        case 102:   // 开始自减
//            NSLog(@"str -= %@", str);
            [self addAndMinusMoveDistanceWithStr:str context:MINUS_MOVE_DISTANCE_ADD];
            break;
        case 506:   // 查询系统当前界面
            [self blueManagerOthersCommandWith:506];
            break;
        case 701:   // 变焦+Number
//            NSLog(@"702 - %@", str);
            [self coreBlueChangeVideoZoom:str context:ADD_ZOOM_ADD];
            break;
        case 702:   // 变焦-Number
            [self coreBlueChangeVideoZoom:str context:MINUS_ZOOM_MINUS];
            break;
        case 901:   // 当前界面+1
            [self coreBlueAddOrMinus:CoreBlueTypeAdd];
            break;
        case 902:   // 当前界面-1
            [self coreBlueAddOrMinus:CoreBlueTypeMinus];
            break;
        case 507:   // 查询ZOOM数值
//            [self blueManagerOthersCommandWith:507];
//            [self blueToolWriteValue:[NSString stringWithFormat:@"a051%db",(-self.videoZoom + SHOW_Y) / (screenH - 30) * 1000]];
//            NSLog(@"%f", (-self.videoZoom + SHOW_Y) / (screenH - 30) * 1000);
            [self blueManagerOthersCommandWith:507];
            break;
        case 508:   // 查询快门数值
            [self blueToolWriteValue:@"a05130055b"];
            break;
        case 601:   // 重复录制开始
            [self blueManagerOthersCommandWith:601];
            break;
        case 602:   // 重复录制结束
            [self blueManagerOthersCommandWith:602];
            break;
        case 103:   // 对焦绝对复位值
            [self blueManagerResetVideo:103 andNum:[[str substringWithRange:NSMakeRange(5, 4)] integerValue]];
            break;
        case 703:   // 变焦绝对复位值
            [self blueManagerResetVideo:703 andNum:[[str substringWithRange:NSMakeRange(5, 4)] integerValue]];
        case 510:   // 查询屏幕分辨率
            [self blueManagerOthersCommandWith:510];
        case 511:   // 查询屏幕分辨率
            [self blueManagerOthersCommandWith:511];
            break;
        case 509:   // 查询镜头倍率
            switch (self.managerLens) {
                case JYBlueManagerLensOne:
                    [self blueToolWriteValue:[NSString stringWithFormat:@"a05140000b"]];
                    break;
                case JYBlueManagerLensTwo:
                    [self blueToolWriteValue:[NSString stringWithFormat:@"a05140001b"]];
                    break;
                case JYBlueManagerLensThree:
                    [self blueToolWriteValue:[NSString stringWithFormat:@"a05140002b"]];
                    break;
            }
            break;
            
        case 512:   // 查询镜头倍率
            switch (self.videoType) {
                case JYResetVideoTypeOne:
                    [self blueToolWriteValue:[NSString stringWithFormat:@"a05170000b"]];
                    break;
                case JYResetVideoTypeTwo:
                    [self blueToolWriteValue:[NSString stringWithFormat:@"a05170001b"]];
                    break;
            }
            break;
            
        default:
            [self blueToolWriteValue:[NSString stringWithFormat:@"a99010000b"]];
            break;
    }
}

- (void)blueManagerResetVideo:(NSInteger)type andNum:(NSInteger)num
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(blueManagerResetVideo:andNum:)]) {
        [self.delegate blueManagerResetVideo:type andNum:num];
    }
}

- (void)coreBlueAddOrMinus:(CoreBlueType)type
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(coreBlueAddOrMinus:)]) {
        [self.delegate coreBlueAddOrMinus:type];
    }
}

- (void)coreBlueInfoLogWith:(int)addNum minsNum:(int)minusNum
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(coreBlueInfoLogWith:minsNum:)]) {
        [self.delegate coreBlueInfoLogWith:addNum minsNum:minusNum];
    }
}

- (void)coreBlueChangeVideoZoom:(NSString *)str context:(void *)context
{
//    NSLog(@"%ld", (long)[[str substringWithRange:NSMakeRange(5, 4)] integerValue]);
    // 1.累加或者累减
    if (context == ADD_ZOOM_ADD) {
        switch (self.derection) {
            case CoreBlueDerectionClockwise:
                self.videoZoom += ([[str substringWithRange:NSMakeRange(5, 4)] integerValue]) / num_scale * (screenH - 30);
                break;
            case CoreBlueDerectionAntiClockwise:
                self.videoZoom -= ([[str substringWithRange:NSMakeRange(5, 4)] integerValue]) / num_scale * (screenH - 30);
                break;
                
            default:
                break;
        }
//        NSLog(@"+++ %f", self.videoZoom);
    } else if (context == MINUS_ZOOM_MINUS)
    {
        switch (self.derection) {
            case CoreBlueDerectionClockwise:
                self.videoZoom -= ([[str substringWithRange:NSMakeRange(5, 4)] integerValue]) / num_scale * (screenH - 30);
                break;
            case CoreBlueDerectionAntiClockwise:
                self.videoZoom += ([[str substringWithRange:NSMakeRange(5, 4)] integerValue]) / num_scale * (screenH - 30);
                break;
                
            default:
                break;
        }
    }
}

- (void)addAndMinusMoveDistanceWithStr:(NSString *)str context:(void *)context
{
    if (context == ADD_MOVE_DISTANCE_ADD) {
        switch (self.derection) {
            case CoreBlueDerectionClockwise:
                self.moveDistance += ([[str substringWithRange:NSMakeRange(5, 4)] integerValue]) / num_scale * (screenH - 30);
                break;
            case CoreBlueDerectionAntiClockwise:
                self.moveDistance -= ([[str substringWithRange:NSMakeRange(5, 4)] integerValue]) / num_scale * (screenH - 30);
                break;
                
            default:
                break;
        }
    } else if (context == MINUS_MOVE_DISTANCE_ADD)
    {
        switch (self.derection) {
            case CoreBlueDerectionClockwise:
                self.moveDistance -= ([[str substringWithRange:NSMakeRange(5, 4)] integerValue]) / num_scale * (screenH - 30);
                break;
            case CoreBlueDerectionAntiClockwise:
                self.moveDistance += ([[str substringWithRange:NSMakeRange(5, 4)] integerValue]) / num_scale * (screenH - 30);
                break;
                
            default:
                break;
        }
    }
    
//    if (self.moveDistance >= SHOW_Y) {
//        self.moveDistance = SHOW_Y;
//    }
//    if (self.moveDistance <= -SHOW_Y) {
//        self.moveDistance = -SHOW_Y;
//    }
}

/**
 *  发送数据到蓝牙设备
 *
 *  @param blueTool 当前类
 *  @param str      需要发送的数据
 */
- (void)blueToolWriteValue:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSASCIIStringEncoding];
//    NSLog(@"str ========= %@", str);
    
    if (self.characteristic) {
        
        [connectPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
}

// 中心设备往蓝牙发送数据是否成功
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
//    if (error) {
//        NSLog(@"发送失败 error = %@", error);
//    } else {
//        NSLog(@"发送成功");
//    }
}

#pragma mark -------------------------> 蓝牙代理

/** 蓝牙发送的指令和查询指令 */
- (void)blueManagerOthersCommandWith:(NSInteger)num
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(blueManagerOthersCommandWith:)])
    {
        [self.delegate blueManagerOthersCommandWith:num];
    }
}

/** 提示用户设备断开 */
- (void)peripheralDidConnect
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(blueManagerPeripheralDidConnect)])
    {
        [self.delegate blueManagerPeripheralDidConnect];
    }
}

/** 告诉蓝牙显示界面刷新tableView */
- (void)blueManagerToTableViewReloadData
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(blueManagerToTableViewReloadData)])
    {
        [self.delegate blueManagerToTableViewReloadData];
    }
}

-(void) notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on {
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUIDEx:su p:p];
    if (!service) {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:(__bridge CFUUIDRef )p.identifier]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUIDEx:cu service:service];
    if (!characteristic) {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:(__bridge CFUUIDRef )p.identifier]);
        return;
    }
    [p setNotifyValue:on forCharacteristic:characteristic];
}


-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data {
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUIDEx:su p:p];
    if (!service) {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:(__bridge CFUUIDRef )p.identifier]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUIDEx:cu service:service];
    if (!characteristic) {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:(__bridge CFUUIDRef )p.identifier]);
        return;
    }
    if(characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse)
    {
        [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
    }else
    {
        [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

/*!
 *  @method swap:
 *
 *  @param s Uint16 value to byteswap
 *
 *  @discussion swap byteswaps a UInt16
 *
 *  @return Byteswapped UInt16
 */

- (UInt16)swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

- (CBService *)findServiceFromUUIDEx:(CBUUID *)UUID p:(CBPeripheral *)p {
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    return nil; //Service not found on this peripheral
}

- (int)compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2 {
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1 length:16];
    [UUID2.data getBytes:b2 length:16];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}

/*
 *  @param UUID CBUUID转换为字符串
 *
 *  @returns 一个包含字符串表示UUID字符缓冲区指针
 */
- (const char *)CBUUIDToString:(CBUUID *) UUID {
    return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}

/*
 *  @method UUIDToString
 *
 *  @param CFUUIDRef转换为字符串
 *
 */
- (const char *)UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);
    
}

-(CBCharacteristic *) findCharacteristicFromUUIDEx:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil; //Characteristic not found on this service
}

@end

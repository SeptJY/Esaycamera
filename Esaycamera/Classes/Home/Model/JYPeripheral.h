//
//  JYPeripheral.h
//  SeptOfCamera
//
//  Created by Sept on 15/12/31.
//  Copyright © 2015年 九月. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>

@interface JYPeripheral : NSObject

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *identifier;

@property (assign, nonatomic) NSString *isUser;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;

@end

//
//  JYPeripheral.m
//  SeptOfCamera
//
//  Created by Sept on 15/12/31.
//  Copyright © 2015年 九月. All rights reserved.
//

#import "JYPeripheral.h"

@implementation JYPeripheral

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral
{
    self = [super init];
    if (self) {
        
        self.name = peripheral.name;
        
        self.identifier = [peripheral.identifier UUIDString];
    }
    return self;
}

// 当将一个自定义对象保存到文件的时候就会调用该方法
// 在该方法中说明如何存储自定义对象的属性
// 也就说在该方法中说清楚存储自定义对象的哪些属性
- (void)encodeWithCoder:(NSCoder *)aCoder
{
//    NSLog(@"调用了encodeWithCoder:方法");
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
}

// 当从文件中读取一个对象的时候就会调用该方法
// 在该方法中说明如何读取保存在文件中的对象
// 也就是说在该方法中说清楚怎么读取文件中的对象
- (id)initWithCoder:(NSCoder *)aDecoder
{
//    NSLog(@"调用了initWithCoder:方法");
    //注意：在构造方法中需要先初始化父类的方法
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
    }
    return self;
}


@end

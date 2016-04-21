//
//  JYTestView.m
//  SeptOnCamera
//
//  Created by Sept on 16/1/28.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYCoreBlueView.h"

#import <CoreBluetooth/CoreBluetooth.h>

#define headViewHeight 25   // 标题高度

@interface JYCoreBlueView() <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CBPeripheral *peripheral;

@property (strong, nonatomic) UIView *headView;

@property (assign, nonatomic) BOOL isSave;   // 判断蓝牙是否需要保存

@end

@implementation JYCoreBlueView

- (instancetype)initWithPeripherals:(NSMutableArray *)peripherals
{
    self = [super init];
    if (self) {
        
        self.peripherals = peripherals;
        
        self.tableView.rowHeight = JYCortrolWidth;
    }
    return self;
}

- (UIView *)headView
{
    if (_headView == nil) {
        
        _headView = [[UIView alloc] init];
        
        _headView.backgroundColor = [UIColor yellowColor];
        _headView.alpha = 0.4;
        
        [self addSubview:_headView];
    }
    return _headView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.text = NSLocalizedString(@"其他设备", nil);
        _titleLabel.font = setFont(15);
        _titleLabel.textColor = [UIColor blueColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        [self.headView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor yellowColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.peripherals.count) ? self.peripherals.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"test";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor yellowColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//        cell.selectedBackgroundView.backgroundColor = setColor(230, 230, 230);
//        cell.selectedBackgroundView.alpha = 0.4;
        
//        cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    }
    
    if (self.peripherals.count > 0) {
        CBPeripheral *peripheral = self.peripherals[indexPath.row];
        cell.textLabel.text = peripheral.name;
        
        if ([peripheral.name isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"Checkmark"]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.tintColor = [UIColor yellowColor];
        }
        
    } else
    {
        cell.textLabel.text = @"未搜索到周围的服务";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.peripheral = self.peripherals[indexPath.row];
    JYPeripheral *selectPer = [[JYPeripheral alloc] initWithPeripheral:self.peripheral];
    
    [[NSKeyedUnarchiver unarchiveObjectWithFile:path_encode] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        JYPeripheral *mPer = obj;
        // 判断保存数据库中是否存在当前选中选中的蓝牙设备
        if ([mPer.identifier isEqualToString:selectPer.identifier]) {
            self.isSave = YES;
        }
    }];
    
    if (self.isSave == NO && self.peripherals != nil) {
        [[JYSeptManager sharedManager] saveCoreBlueWith:selectPer];
    }
    
    [self coreBlueViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath];
    
    // 保存当前选中的值
    [[NSUserDefaults standardUserDefaults] setValue:selectPer.name forKey:@"Checkmark"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
}

- (void)coreBlueViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(coreBlueViewDidSelectRowAtIndexPath:)]) {
        [self.delegate coreBlueViewDidSelectRowAtIndexPath:indexPath];
    }
}

- (void)layoutSubviews
{
    CGSize labelSize = [NSString sizeWithText:self.titleLabel.text font:self.titleLabel.font maxSize:CGSizeMake(200, 50)];

    self.headView.frame = CGRectMake(0, 0, self.width, 35);
    
    self.titleLabel.frame = CGRectMake(10, (self.headView.height - labelSize.height) / 2, labelSize.width, labelSize.height);
    
    self.tableView.frame = CGRectMake(0, self.headView.height, self.width, self.height - self.headView.height);
}

@end

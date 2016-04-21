//
//  JYVideoTimeView.m
//  SeptCamera
//
//  Created by Sept on 16/3/4.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYVideoTimeView.h"

#import <objc/runtime.h>

static void *JYSHOWVIEW_FRAME = &JYSHOWVIEW_FRAME;

@interface JYVideoTimeView()
{
    NSTimer *_timer;
    int hours;
    int minutes;
    CGFloat seconds;
}

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIImageView *iRlectricityView;
@property (strong, nonatomic) UIView *redView;
@property (strong, nonatomic) UIView *showView;

@end

@implementation JYVideoTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        hours = 0;
        seconds = 0.0;
        minutes = 0;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerObserver) userInfo:nil repeats:YES];
        
        [_timer setFireDate:[NSDate distantFuture]];
        
        [self.showView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:JYSHOWVIEW_FRAME];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context == JYSHOWVIEW_FRAME) {
        if (self.showView.width <= 3.80) {
            self.showView.backgroundColor = [UIColor redColor];
        } else if (self.showView.width > 3.80)
        {
            self.showView.backgroundColor = [UIColor whiteColor];
        }
    }
}

/** 定时器监听事件 */
- (void)timerObserver
{
    // 获取手机电量
    [self getCurrentBatteryLevel];
    
    seconds += 0.5;
    self.redView.hidden = (self.redView.hidden == NO) ? YES : NO;
    
    if (seconds == 60) {
        minutes++;
        seconds = 0;
        if (minutes == 60) {
            hours++;
            seconds = 0;
        }
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, (int)seconds];
}

- (NSString *)videoTime
{
    return [NSString stringWithFormat:@"a050%db", 30000 + (hours * 3600 + minutes * 60 + (int)seconds)];
}

/** 开始定时器 */
- (void)startTimer
{
    self.hidden = NO;
    // 设置当前时刻，计时器就会开始工作。
    [_timer setFireDate:[NSDate date]];
}

/** 录像时间定时器停止后 重新清零 */
- (void)stopTimer
{
    self.hidden = YES;
    
    hours = 0;
    seconds = 0;
    minutes = 0;
    [_timer setFireDate:[NSDate distantFuture]];
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d ",hours, minutes,(int)seconds];
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc] init];
        UIFont *font = (screenH >= 375) ? setFont(15) : setFont(12);
        _timeLabel.text = @"00:00:00";
        _timeLabel.font = font;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIImageView *)iRlectricityView
{
    if (!_iRlectricityView) {
        
        _iRlectricityView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_dianliang_icon"]];
        
        [self addSubview:_iRlectricityView];
    }
    return _iRlectricityView;
}

- (UIView *)redView
{
    if (!_redView) {
        
        _redView = [[UIView alloc] init];
        _redView.backgroundColor = [UIColor redColor];
        
        [self addSubview:_redView];
    }
    return _redView;
}

- (UIView *)showView
{
    if (!_showView) {
        
        _showView = [[UIView alloc] init];
        
        _showView.backgroundColor = [UIColor whiteColor];
        
        [self.iRlectricityView addSubview:_showView];
    }
    return _showView;
}

- (void)layoutSubviews
{
    // 1.设置红色灯的frame
    CGFloat redW = 8;
    CGFloat redH = redW;
    CGFloat redX = 5;
    CGFloat redY = (self.height - redW) * 0.5;
    
    self.redView.frame = CGRectMake(redX, redY, redW, redH);
    self.redView.layer.cornerRadius = redW * 0.5;
    
    // 2.设置时间label的frame
    CGSize labelSize = [NSString sizeWithText:self.timeLabel.text font:self.timeLabel.font maxSize:CGSizeMake(200, 50)];
    CGFloat labelX = self.redView.x + self.redView.width + 5;
    CGFloat lableY = (self.height - labelSize.height) * 0.5;
    
    self.timeLabel.frame = CGRectMake(labelX, lableY, labelSize.width + 5, labelSize.height);
    
    // 3.设置电量图片的frmae
    CGFloat rlectricityW = 25;
    CGFloat rlectricityH = self.iRlectricityView.image.size.height;
    CGFloat rlectricityX = self.timeLabel.x + self.timeLabel.width + 5;
    CGFloat rlectricityY = (self.height - rlectricityH) * 0.5;
    
    self.iRlectricityView.frame = CGRectMake(rlectricityX, rlectricityY, rlectricityW, rlectricityH);
    
    // 4.设置电量显示的frmae
    CGFloat showW = 19;    // 默认宽度为0
    CGFloat showH = 8;
    CGFloat showX = 2;
    CGFloat showY = 2;
    
    self.showView.frame = CGRectMake(showX, showY, showW, showH);
}

- (int)getCurrentBatteryLevel
{
    UIApplication *app = [UIApplication sharedApplication];
    
    if (app.applicationState == UIApplicationStateActive||app.applicationState==UIApplicationStateInactive) {
        Ivar ivar=  class_getInstanceVariable([app class],"_statusBar");
        id status  = object_getIvar(app, ivar);
        for (id aview in [status subviews]) {
            int batteryLevel = 0;
            for (id bview in [aview subviews]) {
                if ([NSStringFromClass([bview class]) caseInsensitiveCompare:@"UIStatusBarBatteryItemView"] == NSOrderedSame&&[[[UIDevice currentDevice] systemVersion] floatValue] >=6.0)
                {
                    
                    Ivar ivar=  class_getInstanceVariable([bview class],"_capacity");
                    if(ivar)
                    {
                        batteryLevel = ((int (*)(id, Ivar))object_getIvar)(bview, ivar);
                        //这种方式也可以
                        /*ptrdiff_t offset = ivar_getOffset(ivar);
                         unsigned char *stuffBytes = (unsigned char *)(__bridge void *)bview;
                         batteryLevel = * ((int *)(stuffBytes + offset));*/
                        self.showView.width = (CGFloat)batteryLevel/100 * 19;
                        if (batteryLevel > 0 && batteryLevel <= 100) {
                            return batteryLevel;
                            
                        } else {
                            return 0;
                        }
                    }
                    
                }
                
            }
        }
    }
    
    return 0;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame" context:JYSHOWVIEW_FRAME];
}

@end

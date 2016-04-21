//
//  JYTestController.m
//  Esaycamera
//
//  Created by Sept on 16/4/8.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYMainController.h"

#import "JYCameraManager.h"
#import "JYMainHead.h"

@interface JYMainController () <JYCameraManagerDelegate, JYVideoViewDelegate, MWPhotoBrowserDelegate, JYBlueManagerDelegate, JYCoreBlueViewDelegate, JYContentViewDelegate, JYLeftTopViewDelegate, DWBubbleMenuViewDelegate, JYSliderViewDelegate, JYSliderImageViewDelegate>

@property (strong, nonatomic) JYCameraManager *videoCamera;

@property (strong, nonatomic) UIView *subView;
@property (strong, nonatomic) UIView *bottomPreview;

@property (strong, nonatomic) JYVideoView *videoView;

@property (strong, nonatomic) UIView *ruleBottomView;
@property (strong, nonatomic) CALayer *layer;
@property (strong, nonatomic) UIImageView *iFocusView;
@property (strong, nonatomic) UIImageView *iZoomView;

@property (assign, nonatomic) CoreBlueUseModel1 useModel;

@property (strong, nonatomic) JYCoreBlueView *coreBlueView;
@property (strong, nonatomic) JYBlueManager *blueManager;

@property (strong, nonatomic) JYVideoTimeView *videoTimeView;

@property (strong, nonatomic) JYLeftTopView *leftTopView;

@property (strong, nonatomic) DWBubbleMenuButton *menuBtn;

@property (strong, nonatomic) JYContenView *myContentView;

@property (assign, nonatomic) CGFloat saveFocusNum;
@property (assign, nonatomic) CGFloat saveVideoZoom;

@property (assign, nonatomic) CGFloat focusNum;
@property (assign, nonatomic) CGFloat zoomNum;

@property (strong, nonatomic) UIImageView *grladView;

@property (strong, nonatomic) JYShowInfoView *infoView;

@property (assign, nonatomic) CGFloat temp;
@property (assign, nonatomic) CGFloat tint;
@property (assign, nonatomic) BOOL tempAuto;
@property (assign, nonatomic) BOOL tintAuto;
@property (assign, nonatomic) BOOL isoAuto;
@property (assign, nonatomic) BOOL timeAuto;
@property (assign, nonatomic) CamereFangDaModel fangDaModel;

/** 拍照状态 */
@property (assign, nonatomic) BOOL photoSuccess;

@property (strong, nonatomic) JYSliderImageView *sliderImageView;

@property (assign, nonatomic) NSInteger timeNum;

@end

@implementation JYMainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self homeOfFirstConnectPeripheral];
    [self.blueManager findBLKAppPeripherals:0];
    
    [NSTimer scheduledTimerWithTimeInterval:20.0/1000 target:self selector:@selector(ruleImgViewTimer) userInfo:nil repeats:YES];
    
    [self addObservers];
}

#pragma mark -------------------------> 相机操作
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.videoCamera startCamera];
    [self.subView addSubview:self.menuBtn];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.videoCamera stopCamera];
}

- (JYCameraManager *)videoCamera {
    if (!_videoCamera) {
        _videoCamera = [[JYCameraManager alloc] initWithFrame:self.view.bounds superview:self.view];
        _videoCamera.cameraDelegate = self;
        [self.bottomPreview addSubview:_videoCamera.subPreview];
//        [self.scaleView addSubview:_videoCamera.subPreview];
    }
    return _videoCamera;
}

#pragma mark -------------------------> 蓝牙管理者和蓝牙界面显示
- (JYBlueManager *)blueManager
{
    if (!_blueManager) {
        
        _blueManager = [[JYBlueManager alloc] init];
        
        _blueManager.delegate = self;
    }
    return _blueManager;
}

/** 程序已启动自动去数据库中查找蓝牙 */
- (void)homeOfFirstConnectPeripheral
{
    if ([self.blueManager connectPeripheral]) {
        if (self.blueManager.connectPeripheral.state == CBPeripheralStateConnected) {
            [self.blueManager.centralManager cancelPeripheralConnection:self.blueManager.connectPeripheral];
            self.blueManager.connectPeripheral = nil;
        }
    }
    
    if ([self.blueManager peripherals]) {
        self.blueManager.peripherals = nil;
    }
}

/** 设置的内容视图 */
- (JYContenView *)myContentView
{
    if (!_myContentView) {
        
        _myContentView = [[JYContenView alloc] init];
        
        _myContentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:BG_ALPHA];
        _myContentView.delegate = self;
        _myContentView.hidden = YES;
        
        [self.subView addSubview:_myContentView];
    }
    return _myContentView;
}

/** 局部放大的背景View */
- (UIView *)bottomPreview
{
    if (!_bottomPreview) {
        
        CGFloat bottomW = screenW - 2 * BOTTOM_PREVIEW_X;
        CGFloat bottomH = bottomW * 3 / 4;
        CGFloat bottomY = (screenH - bottomH) * 0.5;
        
        _bottomPreview = [[UIView alloc] initWithFrame:CGRectMake(BOTTOM_PREVIEW_X, bottomY, bottomW, bottomH)];
        _bottomPreview.hidden = YES;
        _bottomPreview.clipsToBounds = YES;
        
        [self.view addSubview:_bottomPreview];
    }
    return _bottomPreview;
}

/** sliderImageView */
- (JYSliderImageView *)sliderImageView
{
    if (!_sliderImageView) {
        
        _sliderImageView = [[JYSliderImageView alloc] init];
        _sliderImageView.hidden = YES;
        _sliderImageView.delegate = self;
        
        [self.subView addSubview:_sliderImageView];
    }
    return _sliderImageView;
}

/** 录像、拍照按钮的背景 */
- (JYVideoView *)videoView
{
    if (!_videoView) {
        
        _videoView = [[JYVideoView alloc] init];
        _videoView.delegate = self;
        
        [self.subView addSubview:_videoView];
    }
    return _videoView;
}

#pragma mark -------------------------> 刻度尺操作
/** 图片底部的背景View */
- (UIView *)ruleBottomView
{
    if (!_ruleBottomView) {
        
        _ruleBottomView = [[UIView alloc] init];
        _ruleBottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:BG_ALPHA];
        CALayer *layer = [CALayer layer];
        
        //设置需要显示的图片
        layer.contents=(id)[UIImage imageNamed:@"home_i_show_view_icon"].CGImage;
        
        [_ruleBottomView.layer addSublayer:layer];
        self.layer = layer;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(ruleImgViewGesture:)];
        
        [_ruleBottomView addGestureRecognizer:panGesture];
        
        [self.subView addSubview:_ruleBottomView];
    }
    return _ruleBottomView;
}

/** 九宫格 */
- (UIImageView *)grladView
{
    if (!_grladView) {
        _grladView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_grid_icon"]];
        _grladView.hidden = ![[NSUserDefaults standardUserDefaults] boolForKey:@"grladView_hidden"];
        
        [self.view insertSubview:_grladView belowSubview:self.subView];
    }
    return _grladView;
}

/** 刻度尺图片View */
- (UIImageView *)iFocusView
{
    if (!_iFocusView) {
        
        _iFocusView = [self createImageViewWithImage:@"home_i_rule_view_icon"];
    }
    return _iFocusView;
}

- (UIImageView *)iZoomView
{
    if (!_iZoomView) {
        
        _iZoomView = [self createImageViewWithImage:@"home_dz_rule_icon"];
        _iZoomView.hidden = YES;
    }
    return _iZoomView;
}

- (UIImageView *)createImageViewWithImage:(NSString *)image
{
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.image = [UIImage imageNamed:image];
    imageView.layer.opacity = ([[NSUserDefaults standardUserDefaults] floatForKey:@"opacity"] == 0) ? 1 : [[NSUserDefaults standardUserDefaults] floatForKey:@"opacity"];
    imageView.opaque = NO;
    
    [self.ruleBottomView addSubview:imageView];
    
    return imageView;
}

/** 录像时间显示 */
- (JYVideoTimeView *)videoTimeView
{
    if (!_videoTimeView) {
        
        _videoTimeView = [[JYVideoTimeView alloc] init];
        _videoTimeView.hidden = YES;
        _videoTimeView.layer.opacity = ([[NSUserDefaults standardUserDefaults] floatForKey:@"opacity"] == 0) ? 1 : [[NSUserDefaults standardUserDefaults] floatForKey:@"opacity"];
        
        [self.subView addSubview:_videoTimeView];
    }
    return _videoTimeView;
}

/** 左上角设置按钮和快捷键按钮 */
- (JYLeftTopView *)leftTopView
{
    if (!_leftTopView) {
        
        _leftTopView = [[JYLeftTopView alloc] init];
        _leftTopView.backgroundColor = [UIColor clearColor];
        _leftTopView.delegate = self;
        
        [self.subView addSubview:_leftTopView];
    }
    return _leftTopView;
}

/** 蓝牙显示的View */
- (JYCoreBlueView *)coreBlueView
{
    if (!_coreBlueView) {
        
        _coreBlueView = [[JYCoreBlueView alloc] initWithPeripherals:self.blueManager.peripherals];
        _coreBlueView.hidden = YES;
        _coreBlueView.delegate = self;
        
        [self.subView addSubview:_coreBlueView];
    }
    return _coreBlueView;
}

/** 蓝牙显示的View */
- (JYShowInfoView *)infoView
{
    if (!_infoView) {
        
        _infoView = [[JYShowInfoView alloc] init];
        
        [self.subView addSubview:_infoView];
    }
    return _infoView;
}

- (DWBubbleMenuButton *)menuBtn
{
    if (!_menuBtn) {
        //        UILabel *label = [self createHomeButtonView];
        _menuBtn = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(18.f, 10.f, 35, 35) expansionDirection:DirectionDown];
        //        _menuBtn.direction = DirectionDown;
        
        _menuBtn.delegate = self;
        
        _menuBtn.homeButtonView = self.leftTopView.label;
        
        [_menuBtn addButtons:[self createDemoButtonArray]];
    }
    return _menuBtn;
}

#pragma mark -------------------------> DWBubbleMenuViewDelegate
/** 按钮显示之后 */
- (void)bubbleMenuButtonWillExpand:(DWBubbleMenuButton *)expandableView
{
    //    NSLog(@"%s", __func__);
    self.leftTopView.isShow = YES;
}

/** 按钮掩藏之后 */
- (void)bubbleMenuButtonDidCollapse:(DWBubbleMenuButton *)expandableView
{
    //    NSLog(@"%s", __func__);
    self.leftTopView.isShow = NO;
}

- (NSArray *)createDemoButtonArray
{
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    NSArray *imageArray = @[@"home_MF_click_icon", @"home_video_icon" , @"home_photo_icon", @"home_photo_tv_icon", @"home_fangda_icon"];
    int i = 0;
    for (NSString *title in @[@"home_ZM_click_icon", @"home_video_click_icon", @"home_photo_click_icon", @"home_photo_tv_click_icon", @"home_fangda_click_icon"]) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:title] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0.f, 0.f, 35.f, 35.f);
        button.clipsToBounds = YES;
        button.tag = 100 + i;
        
        if (i == 1) {
            button.selected = YES;
        }
        
        [button addTarget:self action:@selector(plusButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsMutable addObject:button];
        i++;
    }
    
    return [buttonsMutable copy];
}

- (void)plusButtonOnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
            btn.selected = !btn.selected;
            if (btn.selected) {    // ZOOM
                self.iFocusView.hidden = YES;
                self.iZoomView.hidden = NO;
                self.useModel = CoreBlueUseModel1ZOOM;
            }else                  // Focus
            {
                self.iFocusView.hidden = NO;
                self.iZoomView.hidden = YES;
                self.useModel = CoreBlueUseModel1Focus;
            }
            break;
        case 101:   // Video
        {
            // 遍历button按钮
            for (int i = 101; i < 104; i ++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:i];
                button.selected = NO;
            }
            btn.selected = YES;
            self.videoView.isVideo = NO;
            self.sliderImageView.hidden = !self.videoView.isVideo;
            
            [self.videoCamera exposeMode:AVCaptureExposureModeContinuousAutoExposure];
        }
            break;
        case 102:    // photo
            for (int i = 101; i < 104; i ++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:i];
                button.selected = NO;
            }
            btn.selected = YES;
            self.videoView.isVideo = YES;
            self.sliderImageView.hidden = self.videoView.isVideo;
            
            [self.videoCamera exposeMode:AVCaptureExposureModeContinuousAutoExposure];
            break;
        case 103:    // photo_tv
            for (int i = 101; i < 104; i ++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:i];
                button.selected = NO;
            }
            btn.selected = YES;
            
            self.videoView.isVideo = YES;
            self.sliderImageView.hidden = !btn.selected;
            break;
        case 104:    // 放大
            btn.selected = !btn.selected;
            
            if (self.sliderImageView.hidden == NO) {
                self.sliderImageView.hidden = YES;
                
                UIButton *button = [self.view viewWithTag:103];
                button.selected = NO;
            }
            
//            NSLog(@"%d -- %lu", btn.selected, (unsigned long)self.fangDaModel);
            if (self.fangDaModel == CamereFangDaModelHidden && btn.selected == 0) {
                self.fangDaModel = CamereFangDaModelAuto;
                self.bottomPreview.hidden = YES;
            } else if (self.fangDaModel == CamereFangDaModelLock)
            {
                self.bottomPreview.hidden = YES;
                self.fangDaModel = CamereFangDaModelAuto;
            } else
            {
                self.bottomPreview.hidden = NO;
                self.fangDaModel = CamereFangDaModelLock;
            }
            
            [self performSelector:@selector(sliderViewHidden) withObject:self afterDelay:slider_view_hidden_time];
            break;
            
        default:
            break;
    }
}

- (void)sliderViewHidden
{
    if (self.bottomPreview.hidden == NO) {
        self.bottomPreview.hidden = YES;
    }
}

#pragma mark -------------------------> 刻度尺操作
- (void)ruleImgViewGesture:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateChanged || panGesture.state == UIGestureRecognizerStateEnded) {
        
        CGPoint translation = [panGesture translationInView:self.ruleBottomView];
        switch (self.useModel) {
            case CoreBlueUseModel1Focus:
                self.blueManager.moveDistance += translation.y;
                break;
            case CoreBlueUseModel1ZOOM:
                self.blueManager.videoZoom += translation.y;
                break;
            default:
                break;
        }
        [panGesture setTranslation:CGPointMake(0, 0) inView:self.ruleBottomView];
    }
}

- (void)ruleImgViewTimer
{
    self.focusNum = [self blueManagerType:self.blueManager.moveDistance andNum:-SHOW_Y qubie:1];
    self.zoomNum = [self blueManagerType:self.blueManager.videoZoom andNum:0 qubie:0];
    
    switch (self.useModel) {
        case CoreBlueUseModel1Focus:
            [self ruleImageWithFoucus];
            break;
        case CoreBlueUseModel1ZOOM:
            [self ruleImageWithZoom];
            break;
        case CoreBlueUseModel1DurationAndZoom:
            [self ruleImageWithZoom];
            break;
        case CoreBlueUseModel1DurationAndFucus:
            [self ruleImageWithFoucus];
//            break;
        case CoreBlueUseModel1RepeatRecording:
        {
            // 调焦
            if (self.saveFocusNum != self.blueManager.moveDistance) {
                
                self.iFocusView.hidden = NO;
                self.iZoomView.hidden = YES;
                //                NSLog(@"self.iFocusView.y = %f", self.iFocusView.y);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:AnimationTime/1000 animations:^{
                        self.iFocusView.transform = CGAffineTransformMakeTranslation(0, self.focusNum);
                    }];
                });
                
                // 30是showView的高度   -- 调节微距
                [self.videoCamera cameraManagerChangeFoucus:(1 - (-self.blueManager.moveDistance + SHOW_Y) / (screenH - 30))];
                // 3.保存最后一次的移动距离
                self.saveFocusNum = self.blueManager.moveDistance;
            }
            
            if (self.saveVideoZoom != self.blueManager.videoZoom) {
                
                self.iFocusView.hidden = YES;
                self.iZoomView.hidden = NO;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:AnimationTime/1000 animations:^{
                        self.iZoomView.transform = CGAffineTransformMakeTranslation(0, self.zoomNum);
                    }];
                });
                [self.videoCamera cameraManagerVideoZoom:(-self.blueManager.videoZoom + SHOW_Y) / (screenH - 30)];
                self.saveVideoZoom = self.blueManager.videoZoom;
            }
        }
            break;
        default:
            break;
    }
}

- (CGFloat)blueManagerType:(CGFloat)type andNum:(CGFloat)num qubie:(NSInteger)qubie
{
    if (type <= 0) {
        type = 0;
    }
    if (type >= 2 * SHOW_Y) {
        type = 2 * SHOW_Y;
    }
    if (qubie == 1) {
        self.blueManager.moveDistance = type;
    } else
    {
        self.blueManager.videoZoom = type;
    }
    CGFloat realNum = type + num;
    
    return realNum;
}

- (void)ruleImageWithFoucus
{
    // 1.刷新对焦刻度尺的y坐标
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:AnimationTime/1000 animations:^{
            self.iFocusView.transform = CGAffineTransformMakeTranslation(0, self.focusNum);
        }];
    });
    // 2.当对焦值改变的时候系统进行对焦
    if (self.saveFocusNum != self.iFocusView.y) {
        
        // 2.1 30是showView的高度   -- 调节微距
        [self.videoCamera cameraManagerChangeFoucus:(1 - (-self.iFocusView.y + SHOW_Y) / (screenH - 30))];
        
        // 2.2显示放大的View和sliderView
        if (self.fangDaModel == CamereFangDaModelLock) {
            self.bottomPreview.hidden = NO;
            self.timeNum = 250;
        }
        // 2.3.保存最后一次的移动距离
        self.saveFocusNum = self.iFocusView.y;
    }
    // 3.控制放大view的显示与掩藏
    self.timeNum--;
    
    if (self.timeNum == 0) {
        
        self.bottomPreview.hidden = YES;
        
        self.timeNum = 0;
    }
}

- (void)ruleImageWithZoom
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:AnimationTime/1000 animations:^{
            self.iZoomView.transform = CGAffineTransformMakeTranslation(0, self.zoomNum);
        }];
    });
    // ZOOM
    if (self.saveVideoZoom != self.iZoomView.y) {
        //                NSLog(@"%f", (-self.iZoomView.y + SHOW_Y) / (screenH - 30));
        [self.videoCamera cameraManagerVideoZoom:(-self.iZoomView.y + SHOW_Y) / (screenH - 30)];
        self.saveVideoZoom = self.iZoomView.y;
    }
}

- (void)videoViewButtonOnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 21:    // 录像
            btn.selected = !btn.selected;
            if (btn.selected) {
                [self.videoCamera startVideo];
                [self.videoTimeView startTimer];
                self.leftTopView.imgHidden = YES;
            } else
            {
                [self.videoCamera stopVideo];
                [MBProgressHUD showMessage:@"正在保存..."];
                [self.videoTimeView stopTimer];
                self.leftTopView.imgHidden = NO;
            }
            
            break;
        case 22:    // 拍照
            [self startPhoto];
            break;
        case 23:    // 图片选择
        {
            [[JYSaveVideoData sharedManager] photosArrayAndthumbsArrayValue];
            
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            
            browser.zoomPhotosToFill = YES;
            browser.enableSwipeToDismiss = NO;
            [browser setCurrentPhotoIndex:0];
            
            [self.navigationController pushViewController:browser animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)startPhoto
{
    CATransition *shutterAnimation = [CATransition animation];
    [shutterAnimation setDelegate:self];
    // シャッター速度
    [shutterAnimation setDuration:0.2];
    shutterAnimation.timingFunction = UIViewAnimationCurveEaseInOut;
    [shutterAnimation setType:@"cameraIris"];
    [shutterAnimation setValue:@"cameraIris" forKey:@"cameraIris"];
    CALayer *cameraShutter = [[CALayer alloc]init];
    //    [cameraShutter setBounds:CGRectMake(0.0, 0.0, 320.0, 425.0)];
    [self.view.layer addSublayer:cameraShutter];
    [self.view.layer addAnimation:shutterAnimation forKey:@"cameraIris"];
    [self.videoCamera takePhoto];
}

#pragma mark -------------------------> JYCameraManagerDelegate
- (void)cameraManageTakingPhotoSucuess:(NSData *)data
{
    self.videoView.imageData = data;
}

- (void)cameraManagerRecodingSuccess:(NSURL *)url
{
    self.videoView.imgUrl = url;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"保存成功"];
    });
    
}

#pragma mark -------------------------> JYLeftTopViewDelegate 显示和掩藏contentView和快捷键
- (void)leftTopViewQuickOrSettingBtnOnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 11:
            btn.selected = !btn.selected;
            if (self.coreBlueView.hidden == NO) {
                self.coreBlueView.hidden = YES;
            }
            self.myContentView.hidden = !btn.selected;
            break;
        default:
            break;
    }
}

- (UIView *)subView
{
    if (!_subView) {
        
        _subView = [[UIView alloc] init];
        
        [self.view addSubview:_subView];
    }
    return _subView;
}

#pragma mark -------------------------> JYCoreBlueViewDelegate
- (void)coreBlueViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.如果当前选中的蓝牙设备和当前连接的不相等
    //    CBPeripheral *mPer = self.blueManager1.peripherals[indexPath.row];
    if (self.blueManager.peripherals) {
        
        if (self.blueManager.connectPeripheral == nil) {
            // 2.2 连接选中的蓝牙
            [self.blueManager connect:self.blueManager.peripherals[indexPath.row]];
        } else
        {
            if (self.blueManager.connectPeripheral != self.blueManager.peripherals[indexPath.row]) {
                // 2.1 断开当前连接的设备
                [self.blueManager disconnect:self.blueManager.connectPeripheral];
                
                // 2.2 连接选中的蓝牙
                [self.blueManager connect:self.blueManager.peripherals[indexPath.row]];
            }
        }
        // 保存当前连接的蓝牙名称，
        [JYSeptManager sharedManager].perName = self.blueManager.connectPeripheral.name;
    }
    
    self.coreBlueView.hidden = YES;
    self.myContentView.hidden = NO;
}


#pragma mark -------------------------> JYContentViewDelegate
/** 显示蓝牙界面 */
- (void)contentViewLabelDirectionBtnOnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 50:  // 蓝牙界面显示
            self.coreBlueView.peripherals = self.blueManager.peripherals;
            
            self.myContentView.hidden = YES;
            self.coreBlueView.hidden = NO;
            
            [self.coreBlueView.tableView reloadData];
            break;
        case 53:  // 手轮方向调节
            if (btn.selected == 1) {
                if ([btn.currentTitle isEqualToString:@"正"]) {
                    [btn setTitle:@"反" forState:UIControlStateNormal];
                } else
                {
                    [btn setTitle:@"Negative" forState:UIControlStateNormal];
                }
                self.blueManager.derection = CoreBlueDerectionAntiClockwise;
            } else {
                if ([btn.currentTitle isEqualToString:@"反"]) {
                    [btn setTitle:@"正" forState:UIControlStateNormal];
                } else
                {
                    [btn setTitle:@"Negative" forState:UIControlStateNormal];
                }
                self.blueManager.derection = CoreBlueDerectionClockwise;
            }
            [[NSUserDefaults standardUserDefaults] setInteger:btn.selected forKey:BlueDerection];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            break;
            
        default:
            break;
    }
}

/**  摄像头，闪光灯，九宫格 */
- (void)contentViewSwitchOnClick:(UISwitch *)mSwitch
{
    switch (mSwitch.tag) {
        case 40:    // 摄像头
            if (self.videoCamera.videoSize.width != 3840.0) {
                [self.videoCamera rotateCamera];
            } else
            {
                UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您好，当前3840x2160分辨率不支持前置摄像头" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    mSwitch.on = NO;
                }];
                [alertCtl addAction:okAction];
                
                [self presentViewController:alertCtl animated:YES completion:nil];
            }
            break;
        case 42:    // 闪光灯
            self.videoCamera.enableFlash = mSwitch.on;
            break;
        case 41:    // 九宫格
            self.grladView.hidden = !mSwitch.on;
            // 保存设置
            [[NSUserDefaults standardUserDefaults] setBool:mSwitch.on forKey:@"grladView_hidden"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            break;
            
        default:
            break;
    }
}

/** 恢复默认设置 */
- (void)contentViewResetBtnOnClick:(UIButton *)btn
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"参数重置" message:@"相机设置将全部恢复为默认设置？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RestoreDefaults" object:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/** JYResolutionViewDelegate  相机质量选择 */
- (void)contentViewDirectionCellBtnOnClick:(UIButton *)btn
{
    // 提示用户仅支持iphone6及其以上设备
    if (btn.tag == 63 && screenH < 375) {
        
        UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您好，当前设备不支持3840x2160" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alertCtl addAction:okAction];
        
        [self presentViewController:alertCtl animated:YES completion:nil];
    } else
    {
        [self.videoCamera cameraManagerEffectqualityWithTag:btn.tag];
    }
    
    switch (btn.tag) {
        case 60:
            self.videoCamera.videoSize = CGSizeMake(640.0, 480.0);
            break;
        case 61:
            self.videoCamera.videoSize = CGSizeMake(1280.0, 720.0);
            break;
        case 62:
            self.videoCamera.videoSize = CGSizeMake(1920.0, 1080.0);
            break;
        case 63:
            if (screenH > 320) {    // iPhone6 及以上设备
                
                self.videoCamera.videoSize = CGSizeMake(3840.0, 2160.0);
            }
            
            break;
            
        default:
            break;
    }
}

/** 设置对比度 */
- (void)contentViewCustomSliderValueChange:(UISlider *)slider
{
    self.iFocusView.layer.opacity = slider.value;
    self.iZoomView.layer.opacity = slider.value;
    self.videoTimeView.layer.opacity = slider.value;
}

/******************   白平衡设置  *****/
/** 设置白平衡滑动数据 */
- (void)contentViewBalanceCustomSliderValueChange:(UISlider *)slider
{
    switch (slider.tag) {
        case 50:     // 色温
        {
            self.temp = slider.value;
            AVCaptureWhiteBalanceTemperatureAndTintValues temperatureAndTint = {
                .temperature = self.temp,
                .tint = self.tint,
            };
            [self.videoCamera cameraManagerSetWhiteBalanceGains:[self.videoCamera.inputCamera deviceWhiteBalanceGainsForTemperatureAndTintValues:temperatureAndTint]];
        }
            break;
        case 51:     // 色调
        {
            self.tint = slider.value;
            AVCaptureWhiteBalanceTemperatureAndTintValues temperatureAndTint = {
                .temperature = self.temp,
                .tint = self.tint,
            };
            [self.videoCamera cameraManagerSetWhiteBalanceGains:[self.videoCamera.inputCamera deviceWhiteBalanceGainsForTemperatureAndTintValues:temperatureAndTint]];
        }
            break;
        case 52:     // 饱和度
            [self.videoCamera.filter setSaturation:[(UISlider *)slider value]];
            break;
            
        default:
            break;
    }
}

/** 设置白平衡自动和手动 */
- (void)contentViewBalanceAutoBtnOnClick:(UIButton *)btn
{
    //    NSLog(@"%ld",(long)btn.selected);
    switch (btn.tag) {
        case 30:    // 色温
            self.tempAuto = !btn.selected;
            if (self.tintAuto == 0 && self.tempAuto == 0) {   // 如果色调当前处于手动状态
                [self.videoCamera whiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
            } else
            {
                [self.videoCamera whiteBalanceMode:AVCaptureWhiteBalanceModeLocked];
            }
            
            break;
        case 31:    // 色调
            self.tintAuto = !btn.selected;
            if (self.tintAuto == 0 && self.tempAuto == 0) {   // 如果色调当前处于手动状态
                [self.videoCamera whiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
            } else
            {
                [self.videoCamera whiteBalanceMode:AVCaptureWhiteBalanceModeLocked];
            }
            break;
            
        default:
            break;
    }
}

/** 天气滤镜 */
- (void)contentViewWetherButtonOnClick:(UIButton *)btn
{
    self.tintAuto = YES;
    self.tempAuto = YES;
    
    [self.videoCamera whiteBalanceMode:AVCaptureWhiteBalanceModeLocked];
    
    switch (btn.tag) {
        case 80:      // 荧光
            [self.videoCamera cameraManagerBalanceGainsWithTemp:4200.0 andTint:81.0];
            break;
        case 81:      // 灯泡
            [self.videoCamera cameraManagerBalanceGainsWithTemp:3400.0 andTint:25.0];
            break;
        case 82:      // 晴天
            [self.videoCamera cameraManagerBalanceGainsWithTemp:5000.0 andTint:0.0];
            break;
        case 83:      // 阴天
            [self.videoCamera cameraManagerBalanceGainsWithTemp:4886.0 andTint:52.0];
            break;
        case 84:      // 蓝天
            [self.videoCamera whiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
            break;
        default:
            break;
    }
}

- (void)contentViewExpsureCustomSliderValueChange:(UISlider *)slider
{
    switch (slider.tag) {
        case 61:     // 感光度
        {
            NSError *error = nil;
            if ( [self.videoCamera.inputCamera lockForConfiguration:&error] ) {
                [self.videoCamera.inputCamera setExposureModeCustomWithDuration:AVCaptureExposureDurationCurrent ISO:slider.value completionHandler:nil];
                [self.videoCamera.inputCamera unlockForConfiguration];
            }
            else {
                NSLog( @"Could not lock device for configuration: %@", error );
            }
        }
            break;
        case 62:     // 曝光时间
            [self setExposureDurationWith:slider.value];
            break;
        case 63:     // 曝光补偿
            [self.videoCamera cameraManagerWithExposure:slider.value];
            break;
            
        default:
            break;
    }
}

static const float kExposureMinimumDuration = 1.0/1000;
static const float kExposureDurationPower = 5;
- (void)setExposureDurationWith:(CGFloat)value
{
    NSError *error = nil;
    
    double p = pow( value, kExposureDurationPower ); // Apply power function to expand slider's low-end range
    double minDurationSeconds = MAX( CMTimeGetSeconds(self.videoCamera.inputCamera.activeFormat.minExposureDuration ), kExposureMinimumDuration );
    double maxDurationSeconds = CMTimeGetSeconds(self.videoCamera.inputCamera.activeFormat.maxExposureDuration );
    double newDurationSeconds = p * ( maxDurationSeconds - minDurationSeconds ) + minDurationSeconds; // Scale from 0-1 slider range to actual duration
    
    if (self.sliderImageView.hidden == NO) {
        
        if ( newDurationSeconds < 1 ) {
            int digits = MAX( 0, 2 + floor( log10( newDurationSeconds ) ) );
            self.sliderImageView.label.text = [NSString stringWithFormat:@"1/%.*f", digits, 1/newDurationSeconds];
        }
        else {
            self.sliderImageView.label.text = [NSString stringWithFormat:@"%.2f", newDurationSeconds];
        }
    }
    
    if ( [self.videoCamera.inputCamera lockForConfiguration:&error] ) {
        [self.videoCamera.inputCamera setExposureModeCustomWithDuration:CMTimeMakeWithSeconds( newDurationSeconds, 1000*1000*1000 )  ISO:AVCaptureISOCurrent completionHandler:nil];
        [self.videoCamera.inputCamera unlockForConfiguration];
    }
    else {
        NSLog( @"Could not lock device for configuration: %@", error );
    }
}

/** 曝光自动和手动的监听事件 */
- (void)contentViewExpsureAutoBtnOnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 41:    // 感光度
            self.isoAuto = !btn.selected;
            if (btn.selected) {
                [self.videoCamera exposeMode:AVCaptureExposureModeContinuousAutoExposure];
            } else {
                [self.videoCamera exposeMode:AVCaptureExposureModeLocked];
            }
            break;
        case 42:    // 曝光时间
            self.timeAuto = !btn.selected;
            if (btn.selected) {
                [self.videoCamera exposeMode:AVCaptureExposureModeContinuousAutoExposure];
            } else {
                [self.videoCamera exposeMode:AVCaptureExposureModeLocked];
            }
            break;;
            
        default:
            break;
    }
}

- (void)contentViewPushEsaycamWebView
{
    JYWebViewController *webCtl = [[JYWebViewController alloc] init];
    
    [self.navigationController pushViewController:webCtl animated:YES];
    
    [MBProgressHUD showMessage:@"正在加载中..."];
}

- (void)contentViewCameraLensViewCellBtnOnClick:(UIButton *)btn
{
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否安装了其他镜头" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (btn.tag) {
            case 80:      // 默认
                self.infoView.dzText = @"x1";
                self.blueManager.managerLens = JYBlueManagerLensOne;
                break;
            case 81:      // 2倍增距镜
                self.infoView.dzText = @"x2";
                self.blueManager.managerLens = JYBlueManagerLensTwo;
                break;
            case 82:      // 3倍增距镜
                self.infoView.dzText = @"x3";
                self.blueManager.managerLens = JYBlueManagerLensThree;
                break;
                
            default:
                break;
        }
    }];
    
    [alertCtl addAction:okAction];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.myContentView contenViewCameraLensViewShowOneCell];
        self.infoView.dzText = @"x1";
    }];
    [alertCtl addAction:noAction];
    
    [self presentViewController:alertCtl animated:YES completion:nil];
}

- (void)contentViewResetVideo:(UIButton *)btn
{
    switch (btn.tag) {
        case 80:
            self.blueManager.videoType = JYResetVideoTypeOne;
            break;
        case 81:
            self.blueManager.videoType = JYResetVideoTypeTwo;
            break;
    }
}

#pragma mark -------------------------> JYSliderImageViewDelegate
- (void)sliderImageViewValueChange:(UISlider *)sender
{
    [self setExposureDurationWith:sender.value];
}

#pragma mark -------------------------> JYBlueManagerDelegate
- (void)blueManagerToTableViewReloadData
{
    // 1.判断当前连接蓝牙是否为空 --- 为空的话就去解挡
    if (self.blueManager.connectPeripheral == nil) {
        
        // 2.解挡遍历保存的蓝牙数据
        [[NSKeyedUnarchiver unarchiveObjectWithFile:path_encode] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            //            NSLog(@"解挡数组  %@", [NSKeyedUnarchiver unarchiveObjectWithFile:path_encode]);
            
            JYPeripheral *codePer = obj;
            // 3.遍历蓝牙数据中的数据
            for (CBPeripheral *isPer in self.blueManager.peripherals) {
                JYPeripheral *mPer = [[JYPeripheral alloc] initWithPeripheral:isPer];
                //                NSLog(@"蓝牙数组中 %@", isPer.name);
                // 3.1判断是否相同
                if ([codePer.identifier isEqualToString:mPer.identifier]) {
                    // 3.2相同的话说明之前连接过此蓝牙  直接连接
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (self.blueManager.connectPeripheral == nil) {
                            [self.blueManager connect:isPer];
                            self.blueManager.connectPeripheral = isPer;
                        }
                    });
                    // 3.3保存当前连接的蓝牙名称
                    [JYSeptManager sharedManager].perName = isPer.name;
                    [MBProgressHUD showSuccess:@"蓝牙已连接"];
//                    self.infoView.image = @"home_core_blue_normal";
                    //                    break;
                }
            }
        }];
    }
    
    [self.coreBlueView.tableView reloadData];
}

/** 蓝牙发送的指令和查询指令 */
- (void)blueManagerOthersCommandWith:(NSInteger)num
{
    switch (num) {
        case 201:   // 拍照
            [self startPhoto];
            break;
        case 301:   // 录像开始
            [self.videoCamera startVideo];
            [self.videoTimeView startTimer];
            self.leftTopView.imgHidden = YES;
            if (self.useModel == CoreBlueUseModel1RepeatRecording) {
                [self.videoView startResetVideoing];
            }
            break;
        case 302:   // 录像停止
            [self.videoTimeView stopTimer];
            [self.videoCamera stopVideo];
            self.leftTopView.imgHidden = NO;
            if (self.useModel == CoreBlueUseModel1RepeatRecording) {
                [self.videoView stopResetVideoing];
            }
            break;
        case 501:   // 查询当前对焦值
            [self.blueManager blueToolWriteValue:[NSString stringWithFormat:@"a050%db", (int)(10000 + (1- (-self.iFocusView.y + SHOW_Y) / (screenH - 30)) * 1000)]];
            break;
        case 502:   // 查询当前相机状态
            // 返回拍照成功状态
            if (self.photoSuccess == 1) {
                [self.blueManager blueToolWriteValue:@"a05020001b"];  // 拍照完成
                self.photoSuccess = 0;
            }
            
            if (self.videoTimeView.hidden == 0) {
                [self.blueManager blueToolWriteValue:@"a05020002b"];  // 录像中
            } else if (self.videoTimeView.hidden == 1)
            {
                [self.blueManager blueToolWriteValue:@"a05020000b"];  // 空闲中
            }
            break;
        case 506:   // 查询当前手机系统当前界面
            switch (self.useModel) {
                case CoreBlueUseModel1Focus:
                    [self.blueManager blueToolWriteValue:@"a05110002b"];  // 调焦
                    break;
                case CoreBlueUseModel1ZOOM:
                    [self.blueManager blueToolWriteValue:@"a05110003b"];  // ZOOM
                    break;
//                case CoreBlueUseModel1Duration:
//                    [self.blueManager blueToolWriteValue:@"a05110000b"];  // 对焦
                    break;
                case CoreBlueUseModel1DurationAndZoom:
                    [self.blueManager blueToolWriteValue:@"a05110001b"];  // 快+ZOOM
                    break;
                case CoreBlueUseModel1DurationAndFucus:
                    [self.blueManager blueToolWriteValue:@"a05110000b"];  // 快+Focus
                    break;
                    
                default:
                    break;
            }
            break;
        case 507:   // 查询当前ZOOM
            if (self.iZoomView.y <= -SHOW_Y) {
                self.iZoomView.y = -SHOW_Y;
            }
            [self.blueManager blueToolWriteValue:[NSString stringWithFormat:@"a051%db", (int)(20000 + (1.0- (-self.iZoomView.y + SHOW_Y) / (screenH - 30)) * 1000)]];
            break;
        case 601:   // 重复录制开始
            self.useModel = CoreBlueUseModel1RepeatRecording;
            break;
        case 602:   // 重复录制结束
            self.iFocusView.hidden = NO;
            self.iZoomView.hidden = YES;
            self.useModel = CoreBlueUseModel1Focus;
            break;
        case 511:   // 查询手轮方向
            switch (self.blueManager.derection) {
                case CoreBlueDerectionClockwise:
                    [self.blueManager blueToolWriteValue:@"a05160000b"];
                    break;
                case CoreBlueDerectionAntiClockwise:
                    [self.blueManager blueToolWriteValue:@"a05160001b"];
                    break;
                    
                default:
                    break;
            }
            break;
        case 1001:   // 蓝牙手轮速率（显示）
            self.infoView.raNum = self.blueManager.speed;
            
            break;
        default:
            break;
    }
}

- (void)blueManagerPeripheralConnectSuccess
{
    self.infoView.image = @"home_core_blue_normal";
    [MBProgressHUD showSuccess:@"蓝牙连接成功"];
}

- (void)coreBlueAddOrMinus:(CoreBlueType)type
{
    switch (type) {
        case CoreBlueTypeAdd:
            // 当前在调焦模式和ZOOM模式时 界面 +1的话 就是处于调焦模式
            if (self.useModel == CoreBlueUseModel1Focus || self.useModel == CoreBlueUseModel1ZOOM)
            {
                self.useModel = CoreBlueUseModel1ZOOM;
                self.iZoomView.hidden = NO;
                self.iFocusView.hidden = YES;
                self.sliderImageView.hidden = YES;
                self.videoView.isVideo = NO;
            }
            else if (self.useModel == CoreBlueUseModel1DurationAndFucus)  // 当前在快门时间模式时 界面 -1的话  就是处于ZOOM模式
            {
                self.useModel = CoreBlueUseModel1DurationAndZoom;
                self.iZoomView.hidden = NO;
                self.iFocusView.hidden = YES;
                self.sliderImageView.hidden = NO;
                self.videoView.isVideo = YES;
            } else if (self.useModel == CoreBlueUseModel1DurationAndZoom)  // 当前在快门时间模式时 界面 -1的话  就是处于ZOOM模式
            {
                self.useModel = CoreBlueUseModel1Focus;
                self.iFocusView.hidden = NO;
                self.iZoomView.hidden = YES;
                self.sliderImageView.hidden = YES;
                self.videoView.isVideo = NO;
            }
            break;
        case CoreBlueTypeMinus:
//             当前在调焦模式和ZOOM模式时 界面 -1的话 就是处于调焦模式
            if (self.useModel == CoreBlueUseModel1DurationAndZoom || self.useModel == CoreBlueUseModel1DurationAndFucus)
            {
                self.useModel = CoreBlueUseModel1DurationAndFucus;
                self.iZoomView.hidden = YES;
                self.iFocusView.hidden = NO;
                self.sliderImageView.hidden = NO;
                self.videoView.isVideo = YES;
            } else if (self.useModel == CoreBlueUseModel1Focus)  // 当前在快门时间模式和ZOOM时 界面 -1的话  就是处于快门时间模式
            {
                self.useModel = CoreBlueUseModel1DurationAndZoom;
                self.iZoomView.hidden = NO;
                self.iFocusView.hidden = YES;
                self.sliderImageView.hidden = NO;
                self.videoView.isVideo = YES;
            } else if (self.useModel == CoreBlueUseModel1ZOOM)  // 当前在快门时间模式和ZOOM时 界面 -1的话  就是处于快门时间模式
            {
                self.useModel = CoreBlueUseModel1Focus;
                self.iZoomView.hidden = YES;
                self.iFocusView.hidden = NO;
                self.sliderImageView.hidden = YES;
                self.videoView.isVideo = NO;
            }
            break;
            
        default:
            break;
    }
}

/** 提示用户设备断开 */
- (void)blueManagerPeripheralDidConnect
{
    [MBProgressHUD showError:@"蓝牙连接中断"];
    self.infoView.image = @"home_core_blue_error";
    self.infoView.raNum = 10.0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
    });
}

- (void)viewWillLayoutSubviews
{
    self.subView.frame = CGRectMake(0, 0, screenW, screenH);
    
    self.ruleBottomView.frame = CGRectMake(screenW - JYCortrolWidth, 0, JYCortrolWidth, screenH);
    self.layer.frame = CGRectMake(0, (screenH - 30) * 0.5, 50, 30);
    
    // 3.设置录像、拍照按钮的View
    self.videoView.frame = CGRectMake(screenW - self.ruleBottomView.width - JYCortrolWidth, 0, JYCortrolWidth, screenH);
    
    self.iFocusView.frame = CGRectMake(0, 0, JYCortrolWidth, screenH);
    self.iZoomView.frame = CGRectMake(0, -SHOW_Y, JYCortrolWidth, screenH);
    
    // 4.录像时间显示
    CGFloat videoTimeW = (screenH >= 375) ? 130 : 110;
    CGFloat videoTimeH = 30;
    CGFloat videoTimeX = (screenW - videoTimeW) * 0.5;
    CGFloat videoTimeY = JYSpaceWidth;
    
    self.videoTimeView.frame = CGRectMake(videoTimeX, videoTimeY, videoTimeW, videoTimeH);
    
    // 5.左上角的View  -- 设置和快捷键
    self.leftTopView.frame = CGRectMake(0, 0, 120, 55);
    
    // 5.设置的内容视图
    CGFloat contentX = 70;
    CGFloat contentY = self.leftTopView.height;
    CGFloat contentW = self.videoView.x - 90;
    CGFloat contentH = screenH - contentY - JYSpaceWidth;
    
    self.myContentView.frame = CGRectMake(contentX, contentY, contentW, contentH);
    
    self.coreBlueView.frame = self.myContentView.frame;
    
    self.sliderImageView.frame = CGRectMake(self.myContentView.x, screenH - 50, self.myContentView.width, 30);
    
    self.infoView.frame = CGRectMake(screenW - JYCortrolWidth - 130, JYSpaceWidth, 130, 30);
    
    self.grladView.frame = CGRectMake(0, 0, screenW, screenH);
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [JYSaveVideoData sharedManager].photosArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < [JYSaveVideoData sharedManager].photosArray.count)
        return [[JYSaveVideoData sharedManager].photosArray objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < [JYSaveVideoData sharedManager].thumbsArray.count)
        return [[JYSaveVideoData sharedManager].thumbsArray objectAtIndex:index];
    return nil;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。
    // Add code to clean up any of your own resources that are no longer necessary.
    
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidLoad
    if ([self.view window] == nil)// 是否是正在使用的视图
    {
        // Add code to preserve data stored in the views that might be
        // needed later.
        
        // Add code to clean up other strong references to the view in
        // the view hierarchy.
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
    
    NSLog(@"%s", __func__);
}

#pragma mark KVO and Notifications
- (void)addObservers
{
    // 1.监听会话是否开启
    [self.videoCamera.captureSession addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:SessionRunningContext];
    // 实时监听白平衡的变化
    [self.videoCamera.inputCamera addObserver:self forKeyPath:@"deviceWhiteBalanceGains" options:NSKeyValueObservingOptionNew context:DeviceWhiteBalanceGains];
    
    // 实时监听对焦值的变化
    [self.videoCamera.inputCamera addObserver:self forKeyPath:@"lensPosition" options:NSKeyValueObservingOptionNew context:CaptureLensPositionContext];
    
    // 实时监听曝光偏移的变化exposureTargetOffset
    [self.videoCamera.inputCamera addObserver:self forKeyPath:@"exposureTargetOffset" options:NSKeyValueObservingOptionNew context:DeviceExposureOffset];
    
    // 实时监听感光度的变化
    [self.videoCamera.inputCamera addObserver:self forKeyPath:@"ISO" options:NSKeyValueObservingOptionNew context:DeviceExposureISO];
    
    // 实时监听曝光时间的变化
    [self.videoCamera.inputCamera addObserver:self forKeyPath:@"exposureDuration" options:NSKeyValueObservingOptionNew context:DeviceExposureDuration];
    
    [self addObserver:self forKeyPath:@"saveVideoZoom" options:NSKeyValueObservingOptionNew context:FoucsChange];
}

#pragma KVO监听事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    id oldValue = change[NSKeyValueChangeOldKey];
    id newValue = change[NSKeyValueChangeNewKey];
    
    // 2.监听捕捉图片
    if ( context == CapturingStillImageContext ) {
        BOOL isCapturingStillImage = [change[NSKeyValueChangeNewKey] boolValue];
        
        if ( isCapturingStillImage ) {
            dispatch_async( dispatch_get_main_queue(), ^{
                //                self.previewView.layer.opacity = 0.0;
                //                [UIView animateWithDuration:0.25 animations:^{
                //                    self.previewView.layer.opacity = 1.0;
                //                }];
            } );
        }
    } else if (context == CaptureLensPositionContext) {  // 对焦值
        //        [JYSeptManager sharedManager].focusValue = videoCamera.inputCamera.lensPosition;
        //        NSLog(@"lensPosition = %f", videoInput.device.lensPosition);
    } else if (context == DeviceWhiteBalanceGains) {  // 白平衡
        if (self.tempAuto == 0 && self.tintAuto == 0) {
            AVCaptureWhiteBalanceTemperatureAndTintValues temperatureAndTintValues = [self.videoCamera.inputCamera temperatureAndTintValuesForDeviceWhiteBalanceGains:self.videoCamera.inputCamera.deviceWhiteBalanceGains];
            [self.myContentView contentViewSetCustomSliderValue:temperatureAndTintValues.temperature andCustomSliderTag:50 classType:1];
            [self.myContentView contentViewSetCustomSliderValue:temperatureAndTintValues.tint andCustomSliderTag:51 classType:1];
        }
        else if ( newValue && newValue != [NSNull null] ) {
            AVCaptureWhiteBalanceGains newGains;
            [newValue getValue:&newGains];
            AVCaptureWhiteBalanceTemperatureAndTintValues newTemperatureAndTint = [self.videoCamera.inputCamera temperatureAndTintValuesForDeviceWhiteBalanceGains:newGains];
            
            if (self.videoCamera.inputCamera.whiteBalanceMode != AVCaptureExposureModeLocked ) {
                
                [self.myContentView contentViewSetCustomSliderValue:newTemperatureAndTint.temperature andCustomSliderTag:50 classType:1];
                [self.myContentView contentViewSetCustomSliderValue:newTemperatureAndTint.tint andCustomSliderTag:51 classType:1];
            }
        }
    }
    else if (context == DeviceExposureISO) {   // 感光度
        if (self.isoAuto == 0) {
            //            self.f_iso = videoCamera.inputCamera.ISO;
            [self.myContentView contentViewSetCustomSliderValue:self.videoCamera.inputCamera.ISO andCustomSliderTag:61 classType:0];
        }
    }
    
    else if (context == DeviceExposureOffset) {   // 曝光偏移
        [self.myContentView contentViewSetCustomSliderValue:self.videoCamera.inputCamera.exposureTargetOffset andCustomSliderTag:60 classType:0];
    }
    else if (context == DeviceExposureDuration) {   // 曝光时间
        
        if ( newValue && newValue != [NSNull null] ) {
            double newDurationSeconds = CMTimeGetSeconds( [newValue CMTimeValue] );
            if (self.videoCamera.inputCamera.exposureMode != AVCaptureExposureModeCustom ) {
                double minDurationSeconds = MAX( CMTimeGetSeconds(self.videoCamera.inputCamera.activeFormat.minExposureDuration ), kExposureMinimumDuration );
                double maxDurationSeconds = CMTimeGetSeconds(self.videoCamera.inputCamera.activeFormat.maxExposureDuration );
                // Map from duration to non-linear UI range 0-1
                double p = ( newDurationSeconds - minDurationSeconds ) / ( maxDurationSeconds - minDurationSeconds ); // Scale to 0-1
                [self.myContentView contentViewSetCustomSliderValue:pow( p, 1 / kExposureDurationPower ) andCustomSliderTag:62 classType:0];
                
                self.sliderImageView.slider.value = pow( p, 1 / kExposureDurationPower );
            }
        }
    }
    else if (context == FoucsChange) {   // 曝光偏移
        
//        if (self.iZoomView.y <= -SHOW_Y) {
//            self.iZoomView.y = -SHOW_Y;
//        }
//        
//        if (self.iZoomView.y >= SHOW_Y) {
//            self.iZoomView.y = SHOW_Y;
//        }
    }
    
    // 1.监听会话是否开启
    else if ( context == SessionRunningContext ) {
//        BOOL isSessionRunning = [change[NSKeyValueChangeNewKey] boolValue];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // 只有当设备有多个摄像头时才有能力改变相机
            //            self.cameraButton.enabled = isSessionRunning && ( [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count > 1 );
            //            self.recordButton.enabled = isSessionRunning;
            //            self.stillButton.enabled = isSessionRunning;
        } );
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end

//
//  JYWebViewController.m
//  Esaycamera
//
//  Created by Sept on 16/4/5.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYWebViewController.h"

#import "JYTabBarView.h"

@interface JYWebViewController () <UIWebViewDelegate, JYTabBarViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@property (strong, nonatomic) JYTabBarView *tabBarView;

@end

/**
     @property (nonatomic, readonly, getter=canGoBack) BOOL canGoBack;
     @property (nonatomic, readonly, getter=canGoForward) BOOL canGoForward;
     @property (nonatomic, readonly, getter=isLoading) BOOL loading;
 */

@implementation JYWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton=YES;
}

- (UIWebView *)webView
{
    if (!_webView) {
        
        _webView = [[UIWebView alloc] init];
        
        // 网页内容缩小到适应整个设备屏幕
        _webView.scalesPageToFit = YES;
        // 检测各种特殊的字符串：比如电话、网站
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        _webView.delegate = self;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ezcam360.com"]]];
        
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
    
    [self.tabBarView refeshBtn:self.webView.loading forwardBtn:self.webView.canGoForward backBtn:self.webView.canGoBack];
}

- (JYTabBarView *)tabBarView
{
    if (!_tabBarView) {
        
        _tabBarView = [[JYTabBarView alloc] init];
        _tabBarView.backgroundColor  = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _tabBarView.delegate = self;
        
        [self.view addSubview:_tabBarView];
    }
    return _tabBarView;
}

#pragma mark -------------------------> JYTabBarViewDelegate
- (void)tabBarBtnOnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 10:    // 前进
            [self.webView goForward];
            break;
        case 11:    // 后退
            [self.webView goBack];
            break;
        case 12:    // 刷新
            [self.webView reload];
            break;
        case 13:    // 返回相机
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}

- (void)viewWillLayoutSubviews
{
    self.tabBarView.frame = CGRectMake(0, 0, screenW, 44);
    
    self.webView.frame = CGRectMake(0, 44, screenW, screenH);
}

@end

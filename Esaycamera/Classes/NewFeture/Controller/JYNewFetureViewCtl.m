//
//  JYNewFetureViewCtl.m
//  HongHaRecipe
//
//  Created by admin on 15/10/14.
//  Copyright © 2015年 Sept. All rights reserved.
//

#import "JYNewFetureViewCtl.h"

#import "JYItemsData.h"
#import "JYMainController.h"
#import "MJExtension.h"
#import "JYNavigationController.h"

// 每个分页的宽度
#define pageControlDotW 30
// 每个分页的高度
#define pageControlDotH 3
// 分页直接的宽度
#define pageControlDotSpacing 10

@interface JYNewFetureViewCtl () <UIScrollViewDelegate>

// 分页控制器
@property (strong, nonatomic) UIView *pageView;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIButton *loginBtn;

// 当前滑动到第几页
@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) NSArray *backgroundViews;
@property (nonatomic, strong) NSArray *scrollViewPages;

// 存放每个页面的图片 和 文字
@property (nonatomic, strong) NSArray *items;

@end

@implementation JYNewFetureViewCtl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 掩藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
    
    self.currentPage = 0;
    NSLog(@"%@", NSStringFromCGRect(self.pageView.frame));
    [self setupCustomPageController];
    
    [self setupBackgroundView];
    
    [self reloadPages];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH)];
        
        self.scrollView.showsHorizontalScrollIndicator = NO;
        // 默认值是。如果是的话，能越过边缘内容回来
        self.scrollView.bounces = NO;
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)pageView
{
    if (!_pageView) {
        
        _pageView = [[UIView alloc] initWithFrame:CGRectMake(0, self.loginBtn.y - 40, screenW, 20)];
        
        [self.view insertSubview:_pageView aboveSubview:self.scrollView];
    }
    return _pageView;
}

- (NSArray *)items
{
    if (_items == nil) {
        // 初始化
        
        // 1.通过plist的全路径加载数组
        NSDictionary *mDict=[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JYNewFeturnData" ofType:@"plist"]];
        
        // 保存模型对象的可变数组
        NSMutableArray *itemsArray = [NSMutableArray array];
        
        // 3.将dictArray 里面的所有字典转换成模型对象，放到新的数组中
        for (NSDictionary *dict in mDict[@"items"]) {
            
            // 3.1>创建模型
            JYItemsData *item = [JYItemsData mj_objectWithKeyValues:dict];
            
            // 3.3>添加模型对象到数组中
            [itemsArray addObject:item];
        }
        // 4.赋值
        _items = itemsArray;
    }
    return _items;
}

/**
  创建自定义的pageController
 */
- (void)setupCustomPageController
{
    int maxW = screenW - 20;
    
    int pageCtlWidth = (int)(pageControlDotW * self.items.count + pageControlDotSpacing * (self.items.count - 1));
    
    int startPoint = (maxW/2) - (pageCtlWidth/2);
    
    for (int i = 0; i< self.items.count; i++) {
        
        UIView *view = [[UIView alloc] init];
        
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = i==self.currentPage ? 1.0 : 0.3;
        view.tag = i;
        CGRect rect = view.frame;
        rect.origin.x = startPoint+((pageControlDotW+pageControlDotSpacing)*i);
        rect.origin.y = self.pageView.height/2 + pageControlDotH/2;
        rect.size.width = pageControlDotW;
        rect.size.height = pageControlDotH;
        view.frame = rect;
        
        [self.pageView addSubview:view];
    }
}

- (void)setupBackgroundView
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    NSMutableArray *tmp2Array = [NSMutableArray array];
    
    [[[[self items] reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        JYItemsData *item = obj;
        
        UIView *subView = [[UIView alloc] initWithFrame:self.view.bounds];
        
        subView.tag = index + 1;
        
        // 背景图片
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:item.bg]];
        
        imgView.frame = self.view.bounds;
        imgView.tag = index + 10;
        imgView.userInteractionEnabled = YES;
        
        // 创建文字描述label （分页控制器上面的）
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenW - 20, 60)];
        
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.numberOfLines = 0;
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.font = setFont(14);
        descLabel.textColor = [UIColor whiteColor];
        descLabel.text = item.desc;
        [descLabel sizeToFit];
        
        CGRect rect = descLabel.frame;
        rect.origin.y = (self.pageView.y-10) - (index == self.items.count - 1? 20:40) - (screenW == 320 ? 0:40) - descLabel.height;
        rect.size.width = screenW - 20;
        descLabel.frame = rect;
        
        [subView addSubview:descLabel];
        
        // 创建标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenW - 20, 60)];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:22];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = item.title;
        [titleLabel sizeToFit];
        rect = titleLabel.frame;
        rect.origin.y = descLabel.y - 10 - titleLabel.height;
        rect.size.width = screenW - 20;
        titleLabel.frame = rect;
        
        // 设置图片下面的title
        if(item.title != nil)  [subView addSubview:titleLabel];
        
        int introImgViewY = item.title ? titleLabel. y- 10 - 50 : descLabel.y - 10 - 50;
        
        // 文字上面的图片
        UIImageView *introImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:item.img]];
        introImgView.frame = CGRectMake(10, introImgViewY, screenW - 20, 50);
        introImgView.contentMode = UIViewContentModeCenter;
        
        [subView addSubview:introImgView];
        
        [tmpArray addObject:imgView];
        [tmp2Array addObject:subView];
        
        [self.view insertSubview:imgView belowSubview:self.scrollView];
        
//        if (imgView.tag == 10) {
//            imgView.userInteractionEnabled = YES;
//            [imgView addSubview:_loginBtn];
//        }
    }];
    
    self.backgroundViews = [[tmpArray reverseObjectEnumerator] allObjects];
    self.scrollViewPages = [[tmp2Array reverseObjectEnumerator] allObjects];
}

- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((screenW - 80) * 0.5, screenH - 60, 80, 30)];
        _loginBtn.layer.cornerRadius = 5;
        _loginBtn.hidden = YES;
        _loginBtn.backgroundColor = [UIColor redColor];
        _loginBtn.titleLabel.font = setBoldFont(15);
        [_loginBtn setTitle:@"进入" forState:UIControlStateNormal];
        
        [_loginBtn addTarget:self action:@selector(getIntoButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        
//        [self.view bringSubviewToFront:_loginBtn];
        [self.view insertSubview:_loginBtn aboveSubview:self.scrollView];
    }
    return _loginBtn;
}

#pragma mark ========== 进入按钮的点击事件 ==========
- (void)getIntoButtonOnClick
{
    JYNavigationController *navCtl = [[JYNavigationController alloc] initWithRootViewController:[JYMainController alloc]];
    
    [self presentViewController:navCtl animated:NO completion:nil];
}


- (void)reloadPages
{
    self.scrollView.contentSize = CGSizeMake(self.items.count * screenW, 0);
    
    __block CGFloat x = 0;
    
    [[self scrollViewPages] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        obj.frame = CGRectOffset(obj.frame, x, 0);
        [self.scrollView addSubview:obj];
        
        x += obj.width;
    }];
    
    
    // fix ScrollView can not scrolling if it have only one page
    if (self.scrollView.contentSize.width == self.scrollView.width) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width + 1, self.scrollView.contentSize.height);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / screenW;
    CGFloat alpha = 1 - ((scrollView.contentOffset.x - index * screenW) / self.view.frame.size.width);
    
    if (self.backgroundViews.count > index) {
        UIView *v = [self.backgroundViews objectAtIndex:index];
        if (v) {
            [v setAlpha:alpha];
        }
    }
    
    self.currentPage = scrollView.contentOffset.x / (scrollView.contentSize.width / self.items.count);
    for (UIView *view in self.pageView.subviews) {
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = view.tag==self.currentPage ? 1.0 : 0.3;
    }
    if (index == 4) {
        self.loginBtn.hidden = NO;
    } else
    {
        self.loginBtn.hidden = YES;
    }
}
@end

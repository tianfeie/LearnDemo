//
//  TFRootTababarViewController.m
//  LearnDemo
//
//  Created by tianfei on 2018/7/23.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "HRRootTababarViewController.h"
#import "HRNavigationController.h"
#import "HomeViewController.h"
#import "HRTabbar.h"
@interface HRRootTababarViewController ()<HRTabBarDelegate>
@property (nonatomic, strong) HRTabbar *tabbar;
@end

@implementation HRRootTababarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
    [self addCustomTabbarControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    // 移除系统自带的 tabbar
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
    CGRect rects = CGRectMake(0, 0, HRSCREEN_WIDTH, 0.4);
    UIGraphicsBeginImageContext(rects.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [HRColorFromRGB(0xe0e0e0) CGColor]);
    CGContextFillRect(context, rects);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
}

#pragma mark - setTabbar
- (void)setup{
    _tabbarIndex = 0;
    HRTabbar *tabbar = [[HRTabbar alloc] init];
    tabbar.frame = self.tabBar.bounds;
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(tabbar.frame.origin.x, tabbar.frame.origin.y, tabbar.frame.size.width, tabbar.frame.size.height + HR_IPHONE_HOME_HEIGHT)];
    barView.backgroundColor = [UIColor whiteColor];
    [barView addSubview:tabbar];
    
    [self.tabBar addSubview:barView];
    tabbar.delegate = self;
    [self.tabBar addSubview:tabbar];
    _tabbar = tabbar;
}

#pragma mark - containViewController and tabbar DataSource
- (void)addCustomTabbarControllers
{
    NSArray *titles = @[@"首页",@"服务",@"发现",@"我的"];
    NSArray *images = @[@"tabbar_HomeN", @"tabbar_FlsN", @"tabbar_CardPayN", @"tabbar_PersonN"];
    NSArray *selectedImages = @[@"tabbar_HomeH", @"tabbar_FlsH", @"tabbar_CardPayH", @"tabbar_PersonH"];
    
    HomeViewController *home = [[HomeViewController alloc] init];       // 首页
    UIViewController *service = [[UIViewController alloc] init];    // 服务
    UIViewController *find = [[UIViewController alloc] init];       // 发现
    find.view.backgroundColor = [UIColor grayColor];
    UIViewController *mine = [[UIViewController alloc] init];       // 我的
    NSArray *viewControllers = @[home, service, find, mine];
    
    NSMutableArray *items = [@[] mutableCopy];
    for (int i = 0; i < viewControllers.count; i++) {
        
        UIViewController *childVc = viewControllers[i];
        childVc.title = titles[i];
        HRNavigationController *nav = [[HRNavigationController alloc] initWithRootViewController:childVc];
        [self addChildViewController:nav];
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:titles[i] image:[UIImage imageNamed:images[i]] selectedImage:[UIImage imageNamed:selectedImages[i]]];
        [items addObject:item];
    }
    self.tabbar.items = items;
    self.selectedIndex = _tabbarIndex;
    self.tabbar.selectedIndex = _tabbarIndex;
    
}

#pragma amrk - 设置选中项
- (void)setTabbarIndex:(NSInteger)tabbarIndex{
    _tabbarIndex = tabbarIndex;
    self.selectedIndex = _tabbarIndex;
    self.tabbar.selectedIndex = _tabbarIndex;
}

#pragma amrk - tabbar delegate
- (void)tabBar:(HRTabbar *)tabBar didSelectIndex:(NSUInteger)index{
    self.tabbarIndex = index;
}
@end

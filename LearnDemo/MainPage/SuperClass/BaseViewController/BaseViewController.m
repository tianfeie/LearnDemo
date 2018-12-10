//
//  BaseViewController.m
//  LearnDemo
//
//  Created by tianfei on 2018/7/24.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (nonatomic, strong)UIButton *backButton;

@property (nonatomic, strong)UIButton *rightButton;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HRBackgroundColor;
    
    // 隐藏导航栏后,需要自己去实现左边界右滑退出.
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self.view addSubview:self.hrNavigationBar];
    [self.hrNavigationBar addSubview:self.backButton];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view bringSubviewToFront:self.hrNavigationBar];
    
    // 隐藏导航栏后,需要自己去实现左边界右滑退出.
    if (self.navigationController.viewControllers.count > 1){
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    else{
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (_isPeresntVc && !_hideBackBtn) {
        [self.backButton setImage:[UIImage imageNamed:@"hr_cancel"] forState:UIControlStateNormal];
        self.backButton.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 2);
    }
}


- (HRNavigationBar *)hrNavigationBar
{
    if (_hrNavigationBar == nil) {
        _hrNavigationBar = [[HRNavigationBar alloc]initWithFrame:CGRectMake(0, 0, HRSCREEN_WIDTH, HR_NAVIGATIONBAR_HEIGHT)];
    }
    
    return _hrNavigationBar;
}

- (UIButton *)backButton
{
    if (_backButton == nil) {
        // 返回
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.frame = CGRectMake(0, iPhoneX?44:20, 75,44);
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 0);
        [_backButton setImage:[UIImage imageNamed:@"hr_back_white"] forState:UIControlStateNormal];
        
        //        self.hrNavigationBar.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    }
    return _backButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        // 返回
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.frame = CGRectMake(HRSCREEN_WIDTH - HRSCREEN_WIDTH/7, iPhoneX?44:20, HRSCREEN_WIDTH/7,44);
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _rightButton.imageEdgeInsets = UIEdgeInsetsMake(10, HRSCREEN_WIDTH/7 - 30, 10, 0);
        [_rightButton setImage:[UIImage imageNamed:@"hr_home02"] forState:UIControlStateNormal];
        [self.hrNavigationBar addSubview:_rightButton];
    }
    return _rightButton;
}

- (void)setNavTitle:(NSString *)navTitle{
    _navTitle = navTitle;
    self.hrNavigationBar.title = _navTitle;
}
- (void)backButtonClick:(UIButton *)button
{
    if (self.isPeresntVc) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightButtonClick:(UIButton *)sender
{
    if (self.isPeresntVc) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)setHideBackBtn:(BOOL)hideBackBtn
{
    _hideBackBtn = hideBackBtn;
    self.backButton.hidden = hideBackBtn;
}

- (void)setShowRightBtn:(BOOL)showRightBtn
{
    _showRightBtn = showRightBtn;
    self.rightButton.hidden = !showRightBtn;
}
@end

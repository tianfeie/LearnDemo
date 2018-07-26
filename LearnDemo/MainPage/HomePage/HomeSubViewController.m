//
//  HomeSubViewController.m
//  LearnDemo
//
//  Created by tianfei on 2018/7/24.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "HomeSubViewController.h"
#import "HRRootTababarViewController.h"
@interface HomeSubViewController ()

@end

@implementation HomeSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.view.bounds;
    [button addTarget:self action:@selector(doAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)doAction{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    
    UIViewController *rootVc = window.rootViewController;
    
    if ([rootVc isKindOfClass:[HRRootTababarViewController class]]) {
        HRRootTababarViewController *tabbarVC = (HRRootTababarViewController *)rootVc;
        tabbarVC.tabbarIndex = 3;
        
        if ([rootVc presentedViewController]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

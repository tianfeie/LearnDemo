//
//  HomeSubViewController.m
//  LearnDemo
//
//  Created by tianfei on 2018/7/24.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "HomeSubViewController.h"
#import "HRRootTababarViewController.h"
#import "HomeSubView.h"
@interface HomeSubViewController ()
@property (nonatomic, strong)HomeSubView *subView;
@end

@implementation HomeSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.view.bounds;
    [button addTarget:self action:@selector(doAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self initSubView];
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

- (void)initSubView{
    HomeSubView *subView = [[HomeSubView alloc] initWithFrame:CGRectMake(0, HR_NAVIGATIONBAR_HEIGHT + 10, HRSCREEN_WIDTH, HRSCREEN_WIDTH)];
    subView.backgroundColor = HRColorFromRGB(0xe0e0e0);
    [self.view addSubview:subView];
    subView.progress = 1.0;
    self.subView = subView;
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake((HRSCREEN_WIDTH - 200)*0.5, subView.bottom + 20, 200, 20)];
    [self.view addSubview:slider];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    [slider addTarget:self action:@selector(sliderProgress:) forControlEvents:UIControlEventValueChanged];
    slider.value = 1.0;
}
- (void)sliderProgress:(UISlider *)slider{
    self.subView.progress = slider.value;
}
@end

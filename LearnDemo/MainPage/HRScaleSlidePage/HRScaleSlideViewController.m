//
//  HRScaleSlideViewController.m
//  LearnDemo
//
//  Created by tianfei on 2018/7/13.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "HRScaleSlideViewController.h"
#import "ZDSliderPickerView.h"
@interface HRScaleSlideViewController ()
@property (nonatomic, strong)ZDSliderPickView *slideView;
@end

@implementation HRScaleSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"刻度尺";
    self.slideView = [ZDSliderPickView sliderProgressViewWithFrame:CGRectMake(0, HR_NAVIGATIONBAR_HEIGHT, HRSCREEN_WIDTH, 150) maxValue:70000 completion:^(NSString *value) {
        NSLog(@"%@",value);
    }];
    [self.view addSubview:self.slideView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

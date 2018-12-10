//
//  TFPayViewController.m
//  LearnDemo
//
//  Created by tianfei on 2018/7/12.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "TFPayViewController.h"
#import "HRPayTextField.h"

@interface TFPayViewController ()<HRPayTextFieldDelegate>
@property (nonatomic, strong) HRPayTextField *payTextField;
@end

@implementation TFPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.payTextField = [[HRPayTextField alloc] initWithFrame:CGRectMake(20, HR_NAVIGATIONBAR_HEIGHT +20, HRSCREEN_WIDTH - 40, 50)];
    self.payTextField.delegate = self;
    [self.view addSubview:self.payTextField];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"清除密码" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clearPassWord)
     forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor grayColor];
    button.frame = CGRectMake((HRSCREEN_WIDTH - 200)*0.5, self.self.payTextField.bottom + 40 , 200, 45);
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textHRPayFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"密码：%@",textField.text);
}
- (void)clearPassWord{
    [self.payTextField clearPassWord];
}
@end

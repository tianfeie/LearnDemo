//
//  HomeViewController.m
//  LearnDemo
//
//  Created by tianfei on 2018/7/24.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[@{@"title":@"自定义相机",@"ViewController":@"TFRootCameraViewController",@"modalType":@"push"},@{@"title":@"支付密码框",@"ViewController":@"TFPayViewController",@"modalType":@"push"},@{@"title":@"刻度尺",@"ViewController":@"HRScaleSlideViewController",@"modalType":@"push"},@{@"title":@"圆弧刻度盘",@"ViewController":@"HomeSubViewController",@"modalType":@"present"}];
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HR_NAVIGATIONBAR_HEIGHT,HRSCREEN_WIDTH,HRSCREEN_HEIGHT - HR_NAVIGATIONBAR_HEIGHT - HR_IPHONE_HOME_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.rowHeight = 44;
        _tableView.bounces = YES;
    }
    return _tableView;
}
#pragma mark -- TableViewDelegate TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellID"];
    }
    NSDictionary *dict = self.dataSource[row];
    cell.textLabel.text = dict[@"title"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataSource[indexPath.row];
    [self jumpVC:dict];
}

- (void)jumpVC:(NSDictionary *)param{
    
    UIViewController *vc = [[NSClassFromString(param[@"ViewController"]) alloc] init];
    NSString *modalType = param[@"modalType"];
    if ([modalType isEqualToString:@"push"]) {
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self presentViewController:vc animated:YES completion:nil];
    }
//
    
}
@end

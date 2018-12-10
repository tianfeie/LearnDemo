//
//  HRCircularLoanBillsDetailViewController.m
//  LearnDemo
//
//  Created by tianfei on 2018/8/31.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "HRCircularLoanBillsDetailViewController.h"
#import "HRCircularLoanBillsDetailModel.h"
#import "HRCircularLoanBillDetailCell.h"

@interface HRCircularLoanBillsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,HR_CircularLoan_BillDetailCell_Delegate>
@property(nonatomic, strong) NSArray *datasourceArray;
@property(nonatomic, strong) NSMutableArray *selectedMarray;//账单选择数组
@property(nonatomic, strong) NSMutableArray *spreadMarray;  //信息展开数组
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation HRCircularLoanBillsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self getDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HR_NAVIGATIONBAR_HEIGHT, HRSCREEN_WIDTH, HRSCREEN_HEIGHT - HR_NAVIGATIONBAR_HEIGHT - HR_IPHONE_HOME_HEIGHT) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.bounces = YES;
        _tableView.backgroundColor = HRBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
    }
    return _tableView;
}
- (NSMutableArray *)selectedMarray{
    if (!_selectedMarray) {
        _selectedMarray = [[NSMutableArray alloc] init];
    }
    return _selectedMarray;
}

- (NSMutableArray *)spreadMarray{
    if (!_spreadMarray) {
        _spreadMarray = [[NSMutableArray alloc] init];
    }
    return _spreadMarray;
}
#pragma mark -- tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datasourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.spreadMarray containsObject:indexPath]) {
        return 44.0 * 2 + 30 * 6 + 30 * 4;
    }else{
        return 44.0 * 2 + 30 * 6;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, HRSCREEN_WIDTH, 10)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    HRCircularLoanBillsDetailModel *model = self.datasourceArray[section];
    HRCircularLoanBillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HRCircularLoanBillDetailCell"];
    if (!cell) {
        cell = [[HRCircularLoanBillDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRCircularLoanBillDetailCell" withModel:model billType:HR_CircularLoanBillType_OverdueBill];
    }
    cell.model = model;
    if ([self.selectedMarray containsObject:model]) {
        cell.isSelected = YES;
    }else{
        cell.isSelected = NO;
    }
    if ([self.spreadMarray containsObject:indexPath]) {
        cell.isSpread = YES;
    }else{
        cell.isSpread = NO;
    }
    cell.indexPath = indexPath;
    [cell refreshUI];
    cell.delegate = self;
    return cell;
}

- (void)hr_circularLoan_billDetailCell:(HRCircularLoanBillDetailCell *)cell didSelectedBill:(BOOL)selected{
    HRCircularLoanBillsDetailModel *model = cell.model;
    if (selected) {
        if (![self.selectedMarray containsObject:model]) {
            [self.selectedMarray addObject:model];
        }
    }else{
        if ([self.selectedMarray containsObject:model]) {
            [self.selectedMarray removeObject:model];
        }
    }
    [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)hr_circularLoan_billDetailCell:(HRCircularLoanBillDetailCell *)cell didSpreadedBill:(BOOL)spreaded{
    NSIndexPath *indexPath = cell.indexPath;
    if (spreaded) {
        if (![self.spreadMarray containsObject:indexPath]) {
            [self.spreadMarray addObject:indexPath];
        }
    }else{
        if ([self.spreadMarray containsObject:indexPath]) {
            [self.spreadMarray removeObject:indexPath];
        }
    }
    [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)hr_circularLoan_billDetailCell:(HRCircularLoanBillDetailCell *)cell selectedType:(HR_CircularLoanBillDidSelectedType)selectedType{
    if (selectedType == HR_CircularLoanBillDidSelectedType_LoanDetail){
        
    }else if (selectedType == HR_CircularLoanBillDidSelectedType_Coupon){
        [cell.model setValue:@"2.34" forKey:@"couponCount"];
        [cell refreshUI];
    }
}
- (void)getDataSource{
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"circularOverduBills" ofType:@"json"];    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];    // 对数据进行JSON格式化并返回字典形式
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSArray *repayList = responseDict[@"repayList"];
    NSMutableArray *tempRepayList = [NSMutableArray arrayWithCapacity:repayList.count];
    for (NSDictionary *dict in repayList) {
        HRCircularLoanBillsDetailModel *detailModel = [[HRCircularLoanBillsDetailModel alloc] initWithDict:dict];
        [tempRepayList addObject:detailModel];
    }
    self.datasourceArray = tempRepayList;
}
@end

//
//  HRCircularLoanBillDetailCell.h
//  LearnDemo
//
//  Created by tianfei on 2018/8/31.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRCircularLoanBillsDetailModel.h"

/**
 账单类型
 */
typedef NS_ENUM(NSInteger, HR_CircularLoanBillType) {
    HR_CircularLoanBillType_CurrentBill = 1,//本期账单
    HR_CircularLoanBillType_OverdueBill,    //逾期账单
    HR_CircularLoanBillType_EarlyClearanceBill//提前结清账单
};

/**
 点击事件类型
 */
typedef NS_ENUM(NSInteger,HR_CircularLoanBillDidSelectedType) {
    HR_CircularLoanBillDidSelectedType_SeletedBill = 0, //选择账单
    HR_CircularLoanBillDidSelectedType_SpreadInfo,     //展开贷款信息
    HR_CircularLoanBillDidSelectedType_LoanDetail,      //贷款详情
    HR_CircularLoanBillDidSelectedType_Coupon           //优惠券
};

/**
 delegate
 */
@class HRCircularLoanBillDetailCell;
@protocol HR_CircularLoan_BillDetailCell_Delegate <NSObject>
- (void)hr_circularLoan_billDetailCell:(HRCircularLoanBillDetailCell *)cell didSelectedBill:(BOOL)selected;
- (void)hr_circularLoan_billDetailCell:(HRCircularLoanBillDetailCell *)cell didSpreadedBill:(BOOL)spreaded;
- (void)hr_circularLoan_billDetailCell:(HRCircularLoanBillDetailCell *)cell selectedType:(HR_CircularLoanBillDidSelectedType)selectedType;
@optional
@end
/**
 华融贷账单cell
 */
@interface HRCircularLoanBillDetailCell : UITableViewCell

/**
 代理
 */
@property (nonatomic, weak) id<HR_CircularLoan_BillDetailCell_Delegate> delegate;

/**
 账单类型
 */
@property (nonatomic, assign) HR_CircularLoanBillType billType;

/**
 数据源
 */
@property (nonatomic, strong) HRCircularLoanBillsDetailModel *model;

/**
 位置
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 优惠券value
 */
@property (nonatomic, copy) NSString *couponValue;

/**
 选择账单 默认YES
 */
@property (nonatomic, assign) BOOL isSelected;

/**
 信息展开，默认NO
 */
@property (nonatomic, assign) BOOL isSpread;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(HRCircularLoanBillsDetailModel *)model billType:(HR_CircularLoanBillType)billType;
- (void)refreshUI;
@end


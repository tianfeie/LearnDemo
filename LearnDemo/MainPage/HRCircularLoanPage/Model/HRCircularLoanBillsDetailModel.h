//
//  CLBillsModel.h
//  hrcfc
//
//  Created by tianfei on 2018/4/12.
//  Copyright © 2018年 Huarong Comsumer Finance. All rights reserved.
//

@interface HRCircularLoanBillsDetailModel : NSObject

@property (nonatomic, copy) NSString *loanInvoiceId;// 借据ID
@property (nonatomic, copy) NSString *perAmount;// 本期金额
@property (nonatomic, copy) NSString *overdueAmount;// 逾期金额
@property (nonatomic, copy) NSString *leftAmt;// 剩余金额
@property (nonatomic, copy) NSString *repayAmt;// 应还金额 
@property (nonatomic, copy) NSString *leftRepayPrincipal;// 剩余本金
@property (nonatomic, copy) NSString *loanAmount;// 借款金额
@property (nonatomic, copy) NSString *leftRepayInterest;// 剩余利息
@property (nonatomic, copy) NSString *preRepayDate;// 应还时间
@property (nonatomic, copy) NSString *currentNum;// 当前期数
@property (nonatomic, copy) NSString *repayNum;// 总期数
@property (nonatomic, copy) NSString *leftTermNum;// 剩余期数
@property (nonatomic, copy) NSString *leftRepayManagementFee;// 剩余管理费
@property (nonatomic, copy) NSString *leftRepayFee;// 剩余手续费
@property (nonatomic, copy) NSString *leftRepayOverdueFee;// 剩余罚息
@property (nonatomic, copy) NSString *advanceRepayPenalty;// 提前还款违约金
@property (nonatomic, copy) NSString *overdueDays;// 逾期天数
@property (nonatomic, copy) NSString *loanStartTime;// 借款开始时间
@property (nonatomic, copy) NSString *loanApplyId;// 支用申请ID
@property (nonatomic, copy) NSString *trialRepayAmount;// 还款总额
@property (nonatomic, copy) NSString *trialRepayPrincipalAmount;// 还款本金
@property (nonatomic, copy) NSString *trialRepaymentFee;// 提前还款手续费
@property (nonatomic, copy) NSString *trialInterest;// 利息
@property (nonatomic, copy) NSString *trialFee;// 服务费
@property (nonatomic, copy) NSString *trialRepayFeeAmount;// 费息总额
@property (nonatomic, copy) NSString *showRepays;//0:可以还款，1：不可以还款
@property (nonatomic, copy) NSString *maxBalance;//最大抵用金额 (利息)
@property (nonatomic, copy) NSString *maxRepayFee;//（最大抵扣额度（手续费）
@property (nonatomic, copy) NSString *repayMsg;//提示信息
@property (nonatomic, copy) NSString *couponCount;//自定义优惠金额（不在报文内）
- (instancetype)initWithDict:(NSDictionary *)dict;
@end





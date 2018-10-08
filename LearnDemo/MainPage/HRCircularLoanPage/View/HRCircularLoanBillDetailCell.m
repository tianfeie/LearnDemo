//
//  HRCircularLoanBillDetailCell.m
//  LearnDemo
//
//  Created by tianfei on 2018/8/31.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "HRCircularLoanBillDetailCell.h"
@interface HRCircularLoanBillDetailCell ()
@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, strong) UIView *headerContentView;
@property (nonatomic, strong) UIButton *headerSpreadBtn;
@property (nonatomic, strong) UIButton *headerSelectBtn;
@property (nonatomic, strong) UIView *headerLine;

@property (nonatomic, strong) UIView *middleContentView;
@property (nonatomic, strong) UIButton *middleSelectBtn;

@property (nonatomic, strong) UIControl *bottomContentView;

@end

@implementation HRCircularLoanBillDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(HRCircularLoanBillsDetailModel *)model billType:(HR_CircularLoanBillType)billType{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _model = model;
        _billType = billType;
        [self reloadData];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    NSArray *headerArray = self.dataSourceArray[0];
    NSArray *middleArray = self.dataSourceArray[1];
    
    [self.contentView addSubview:self.headerContentView];
    [self.contentView addSubview:self.middleContentView];
    [self.contentView addSubview:self.bottomContentView];
    CGFloat headerHeight = 44 + 30 * (headerArray.count - 1);
    [self.headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.right.and.left.equalTo(self.contentView);
        make.height.mas_equalTo(headerHeight);
    }];
    
    CGFloat middleHeight = 30 * middleArray.count;
    [self.middleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerContentView.mas_bottom);
        make.right.and.left.equalTo(self.contentView);
        make.height.mas_equalTo(middleHeight);
    }];
    [self.bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerContentView.mas_bottom);
        make.right.and.left.equalTo(self.contentView);
        make.height.mas_equalTo(44);
    }];
    
    //头部视图
    NSDictionary *headerDict = headerArray[0];
    NSString *headerTitle = headerDict[@"title"];
    [self.headerContentView addSubview:self.headerSelectBtn];
    [self.headerSelectBtn setTitle:headerTitle forState:UIControlStateNormal];
    [self.headerSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerContentView.mas_left).offset(10.0);
        make.width.mas_equalTo(99.0);
        make.height.mas_equalTo(44.0);
    }];
    
    UILabel *headerValueLb = [self createLabelFont:16 textColor:HRRedColor textAlignment:NSTextAlignmentRight];
    headerValueLb.tag = 1000;
    [self.headerContentView addSubview:headerValueLb];
    NSString *headerValue = headerDict[@"value"];
    headerValueLb.text = headerValue;
    
    [headerValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerContentView.mas_right).offset(-10.0);
        make.top.equalTo(self.headerContentView);
        make.height.mas_equalTo(44.0);
    }];
    
    //分割线
    UIView *headerLine = [[UIView alloc] init];
    headerLine.backgroundColor = HRSeparatorColor;
    [self.headerContentView addSubview:headerLine];
    [headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerSelectBtn.mas_bottom);
        make.right.equalTo(self.headerContentView).offset(10);
        make.left.equalTo(self.headerContentView).offset(-10);
        make.height.mas_equalTo(0.5);
    }];

    for (int i = 1; i< headerArray.count; i++) {
        NSDictionary *dict = headerArray[i];
        NSInteger tag = [dict[@"tag"] integerValue];
        NSInteger lastTag = tag - 1;
        UIView *lastView = [self.headerContentView viewWithTag:lastTag];
        UIColor *color = HRSubWordColor;
        UILabel *titleLb = [self createLabelFont:13 textColor:color textAlignment:NSTextAlignmentLeft];
        titleLb.tag = tag;
        [self.headerContentView addSubview:titleLb];
        UILabel *valueLb = [self createLabelFont:14 textColor:color textAlignment:NSTextAlignmentLeft];
        valueLb.tag = tag * 100;
        [self.headerContentView addSubview:valueLb];
        
        NSString *title = dict[@"title"];
        NSString *value = dict[@"value"];
        titleLb.text = title;
        valueLb.text = value;
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom);
            make.left.equalTo(self.headerContentView).offset(10);
            make.height.mas_equalTo(30);
        }];
        [valueLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb);
            make.right.equalTo(self.headerContentView).offset(-10);
            make.height.equalTo(titleLb);
        }];
    };
    
    //收缩按钮
    UIView *headerLastView = [self.headerContentView viewWithTag:10 + headerArray.count - 1];
    [self.headerContentView addSubview:self.headerSpreadBtn];
    [self.headerSpreadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerContentView.mas_right).offset(-10.0);
        make.centerY.equalTo(headerLastView.mas_centerY);
        make.width.height.mas_equalTo(20.0);
    }];
    //中部视图
    for (int i = 0; i< middleArray.count; i++) {
        NSDictionary *dict = middleArray[i];
        NSInteger tag = [dict[@"tag"] integerValue];

        UIColor *color = HRHintWordColor;
        UILabel *titleLb = [self createLabelFont:13 textColor:color textAlignment:NSTextAlignmentLeft];
        titleLb.tag = tag;
        [self.middleContentView addSubview:titleLb];
        UILabel *valueLb = [self createLabelFont:14 textColor:color textAlignment:NSTextAlignmentLeft];
        valueLb.tag = tag * 100;
        [self.middleContentView addSubview:valueLb];
        
        NSInteger lastTag = tag - 1;
        
        NSString *title = dict[@"title"];
        NSString *value = dict[@"value"];
        titleLb.text = title;
        valueLb.text = value;
        if (i == 0) {
            [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.middleContentView.mas_top);
                make.left.equalTo(self.middleContentView).offset(10);
                make.height.mas_equalTo(30);
            }];
        }else{
            UIView *lastView = [self.middleContentView viewWithTag:lastTag];
            [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom);
                make.left.equalTo(self.middleContentView).offset(10);
                make.height.mas_equalTo(30);
            }];
        }
        
        [valueLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb);
            make.right.equalTo(self.middleContentView).offset(-10);
            make.height.equalTo(titleLb);
        }];
    };
    [self.middleContentView addSubview:self.middleSelectBtn];
    [self.middleSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.middleContentView);
        make.left.and.right.equalTo(self.middleContentView);
        make.height.mas_equalTo(30);
    }];
    UIImageView *arrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hr_right_arrow_gray"]];
    [self.middleContentView addSubview:arrowImgView];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.middleSelectBtn.mas_centerY);
        make.right.equalTo(self.middleContentView.mas_right).offset(-10);
        make.width.and.height.mas_equalTo(15);
    }];
    
    //底部视图
    NSArray *bottomArray = self.dataSourceArray[2];
    for (int i = 0; i< bottomArray.count; i++) {
        NSDictionary *dict = bottomArray[i];
        NSInteger tag = [dict[@"tag"] integerValue];
        UILabel *titleLb = [self createLabelFont:14 textColor:HRMainWordColor textAlignment:NSTextAlignmentLeft];
        titleLb.tag = tag;
        [self.bottomContentView addSubview:titleLb];
        UILabel *valueLb = [self createLabelFont:16 textColor:HRRedColor textAlignment:NSTextAlignmentLeft];
        valueLb.tag = tag * 100;
        [self.bottomContentView addSubview:valueLb];
        
        NSString *title = dict[@"title"];
        NSString *value = dict[@"value"];
        titleLb.text = title;
        valueLb.text = value;
        if (i == 0) {
            [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.bottomContentView.mas_top);
                make.left.equalTo(self.bottomContentView).offset(10);
                make.height.mas_equalTo(44);
            }];
        }else{
            NSInteger lastTag = tag - 1;
            UIView *lastView = [self.middleContentView viewWithTag:lastTag];
            [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom);
                make.left.equalTo(self.bottomContentView).offset(10);
                make.height.mas_equalTo(44);
            }];
        }
        [valueLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb);
            make.right.equalTo(self.bottomContentView).offset(-10);
            make.height.mas_equalTo(44);
        }];
    };
}

- (void)refreshUI{
    [self reloadData];
    if (HRArrayIsEmpty(self.dataSourceArray)) {
        return;
    }
    NSArray *headerArray = self.dataSourceArray[0];
    NSArray *middleArray = self.dataSourceArray[1];
    //展开收缩
    self.middleContentView.hidden = !_isSpread;
    CGFloat bottomOffset = 0.00;
    if (self.isSpread) {
        bottomOffset = 30 * middleArray.count;
    }else{
        bottomOffset = 0;
    }
    
    [self.bottomContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerContentView.mas_bottom).offset(bottomOffset);
    }];
    //头部视图
    NSDictionary *headerDict = headerArray[0];
    //选择账单按钮
    NSString *headerTitle = headerDict[@"title"];
    [self.headerSelectBtn setTitle:headerTitle forState:UIControlStateNormal];
    //cell头部账单金额
    NSString *headerValue = headerDict[@"value"];
    UILabel *headerValueLb = [self.headerContentView viewWithTag:1000];
    headerValueLb.text = headerValue;
    
    for (int i = 1; i< headerArray.count; i++) {
        NSDictionary *dict = headerArray[i];
        NSInteger tag = [dict[@"tag"] integerValue];
        NSString *title = dict[@"title"];
        NSString *value = dict[@"value"];
        UILabel *titleLb = [self.headerContentView viewWithTag:tag];
        titleLb.text = title;
        UILabel *valueLb = [self.headerContentView viewWithTag:tag * 100];
        valueLb.text = value;
    };

    //中部视图
    for (int i = 0; i< middleArray.count; i++) {
        NSDictionary *dict = middleArray[i];
        NSInteger tag = [dict[@"tag"] integerValue];
        NSString *title = dict[@"title"];
        NSString *value = dict[@"value"];
        UILabel *titleLb = [self.middleContentView viewWithTag:tag];
        titleLb.text = title;
        UILabel *valueLb = [self.middleContentView viewWithTag:tag * 100];
        valueLb.text = value;
    };
    
    //底部视图
    NSArray *bottomArray = self.dataSourceArray[2];
    for (int i = 0; i< bottomArray.count; i++) {
        NSDictionary *dict = bottomArray[i];
        NSInteger tag = [dict[@"tag"] integerValue];
        NSString *title = dict[@"title"];
        NSString *value = dict[@"value"];
        UILabel *titleLb = [self.bottomContentView viewWithTag:tag];
        titleLb.text = title;
        UILabel *valueLb = [self.bottomContentView viewWithTag:tag * 100];
        valueLb.text = [NSString stringWithFormat:@"-%@",value];
    };
    
    self.headerSelectBtn.selected = self.isSelected;
    self.headerSpreadBtn.selected = _isSpread;
    
}
#pragma mark - getter
- (UIView *)headerContentView{
    if (!_headerContentView) {
        _headerContentView = [[UIView alloc] init];
    }
    return _headerContentView;
}

- (UIView *)middleContentView{
    if (!_middleContentView) {
        _middleContentView = [[UIView alloc] init];
    }
    return _middleContentView;
}

- (UIControl *)bottomContentView{
    if (!_bottomContentView) {
        _bottomContentView = [[UIControl alloc] init];
        [_bottomContentView.layer addSublayer:[self createLineLayer]];
        [_bottomContentView addTarget:self action:@selector(couponSelectedAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomContentView;
}

- (UIButton *)headerSelectBtn{
    if (!_headerSelectBtn) {
        _headerSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerSelectBtn.tag = 10;
        [_headerSelectBtn setTitleColor:HRMainWordColor forState:UIControlStateNormal];
        [_headerSelectBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        _headerSelectBtn.titleLabel.font = HRSysFontOfSize(14.0f);
        [_headerSelectBtn setImage:[UIImage imageNamed:@"check_cou"] forState:UIControlStateNormal];
        [_headerSelectBtn setImage:[UIImage imageNamed:@"checked_cou"] forState:UIControlStateSelected];
        _headerSelectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 97);
        _headerSelectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
        _headerSelectBtn.adjustsImageWhenHighlighted = NO;
        [_headerSelectBtn addTarget:self action:@selector(billSelectedAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerSelectBtn;
}

- (UIButton *)headerSpreadBtn{
    if (!_headerSpreadBtn) {
        _headerSpreadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerSpreadBtn setImage:[UIImage imageNamed:@"more_hk_up"] forState:UIControlStateNormal];
        [_headerSpreadBtn setImage:[UIImage imageNamed:@"more_hk_down"] forState:UIControlStateSelected];
        [_headerSpreadBtn addTarget:self action:@selector(spreadAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerSpreadBtn;
}

- (UIButton *)middleSelectBtn{
    if (!_middleSelectBtn) {
        _middleSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_middleSelectBtn setImage:[UIImage imageNamed:@"hr_more_repay"] forState:UIControlStateNormal];
        [_middleSelectBtn addTarget:self action:@selector(loanDetailAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _middleSelectBtn;
}

- (UILabel *)createLabelFont:(CGFloat)fontSize textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment{
    UILabel *label = [UILabel new];
    label.textAlignment = textAlignment;
    label.font = HRSysFontOfSize(fontSize);
    label.textColor = color;
    return label;
}
#pragma mark - setter
- (void)setModel:(HRCircularLoanBillsDetailModel *)model{
    _model = model;
}

- (void)setBillType:(HR_CircularLoanBillType)billType{
    _billType = billType;
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}

- (void)setCouponValue:(NSString *)couponValue{
    _couponValue = couponValue;
    if (HRArrayIsEmpty(self.dataSourceArray) && HRStringIsEmpty(couponValue)) {
        return;
    }
    NSArray *headerArray = self.dataSourceArray[0];
    NSArray *middleArray = self.dataSourceArray[1];
    UILabel *couponValueLb = [self.bottomContentView viewWithTag:(10 + headerArray.count + middleArray.count) * 100];
    couponValueLb.text = [NSString stringWithFormat:@"-%@",_couponValue];
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
}

- (void)setIsSpread:(BOOL)isSpread{
    _isSpread = isSpread;
    
}

#pragma mark - 画虚线
- (CAShapeLayer *)createLineLayer{
    //虚线
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:self.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线颜色为black
    [shapeLayer setStrokeColor:HRSeparatorColor.CGColor];
    // 设置虚线的高度
    shapeLayer.lineWidth = 0.5;
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 线的宽度 每条线的间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithFloat:5],[NSNumber numberWithFloat:2.0],nil]];
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 10, 0);       //0 ,0 初始点 x,y
    CGPathAddLineToPoint(path, NULL, HRSCREEN_WIDTH - 10,0);     //67终点x,y
    [shapeLayer setPath:path];
    CGPathRelease(path);
    return shapeLayer;
}

#pragma mark - 账单选择
- (void)billSelectedAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hr_circularLoan_billDetailCell:didSelectedBill:)]) {
        [self.delegate hr_circularLoan_billDetailCell:self didSelectedBill:!_isSelected];
    }
}

#pragma mark - 信息展开收缩
- (void)spreadAction{
    self.middleContentView.hidden = _isSpread;
    if (self.delegate && [self.delegate respondsToSelector:@selector(hr_circularLoan_billDetailCell:didSpreadedBill:)]) {
        [self.delegate hr_circularLoan_billDetailCell:self didSpreadedBill:!_isSpread];
    }
}

#pragma mark - 贷款详情
- (void)loanDetailAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hr_circularLoan_billDetailCell:selectedType:)]) {
        [self.delegate hr_circularLoan_billDetailCell:self selectedType:HR_CircularLoanBillDidSelectedType_LoanDetail];
    }
}

#pragma mark - 优惠券
- (void)couponSelectedAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hr_circularLoan_billDetailCell:selectedType:)]) {
        [self.delegate hr_circularLoan_billDetailCell:self selectedType:HR_CircularLoanBillDidSelectedType_Coupon];
    }
}

- (void)reloadData{
    switch (_billType) {
        case HR_CircularLoanBillType_CurrentBill:
            self.dataSourceArray = @[@[
                                         @{@"title":@"本期待还",
                                           @"value":@"",
                                           @"tag":@"10"},
                                         @{@"title":@"本金",
                                           @"value":@"",
                                           @"tag":@"11"},
                                         @{@"title":@"利息",
                                           @"value":@"",
                                           @"tag":@"12"},
                                         @{@"title":@"分期手续费",
                                           @"value":@"",
                                           @"tag":@"13"},
                                         @{@"title":@"平台服务费",
                                           @"value":@"",
                                           @"tag":@"14"},
                                         @{@"title":@"贷款信息",
                                           @"value":@"",
                                           @"tag":@"15"}],
                                     @[
                                         @{@"title":@"贷款金额",
                                           @"value":@"",
                                           @"tag":@"16"},
                                         @{@"title":@"还款期数",
                                           @"value":@"",
                                           @"tag":@"17"},
                                         @{@"title":@"申请日期",
                                           @"value":@"",
                                           @"tag":@"18"},
                                         @{@"title":@"贷款详情",
                                           @"value":@"",
                                           @"tag":@"19"}],
                                     @[
                                         @{@"title":@"优惠券",
                                           @"value":@"-0.00",
                                           @"tag":@"20"}]];
            break;
        case HR_CircularLoanBillType_OverdueBill:
            self.dataSourceArray = @[@[
                                         @{@"title":@"逾期待还",
                                           @"value":[NSString stringWithFormat:@"%.2f",[[NSString safetyString:self.model.repayAmt] floatValue]],
                                           @"tag":@"10"},
                                         @{@"title":@"本金",
                                           @"value":[NSString stringWithFormat:@"%.2f",[[NSString safetyString:self.model.trialRepayPrincipalAmount] floatValue]],
                                           @"tag":@"11"},
                                         @{@"title":@"利息",
                                           @"value":[NSString stringWithFormat:@"%.2f",[[NSString safetyString:self.model.trialInterest] floatValue]],
                                           @"tag":@"12"},
                                         @{@"title":@"分期手续费",
                                           @"value":[NSString stringWithFormat:@"%.2f",self.model.leftRepayFee.floatValue],
                                           @"tag":@"13"},
                                         @{@"title":@"平台服务费",
                                           @"value":[NSString stringWithFormat:@"%.2f",[[NSString safetyString:self.model.trialFee] floatValue]],
                                           @"tag":@"14"},
                                         @{@"title":@"逾期违约金",
                                           @"value":[NSString stringWithFormat:@"%.2f",[[NSString safetyString:self.model.leftRepayOverdueFee] floatValue]],
                                           @"tag":@"15"},
                                         @{@"title":@"贷款信息",
                                           @"value":@"",
                                           @"tag":@"16"}],
                                     @[
                                         @{@"title":@"贷款金额",
                                           @"value":[NSString stringWithFormat:@"%.2f",[[NSString safetyString:self.model.loanAmount] floatValue]],
                                           @"tag":@"17"},
                                         @{@"title":@"逾期天数",
                                           @"value":[NSString stringWithFormat:@"%@天",[NSString safetyString:self.model.overdueDays]],
                                           @"tag":@"18"},
                                         @{@"title":@"申请日期",
                                           @"value":[NSString safetyString:self.model.loanStartTime],
                                           @"tag":@"19"},
                                         @{@"title":@"贷款详情",
                                           @"value":@"",
                                           @"tag":@"20"}],
                                     @[
                                         @{@"title":@"优惠券",
                                           @"value":[NSString stringWithFormat:@"%.2f",(self.model.couponCount?self.model.couponCount:@"").floatValue],
                                           @"tag":@"21"}]];
            break;
        case HR_CircularLoanBillType_EarlyClearanceBill:
            self.dataSourceArray = @[@[
                                         @{@"title":@"提前结清",
                                           @"value":@"",
                                           @"tag":@"10"},
                                         @{@"title":@"本金",
                                           @"value":@"",
                                           @"tag":@"11"},
                                         @{@"title":@"利息",
                                           @"value":@"",
                                           @"tag":@"12"},
                                         @{@"title":@"分期手续费",
                                           @"value":@"",
                                           @"tag":@"13"},
                                         @{@"title":@"平台服务费",
                                           @"value":@"",
                                           @"tag":@"14"},
                                         @{@"title":@"提前结清违约金",
                                           @"value":@"",
                                           @"tag":@"15"},
                                         @{@"title":@"贷款信息",
                                           @"value":@"",
                                           @"tag":@"16"}],
                                     @[
                                         @{@"title":@"贷款金额",
                                           @"value":@"",
                                           @"tag":@"17"},
                                         @{@"title":@"还款期数",
                                           @"value":@"",
                                           @"tag":@"18"},
                                         @{@"title":@"申请日期",
                                           @"value":@"",
                                           @"tag":@"19"},
                                         @{@"title":@"贷款详情",
                                           @"value":@"",
                                           @"tag":@"20"}],
                                     @[
                                         @{@"title":@"优惠券",
                                           @"value":@"-0.00",
                                           @"tag":@"21"}]];
            break;
        default:
            break;
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end

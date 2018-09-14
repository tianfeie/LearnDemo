//
//  HRCircularLoanBillDetailCell.m
//  LearnDemo
//
//  Created by tianfei on 2018/8/31.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "HRCircularLoanBillDetailCell.h"
@interface HRCircularLoanBillDetailCell ()
@property (nonatomic, strong) UIView *headerContentView;
@property (nonatomic, strong) UILabel *headerTitle0Lb;
@property (nonatomic, strong) UILabel *headerTitle1Lb;
@property (nonatomic, strong) UILabel *headerTitle2Lb;
@property (nonatomic, strong) UILabel *headerTitle3Lb;
@property (nonatomic, strong) UILabel *headerTitle4Lb;
@property (nonatomic, strong) UILabel *headerTitle5Lb;

@property (nonatomic, strong) UILabel *headerValue0Lb;
@property (nonatomic, strong) UILabel *headerValue1Lb;
@property (nonatomic, strong) UILabel *headerValue2Lb;
@property (nonatomic, strong) UILabel *headerValue3Lb;
@property (nonatomic, strong) UIButton *headerSpreadBtn;

@property (nonatomic, strong) UIView *headerLine;

@property (nonatomic, strong) UIView *middleContentView;
@property (nonatomic, strong) UIView *bottomContentView;

@end

@implementation HRCircularLoanBillDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier circularLoanBillType:(HR_CircularLoanBillType)billType{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _billType = billType;
        [self createUI];
    }
    return self;
}
- (void)createUI{
    self.headerTitle0Lb = [self createLabelFont:14.0 textColor:HRMainWordColor textAlignment:NSTextAlignmentLeft];
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

- (UIView *)bottomContentView{
    if (!_bottomContentView) {
        _bottomContentView = [[UIView alloc] init];
        [_bottomContentView.layer addSublayer:[self createLineLayer]];
    }
    return _bottomContentView;
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
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
}

- (void)setIsSpread:(BOOL)isSpread{
    _isSpread = isSpread;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
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
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithFloat:2],[NSNumber numberWithFloat:2.0],nil]];
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 10, 0);       //0 ,0 初始点 x,y
    CGPathAddLineToPoint(path, NULL, HRSCREEN_WIDTH - 20,0);     //67终点x,y
    [shapeLayer setPath:path];
    CGPathRelease(path);
    return shapeLayer;
}







- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end

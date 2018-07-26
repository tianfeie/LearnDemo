//
//  ZDSliderPickView.m
//  ZDSliderPickView
//
//  Created by songzidong on 2018/7/13.
//  Copyright © 2018年 SZD. All rights reserved.
//

// 主屏宽
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

// 每格间隔距离
#define SpaceDistance 5.0f

// 每格间隔代表的数值
#define SpaceValue 1000.0f

#import "ZDSliderPickerView.h"

@interface SZDProgressScrollView : UIScrollView

/**
 最大可选数值
 */
@property(nonatomic, assign)CGFloat maxValue;

@end


@interface ZDSliderPickView ()<UIScrollViewDelegate,UITextFieldDelegate>
/**
 滑动view
 */
@property(nonatomic, strong)SZDProgressScrollView *scrollView;

/**
 输入框
 */
@property(nonatomic, strong)UITextField          *pointerTextField;

/**
 指针
 */
@property(nonatomic, strong)CAShapeLayer         *pointerLine;

/**
 最大值
 */
@property(nonatomic, assign)CGFloat maxValue;

/**
 结果字符串
 */
@property(nonatomic, copy)  NSString *pointerText;

/**
 是否输入状态
 */
@property(nonatomic, assign)BOOL                 isInput;

/**
 回传选择值
 */
@property(nonatomic, copy)  void (^Completion)(NSString *);
@end

@implementation ZDSliderPickView

+ (instancetype)sliderProgressViewWithFrame:(CGRect)rect
                                   maxValue:(CGFloat)maxValue
                                 completion:(void (^)(NSString *))completion
{
    ZDSliderPickView *slider = [[ZDSliderPickView alloc] initWithFrame:rect];
    [slider setMaxValue:maxValue];
    [slider setCompletion:completion];
    return slider;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.scrollView];
        [self addSubview:self.pointerTextField];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self.layer addSublayer:self.pointerLine];
}

- (CAShapeLayer *)pointerLine
{
    if (!_pointerLine) {
        _pointerLine = [CAShapeLayer layer];
        
        CGRect rect = CGRectMake(0, - (self.frame.size.height - 60), 1.2, 40);
        
        [_pointerLine setBounds:rect];
        
        [_pointerLine setPosition:CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect))];
        
        [_pointerLine setFillColor:[UIColor clearColor].CGColor];
        
        //  设置虚线颜色为
        [_pointerLine setStrokeColor:[UIColor redColor].CGColor];
        
        //  设置虚线宽度
        [_pointerLine setLineWidth:CGRectGetHeight(rect)];
        
        //  设置路径
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, CGRectGetWidth(self.frame) / 2.0f - 0.6, 0);
        
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame) / 2.0f + 0.6, 0);
        
        [_pointerLine setPath:path];
        
        CGPathRelease(path);
        
    }
    return _pointerLine;
}

- (SZDProgressScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[SZDProgressScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(UITextField *)pointerTextField
{
    if (!_pointerTextField) {
        _pointerTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 10, self.frame.size.width - 100, 30)];
        [_pointerTextField setTextColor:[UIColor redColor]];
        [_pointerTextField setPlaceholder:@"请选择或输入贷款金额"];
        _pointerTextField.delegate = self;
        [_pointerTextField setTextAlignment:NSTextAlignmentCenter];
        [_pointerTextField setFont:[UIFont systemFontOfSize:14.0f]];
        [_pointerTextField setKeyboardType:UIKeyboardTypeNumberPad];
        [_pointerTextField addTarget:self action:@selector(textFieldContentDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _pointerTextField;
}

- (void)setMaxValue:(CGFloat)maxValue
{
    _maxValue = maxValue;
    [self.scrollView setContentSize:CGSizeMake((maxValue / SpaceValue) * SpaceDistance + SCREEN_WIDTH, self.scrollView.frame.size.height)];
    [self.scrollView setMaxValue:maxValue];
}

- (void)setDefaultPointerValue:(CGFloat)defaultPointerValue
{
    _pointerText = [NSString stringWithFormat:@"%.0f",defaultPointerValue];
    [_scrollView setContentOffset:CGPointMake(defaultPointerValue / SpaceValue *SpaceDistance, 0)];
    [_pointerTextField setText:_pointerText];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_isInput)
    {
        if (scrollView.contentOffset.x >=0 && scrollView.contentOffset.x <= _maxValue / SpaceValue * SpaceDistance){
            _pointerText = [NSString stringWithFormat:@"%.0f",floorf(scrollView.contentOffset.x) / SpaceDistance * SpaceValue];
        }else if (scrollView.contentOffset.x < 0){
            _pointerText = @"0";
        }else if (scrollView.contentOffset.x > _maxValue / SpaceValue * SpaceDistance){
            _pointerText = [NSString stringWithFormat:@"%.0f",_maxValue];
        }
        [_pointerTextField setText:_pointerText];
        if (self.Completion){
            self.Completion(_pointerText);
        }
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_pointerTextField endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _isInput = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _isInput = NO;
}

- (void)textFieldContentDidChange:(UITextField *)textField
{
    if ([textField.text floatValue] > _maxValue) {
        textField.text = [NSString stringWithFormat:@"%.0f",_maxValue];
    }
    CGFloat value = [textField.text floatValue];
    [UIView animateWithDuration:0.2 animations:^{
        
        [_scrollView setContentOffset:CGPointMake(floorf(value) / SpaceValue * SpaceDistance, 0)];
    }];
    _pointerText = [NSString stringWithFormat:@"%.0f",floorf(value)];
    if (self.Completion){
        self.Completion(_pointerText);
    }
}
@end



@interface SZDProgressScrollView ()
@property(nonatomic, strong)CAShapeLayer *firstLayer;
@property(nonatomic, strong)CAShapeLayer *secondLayer;
@property(nonatomic, strong)CAShapeLayer *thirdLayer;
@property(nonatomic, strong)CAShapeLayer *bottomLineLayer;
@end
@implementation SZDProgressScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}
- (void)createValueLabel
{
    for (int i = 0; i < _maxValue / (SpaceValue*10) + 1; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) / 2.0f - 30) + i * (10 * SpaceDistance), self.frame.size.height - 20, 60, 20)];
        [label setTextColor:[UIColor lightGrayColor]];
        NSString *labelText = [NSString stringWithFormat:@"%dw",i];
        [label setText:labelText];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:label];
    }
}
- (CAShapeLayer *)firstLayer
{
    if (!_firstLayer) {
        
        _firstLayer = [CAShapeLayer layer];
        
        CGRect rect = CGRectMake(0, - (self.frame.size.height - 30), self.contentSize.width,10);
        
        [_firstLayer setBounds:rect];
        
        [_firstLayer setPosition:CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect))];
        
        [_firstLayer setFillColor:[UIColor clearColor].CGColor];
        
        //  设置虚线颜色为
        
        [_firstLayer setStrokeColor:[UIColor lightGrayColor].CGColor];
        
        //  设置虚线宽度
        
        [_firstLayer setLineWidth:CGRectGetHeight(rect)];
        
        [_firstLayer setLineJoin:kCALineJoinRound];
        
        //  设置线宽，线间距
        
        [_firstLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:SpaceDistance - 1], nil]];
        
        //  设置路径
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, CGRectGetWidth(self.frame) / 2.0, 0);
        
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect) - CGRectGetWidth(self.frame) / 2.0 + 1, 0);
        
        [_firstLayer setPath:path];
        
        CGPathRelease(path);
    }
    return _firstLayer;
}

- (CAShapeLayer *)secondLayer
{
    if (!_secondLayer) {
        
        _secondLayer = [CAShapeLayer layer];
        
        CGRect rect = CGRectMake(0, - (self.frame.size.height - 35), self.contentSize.width, 5);
        
        [_secondLayer setBounds:rect];
        
        [_secondLayer setPosition:CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect))];
        
        [_secondLayer setFillColor:[UIColor clearColor].CGColor];
        
        //  设置虚线颜色为
        
        [_secondLayer setStrokeColor:[UIColor lightGrayColor].CGColor];
        
        //  设置虚线宽度
        
        [_secondLayer setLineWidth:CGRectGetHeight(rect)];
        
        [_secondLayer setLineJoin:kCALineJoinRound];
        
        //  设置线宽，线间距
        
        [_secondLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:(SpaceDistance - 0.1) * 5], nil]];
        
        //  设置路径
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, CGRectGetWidth(self.frame) / 2.0, 0);
        
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect) - CGRectGetWidth(self.frame) / 2.0 + 1, 0);
        
        [_secondLayer setPath:path];
        
        CGPathRelease(path);
    }
    return _secondLayer;
}

- (CAShapeLayer *)thirdLayer
{
    if (!_thirdLayer) {
        
        _thirdLayer = [CAShapeLayer layer];
        
        CGRect rect = CGRectMake(0, - (self.frame.size.height - 40), self.contentSize.width, 5);
        
        [_thirdLayer setBounds:rect];
        
        [_thirdLayer setPosition:CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect))];
        
        [_thirdLayer setFillColor:[UIColor clearColor].CGColor];
        
        //  设置虚线颜色为
        
        [_thirdLayer setStrokeColor:[UIColor lightGrayColor].CGColor];
        
        //  设置虚线宽度
        
        [_thirdLayer setLineWidth:CGRectGetHeight(rect)];
        
        [_thirdLayer setLineJoin:kCALineJoinRound];
        
        //  设置线宽，线间距
        
        [_thirdLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:(SpaceDistance - 0.1) * 10], nil]];
        
        //  设置路径
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, CGRectGetWidth(self.frame) / 2.0, 0);
        
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect) - CGRectGetWidth(self.frame) / 2.0 + 1, 0);
        
        [_thirdLayer setPath:path];
        
        CGPathRelease(path);
    }
    return _thirdLayer;
}

- (CAShapeLayer *)bottomLineLayer
{
    if (!_bottomLineLayer) {
        _bottomLineLayer = [CAShapeLayer layer];
        
        CGRect rect = CGRectMake(0, -(self.frame.size.height - 20), self.contentSize.width, 1);
        
        [_bottomLineLayer setBounds:rect];
        
        [_bottomLineLayer setPosition:CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect))];
        
        [_bottomLineLayer setFillColor:[UIColor clearColor].CGColor];
        
        //  设置虚线颜色为
        [_bottomLineLayer setStrokeColor:[UIColor lightGrayColor].CGColor];
        
        //  设置虚线宽度
        [_bottomLineLayer setLineWidth:CGRectGetHeight(rect)];
        
        //  设置路径
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 0, 0);
        
        CGPathAddLineToPoint(path, NULL, self.contentSize.width, 0);
        
        [_bottomLineLayer setPath:path];
        
        CGPathRelease(path);
        
    }
    return _bottomLineLayer;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self.layer addSublayer:self.firstLayer];
    [self.layer addSublayer:self.secondLayer];
    [self.layer addSublayer:self.thirdLayer];
    [self.layer addSublayer:self.bottomLineLayer];
}

- (void)setMaxValue:(CGFloat)maxValue
{
    _maxValue = maxValue;
    [self createValueLabel];
}
@end


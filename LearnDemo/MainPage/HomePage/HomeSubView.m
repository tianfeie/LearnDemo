//
//  HomeSubView.m
//  LearnDemo
//
//  Created by tianfei on 2018/7/26.
//  Copyright © 2018年 huarong. All rights reserved.
//
#define BackgroundColor [UIColor lightGrayColor]
#define ProgressColor [UIColor redColor]
#import "HomeSubView.h"
#import <QuartzCore/QuartzCore.h>
@interface HomeSubView ()
@property (nonatomic, strong) CAShapeLayer *baseProgressLayer;
@property (nonatomic, strong) CAShapeLayer *longProgressLayer;
@property (nonatomic, strong) CAShapeLayer *shortProgressLayer;

@property (nonatomic, strong) CAShapeLayer *smallProgressLayer0;
@property (nonatomic, strong) CAShapeLayer *smallProgressLayer1;
@end
@implementation HomeSubView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 3.0;
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.baseProgressLayer addAnimation:animation forKey:@"strokeEnd"];
    [self.longProgressLayer addAnimation:animation forKey:@"strokeEnd"];
    [self.shortProgressLayer addAnimation:animation forKey:@"strokeEnd"];
}
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
    CGFloat endAngle = M_PI + M_PI*self.progress*2;
    if (progress>=0.5) {
        endAngle = 2*M_PI;
    }
    UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2.0f, self.height/2.0f) radius:(self.width - 20)/2.0 startAngle:M_PI endAngle:endAngle clockwise:YES];
    self.baseProgressLayer.path = [tickPath CGPath];
    
    UIBezierPath *longPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2.0f, self.height/2.0f) radius:(self.width - 30)/2.0 startAngle:M_PI endAngle:endAngle clockwise:YES];
    self.longProgressLayer.path = [longPath CGPath];
    UIBezierPath *shortPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2.0f, self.height/2.0f) radius:(self.width - 40)/2.0 startAngle:M_PI endAngle:endAngle clockwise:YES];
    self.shortProgressLayer.path = [shortPath CGPath];
    
    CGFloat smallEndAngle0 = M_PI;
    if (progress>=0.5 && progress<0.75) {
        smallEndAngle0 = M_PI + M_PI*(self.progress - 0.5)*4;
        
    }else if (progress>=0.75){
        smallEndAngle0 = M_PI *2;
    }
    UIBezierPath *smallPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/4.0f + 10, self.height/2.0f) radius:(self.width - 40)/4.0 startAngle:M_PI endAngle:smallEndAngle0 clockwise:YES];
    self.smallProgressLayer0.path = [smallPath CGPath];
    CGFloat smallEndAngle1 = M_PI;
    if (progress>=0.75 && progress<1) {
        smallEndAngle1 = M_PI*(1- self.progress)*4;
        
    }else if (progress == 1){
        smallEndAngle1 = 2*M_PI;
        
    }
    UIBezierPath *smallPath1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width*3/4.0f - 10, self.height/2.0f) radius:(self.width - 40)/4.0 startAngle:M_PI endAngle:smallEndAngle1 clockwise:NO];
    self.smallProgressLayer1.path = [smallPath1 CGPath];
    
    if (progress ==1) {
       [self animition];
    }else{
        [self.layer removeAnimationForKey:@"rotationAni"];
    }
    
}
- (void)initSubView{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.width/2.0;
    //base
    UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2.0f, self.height/2.0f) radius:(self.width - 20)/2.0 startAngle:M_PI endAngle:0 clockwise:YES];
    CAShapeLayer *perLayer = [CAShapeLayer layer];
    perLayer.fillColor = [UIColor clearColor].CGColor;
    perLayer.lineCap = kCALineCapButt;
    perLayer.lineJoin = kCALineJoinRound;
    perLayer.strokeColor = BackgroundColor.CGColor;
    perLayer.opacity = 1;
    perLayer.lineWidth = 10;
    perLayer.lineDashPattern = @[@2,@(M_PI*self.width/(2.0 * 40) - 2.83)];
    perLayer.path = [tickPath CGPath];
    perLayer.strokeEnd = 1.0f;
    
    CAShapeLayer *baseProgressLayer = [CAShapeLayer layer];
    baseProgressLayer.fillColor = [UIColor clearColor].CGColor;
    baseProgressLayer.lineCap = kCALineCapButt;
    baseProgressLayer.lineJoin = kCALineJoinRound;
    baseProgressLayer.strokeColor = ProgressColor.CGColor;
    baseProgressLayer.opacity = 1;
    baseProgressLayer.lineWidth = 10;
    baseProgressLayer.lineDashPattern = @[@2,@(M_PI*self.width/(2.0 * 40) - 2.83)];
    baseProgressLayer.strokeEnd = 1.0f;
    self.baseProgressLayer = baseProgressLayer;
    
    //long
    UIBezierPath *longPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2.0f, self.height/2.0) radius:(self.width - 30)/2.0 startAngle:M_PI endAngle:0 clockwise:YES];
    CAShapeLayer *longLayer = [CAShapeLayer layer];
    longLayer.fillColor = [UIColor clearColor].CGColor;
    longLayer.strokeColor = BackgroundColor.CGColor;
    longLayer.opacity = 1;
    longLayer.lineWidth = 20;
    longLayer.lineDashPattern = @[@2,@(M_PI*self.width/(2.0 * 4) - 14.3)];
    longLayer.path = [longPath CGPath];
    longLayer.strokeEnd = 1.0f;
    [longPath closePath];
    
    CAShapeLayer *longProgressLayer = [CAShapeLayer layer];
    longProgressLayer.fillColor = [UIColor clearColor].CGColor;
    longProgressLayer.strokeColor = ProgressColor.CGColor;
    longProgressLayer.opacity = 1;
    longProgressLayer.lineWidth = 20;
    longProgressLayer.lineDashPattern = @[@2,@(M_PI*self.width/(2.0 * 4) - 14.3)];
    longLayer.strokeEnd = 1.0f;
    self.longProgressLayer = longProgressLayer;
    
    //short
    UIBezierPath *shortPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2.0f, self.height/2.0f) radius:(self.width - 40)/2.0 startAngle:M_PI endAngle:0 clockwise:YES];
    CAShapeLayer *shortLayer = [CAShapeLayer layer];
    shortLayer.fillColor = [UIColor clearColor].CGColor;
    shortLayer.strokeColor = BackgroundColor.CGColor;
    shortLayer.opacity = 1;
    shortLayer.lineCap = kCALineCapRound;
    shortLayer.lineWidth = 1;
    shortLayer.lineDashPattern = @[@1,@(M_PI*self.width/(2.0 * 80) - 0.75)];
    shortLayer.path = [shortPath CGPath];
    shortLayer.strokeEnd = 1.0f;
    
    CAShapeLayer *shortProgressLayer = [CAShapeLayer layer];
    shortProgressLayer.fillColor = [UIColor clearColor].CGColor;
    shortProgressLayer.strokeColor = ProgressColor.CGColor;
    shortProgressLayer.opacity = 1;
    shortProgressLayer.lineCap = kCALineCapRound;
    shortProgressLayer.lineWidth = 1;
    shortProgressLayer.lineDashPattern = @[@1,@(M_PI*self.width/(2.0 * 80) - 0.75)];
    shortProgressLayer.strokeEnd = 1.0f;
    self.shortProgressLayer = shortProgressLayer;
    
    
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors = @[(__bridge id)[UIColor blueColor].CGColor,(__bridge id)[UIColor redColor].CGColor];
    //位置x,y    自己根据需求进行设置   使其从不同位置进行渐变
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, self.height/2.0, self.width, 5);
    
    
    
    CAShapeLayer *smallLayer = [CAShapeLayer layer];
    smallLayer.fillColor = [UIColor clearColor].CGColor;
    smallLayer.strokeColor = BackgroundColor.CGColor;
    smallLayer.opacity = 2;
    smallLayer.lineCap = kCALineCapRound;
    smallLayer.lineWidth = 2;
    smallLayer.lineDashPattern = @[@1,@(M_PI*self.width/(2.0 * 80) - 0.75)];
//    smallLayer.path = [smallPath CGPath];
    smallLayer.strokeEnd = 1.0f;
    self.smallProgressLayer0 = smallLayer;
    
    CAShapeLayer *smallLayer1 = [CAShapeLayer layer];
    smallLayer1.fillColor = [UIColor clearColor].CGColor;
    smallLayer1.strokeColor = BackgroundColor.CGColor;
    smallLayer1.opacity = 2;
    smallLayer1.lineCap = kCALineCapRound;
    smallLayer1.lineWidth = 2;
    smallLayer1.lineDashPattern = @[@1,@(M_PI*self.width/(2.0 * 80) - 0.75)];
//    smallLayer1.path = [smallPath1 CGPath];
    smallLayer1.strokeEnd = 1.0f;
    self.smallProgressLayer1 = smallLayer1;
    
    [self.layer addSublayer:shortLayer];
    [self.layer addSublayer:longLayer];
    [self.layer addSublayer:perLayer];
    
    [self.layer addSublayer:baseProgressLayer];
    [self.layer addSublayer:longProgressLayer];
    [self.layer addSublayer:shortProgressLayer];
    [self.layer addSublayer:smallLayer];
    [self.layer addSublayer:smallLayer1];
//    [self.layer addSublayer:gradientLayer];
}


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    /*画圆*/
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context,0.5,0.25,0.5,0.5);//画笔线的颜色
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 1.0);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, self.width*3/4.0 - 10, self.height/2, 15, 0, 2*M_PI, 0); //添加一个圆
    //画边框圆
//    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    //画实心圆
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddArc(context, self.width/4.0 + 10, self.height/2, 15, 0, 2*M_PI, 0);
    
    CGContextDrawPath(context, kCGPathFill);
    //虚线半圆
    CGFloat endAngle = M_PI*self.progress*2;
    if (self.progress>=0.5) {
        endAngle = M_PI;
    }
    
    
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextSetLineWidth(context, 20);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextBeginPath(context);
    
    CGFloat lengths[] = {2,(M_PI*self.width/(2.0 * 4) - 14.3)};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextAddArc(context, self.width/2.0, self.height/2.0, (self.width - 30)/2.0 , 0, endAngle, 0);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, 10);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextBeginPath(context);
    
    CGFloat baseLengths[] = {2,(M_PI*self.width/(2.0 * 40) - 2.83)};
    CGContextSetLineDash(context, 0, baseLengths, 2);
    CGContextAddArc(context, self.width/2.0, self.height/2.0, (self.width - 20)/2.0 , 0, endAngle, 0);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextBeginPath(context);
    CGFloat shortLengths[] = {2,(M_PI*self.width/(2.0 * 80) - 0.75)};
    CGContextSetLineDash(context, 0, shortLengths, 2);
    CGContextAddArc(context, self.width/2.0, self.height/2.0, (self.width - 40)/2.0 , 0, endAngle, 0);
    CGContextStrokePath(context);
    
}

- (void)animition{
    CABasicAnimation * ani = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ani.duration = 5.0;
    ani.fromValue = [NSNumber numberWithFloat:0.0f];
    ani.toValue = [NSNumber numberWithFloat:2 * M_PI];
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.repeatCount = MAXFLOAT;
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.layer addAnimation:ani forKey:@"rotationAni"];
}
@end

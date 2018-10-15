//
//  HRNavigationBar.m
//  LearnDemo
//
//  Created by tianfei on 2018/10/15.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "HRNavigationBar.h"
#define HR_NAVIGATION_TITLEVIEW_TAG     (123456)
@interface HRNavigationBar ()
@property (nonatomic, strong)UILabel    *titleLabel;
@property (nonatomic, strong)UIView     *middleView;

@property (nonatomic, strong)UIView     *bgView;
@property (nonatomic, strong)UINavigationItem *item;
@end
@implementation HRNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        
        [self setShadowImage:[[UIImage alloc] init]];
        
        self.barTintColor = [UIColor whiteColor];//HRNavBarColor;
        self.translucent = NO;
        [self addSubview:self.middleView];
        [self insertSubview:self.bgView belowSubview:self.middleView];
        [self.middleView addSubview:self.titleLabel];
    }
    
    return self;
}


- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.alpha = 0;
        _bgView.backgroundColor = [UIColor whiteColor];//HRNavBarColor;
    }
    return _bgView;
}

- (UIView *)middleView
{
    if (!_middleView) {
        _middleView = [[UIView alloc] initWithFrame:CGRectMake(self.center.x - (HRSCREEN_WIDTH - 150)*0.5, self.center.y - (iPhoneX?12:22), HRSCREEN_WIDTH - 150, 64)];
    }
    return _middleView;
}

- (UINavigationItem *)item
{
    if (_item == nil) {
        _item = [[UINavigationItem alloc] init];
        [self setItems:@[_item]];
    }
    
    return _item;
}

- (UINavigationItem *)navItem
{
    return self.item;
}



- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.middleView.bounds];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = HRBoldSysFontOfSize(18.0f *HRSCREEN_WIDTH/375);
    }
    return _titleLabel;
}


- (UIView *)backgroundView
{
    return self.bgView;
}

- (void)setTitle:(NSString *)title
{
    if (self.titleLabel.hidden) {
        self.titleLabel.hidden = NO;
        UIView *titleView = [self.middleView viewWithTag:HR_NAVIGATION_TITLEVIEW_TAG];
        if (titleView) {
            [titleView removeFromSuperview];
            titleView = nil;
        }
    }
    
    self.titleLabel.text = title;
    
}

- (void)setTitleView:(UIView *)titleView
{
    if (titleView) {
        self.titleLabel.hidden = YES;
        titleView.frame = CGRectMake((self.middleView.width - titleView.width)*0.5, (self.middleView.height - titleView.height)*0.5, titleView.width, titleView.height);
        titleView.tag = HR_NAVIGATION_TITLEVIEW_TAG;
        [self.middleView addSubview:titleView];
    }
    else{
        self.titleLabel.hidden = NO;
    }
}


- (CGSize)intrinsicContentSize
{
    return UILayoutFittingExpandedSize;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    // iOS 11 ,自定义导航栏需要设置 UINavigationBar 子控件的frame，不然就是固定的44.
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        for (UIView *view in self.subviews) {
            if([NSStringFromClass([view class]) containsString:@"Background"]) {
                view.frame = self.bounds;
            }
            else if ([NSStringFromClass([view class]) containsString:@"ContentView"]) {
                CGRect frame = view.frame;
                if (iPhoneX) {
                    frame.origin.y = 44;
                }
                else{
                    frame.origin.y = 20;
                }
                frame.size.height = self.bounds.size.height - frame.origin.y;
                view.frame = frame;
            }
        }
    }
#endif
}
@end

//
//  HRTabbar.m
//  LearnDemo
//
//  Created by tianfei on 2018/7/23.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "HRTabbar.h"

#define HRTabBarButtonImageRatio (0.5)
#define HRTabBarButtonFontSize (11.0f)
#define HRTabBarSelectedTitleColor (HRColorFromRGB(0x3573c8))
#define HRTabBarNormalTitleColor (HRColorFromRGB(0x333333))

@interface HRTabbarButton : UIButton
@property(nonatomic, strong)UITabBarItem *item;
@end
@implementation HRTabbarButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //只需要设置一次的放置在这里
        self.imageView.contentMode = UIViewContentModeBottom;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:HRTabBarButtonFontSize];
        [self setTitleColor:HRTabBarSelectedTitleColor forState:UIControlStateSelected];
        [self setTitleColor:HRTabBarNormalTitleColor forState:UIControlStateNormal];
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height*HRTabBarButtonImageRatio;
    
    return CGRectMake(0, 3, imageW, imageH);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height*HRTabBarButtonImageRatio + 4;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY - 6;
    
    return CGRectMake(0, titleY, titleW, titleH);
}

- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    [self setTitle:self.item.title forState:UIControlStateNormal];
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
}

@end


@interface HRTabbar ()
@property(nonatomic, strong) NSMutableArray *tabbarBtnArray;     // 存放tabbar数组

@end
@implementation HRTabbar
- (NSMutableArray *)tabbarBtnArray
{
    if (_tabbarBtnArray == nil) {
        _tabbarBtnArray = [[NSMutableArray alloc] initWithCapacity:4];
    }
    return  _tabbarBtnArray;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _selectedIndex = 0;
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setItems:(NSArray<UITabBarItem *> *)items{
    _items = items;
    [self createItemView];
}

#pragma mark - UI布局
- (void)createItemView{
    CGFloat btnY = 0;
    CGFloat btnW = self.frame.size.width/(self.items.count);
    CGFloat btnH = self.frame.size.height;
    for (int i = 0; i < self.items.count; i++) {
        UITabBarItem *item = self.items[i];
        HRTabbarButton *tabBarBtn = [[HRTabbarButton alloc] init];
        tabBarBtn.item = item;
        tabBarBtn.frame = CGRectMake(btnW * i, btnY, btnW, btnH);
        tabBarBtn.tag = i;
        [self.tabbarBtnArray addObject:tabBarBtn];
        [tabBarBtn addTarget:self action:@selector(itemViewPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:tabBarBtn];
    }
}

#pragma mark - 选择状态改变
- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (_selectedIndex >= 0 && _selectedIndex < self.items.count) {
        
        HRTabbarButton *lastBtn = self.tabbarBtnArray[_selectedIndex];
        if (lastBtn) {
            lastBtn.selected = NO;
        }
        _selectedIndex = selectedIndex;
        
        HRTabbarButton *currentBtn = self.tabbarBtnArray[_selectedIndex];
        currentBtn.selected = YES;
    }
}

#pragma mark - 点击事件
-(void)itemViewPressed:(HRTabbarButton *)tabbarBtn{
    NSInteger currentIndex = tabbarBtn.tag;
    if (currentIndex == _selectedIndex) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectIndex:)]) {
        [self.delegate tabBar:self didSelectIndex:currentIndex];
    }
    // 先缩小
    tabbarBtn.transform = CGAffineTransformMakeScale(0.7, 0.7);
    // Damping（越小弹性越大)
    [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        tabbarBtn.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

@end

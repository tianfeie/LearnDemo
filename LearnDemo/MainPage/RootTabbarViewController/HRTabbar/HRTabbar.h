//
//  LYTabbar.h
//  LearnDemo
//
//  Created by tianfei on 2018/7/23.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HRTabBarDelegate;

@interface HRTabbar : UIView
/**
 *  @brief 代理
 */
@property(nullable,nonatomic,assign) id<HRTabBarDelegate> delegate;
/**
 *  @brief 赋值将刷新视图
 */
@property(nullable,nonatomic,copy) NSArray<UITabBarItem *> *items;

/**
 选中项
 */
@property(nonatomic,assign) NSInteger selectedIndex;
@end


@protocol HRTabBarDelegate <NSObject>

@optional
/**
 *  @brief 点击代理
 *
 *  @param tabBar 实例化
 *  @param index  选中索引
 */
- (void)tabBar:(HRTabbar *)tabBar didSelectIndex:(NSUInteger)index;
@end

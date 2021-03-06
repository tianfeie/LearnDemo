//
//  HRNavigationBar.h
//  LearnDemo
//
//  Created by tianfei on 2018/10/15.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HRNavigationBar : UINavigationBar
@property (nonatomic, strong, readonly)UINavigationItem *navItem;
@property (nonatomic, strong, readonly)UIView *backgroundView;

@property (nonatomic, strong)UIView *titleView;
@property (nonatomic, copy)NSString *title;
@end

NS_ASSUME_NONNULL_END

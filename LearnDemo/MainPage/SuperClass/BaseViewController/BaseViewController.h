//
//  BaseViewController.h
//  LearnDemo
//
//  Created by tianfei on 2018/7/24.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRNavigationBar.h"
@interface BaseViewController : UIViewController
@property (nonatomic,strong)HRNavigationBar * hrNavigationBar;
@property (nonatomic,strong)UINavigationItem *hrNavigationItem;

@property (nonatomic, assign)BOOL  showBackButton;
@property (nonatomic, assign)BOOL  showRightButton;
@property (nonatomic, assign)BOOL  isPeresntVc;
@end

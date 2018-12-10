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
@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic,strong)HRNavigationBar * hrNavigationBar;
@property (nonatomic,strong)UINavigationItem *hrNavigationItem;

@property (nonatomic, assign)BOOL  hideBackBtn;
@property (nonatomic, assign)BOOL  showRightBtn;
@property (nonatomic, assign)BOOL  isPeresntVc;
@end

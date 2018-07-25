//
//  ZDSliderPickView.h
//  ZDSliderPickView
//
//  Created by songzidong on 2018/7/13.
//  Copyright © 2018年 SZD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDSliderPickView : UIView

/**
 可设置 默认初始选择值
 */
@property(nonatomic, assign)CGFloat defaultPointerValue;

/**
 实例化一个滑动选择器

 @param rect frame
 @param maxValue 最大可选值
 @param completion 回传选择结果
 @return 滑动选择器
 */
+ (instancetype)sliderProgressViewWithFrame:(CGRect)rect
                                   maxValue:(CGFloat)maxValue
                                 completion:(void(^)(NSString *value))completion;

@end

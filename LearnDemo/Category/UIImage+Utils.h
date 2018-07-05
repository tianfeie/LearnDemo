//
//  UIImage+Utils.h
//  LearnDemo
//
//  Created by tianfei on 2018/7/3.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

/**
 根据颜色生成图片

 @param color 颜色
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 照片旋转90度处理
 */
-(UIImage *)fixOrientation;

/**
 截取圆形图片

 @return 圆形图片
 */
- (UIImage *)cropCircleImage;
@end

//
//  GreateModel.m
//  LearnDemo
//
//  Created by tianfei on 2018/10/8.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "GreateModel.h"
#import "ClassModel.h"
@implementation GreateModel
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"classModels" : [ClassModel class]};
}
@end

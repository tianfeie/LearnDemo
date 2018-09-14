//
//  CLBillsModel.m
//  hrcfc
//
//  Created by tianfei on 2018/4/12.
//  Copyright © 2018年 Huarong Comsumer Finance. All rights reserved.
//

#import "HRCircularLoanBillsDetailModel.h"
@implementation HRCircularLoanBillsDetailModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end

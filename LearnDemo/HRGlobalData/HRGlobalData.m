//
//  HRGlobalData.m
//  LearnDemo
//
//  Created by tianfei on 2018/9/19.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "HRGlobalData.h"
@interface HRGlobalData ()
//日期格式
@property(nonatomic,strong)NSDateFormatter *formatter;
@end
@implementation HRGlobalData
+(HRGlobalData *)shareInstance{
    static HRGlobalData *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}
- (NSDateFormatter *)formatter{
    
    if(! _formatter) {
        
        _formatter = [[NSDateFormatter alloc] init];
    }
    
    return _formatter;
}

- (NSString *)appVersion
{
    if (_appVersion == nil) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    return _appVersion;
}

- (NSString *)getSystemTimeWithFormatter:(NSString *)formatter{
    [self.formatter setDateFormat:formatter];
    NSString *time = [self.formatter stringFromDate:[NSDate date]];
    if (time) {
        return time;
    }
    return @"";
}

- (void)testBlock:(TestBlock)testBlock{
    NSString *str=testBlock(@"123");
    HRLog(@"testBlock:%@",str);
}
@end

//
//  HRGlobalData.h
//  LearnDemo
//
//  Created by tianfei on 2018/9/19.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NSString* (^TestBlock)(NSString *paramStr);
@interface HRGlobalData : NSObject
+ (HRGlobalData *)shareInstance;
/**
 App 版本
 */
@property(nonatomic, copy)NSString *appVersion;
- (NSString *)getSystemTimeWithFormatter:(NSString *)formatter;
- (void)testBlock:(TestBlock)testBlock;
@end

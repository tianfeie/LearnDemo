//
//  NSString+Utils.h
//  LearnDemo
//
//  Created by tianfei on 2018/7/3.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)


/**
 计算string宽高

 @param string  需要计算的string
 @param inSize  需要计算的size
 @param attributes  字符串特性
 @return    返回尺寸
 */
+ (CGSize )calculateStringSize:(NSString *)string inSize:(CGSize )inSize attributes:(NSDictionary *)attributes;



/**
  dictionary 转 json

 @param dic dic
 @return json串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 json 转 dictionary

 @return dictionary
 */
- (id)JSONValue;

/**
 判断字符串是否为nil NULL
 
 @param object obj
 @return 返回该字符串，若为nil 返回 @""
 */
+ (NSString *)safetyString:(id)object;

- (NSString *)middleHiddenString;
@end

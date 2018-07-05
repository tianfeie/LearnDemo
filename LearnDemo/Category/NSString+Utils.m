//
//  NSString+Utils.m
//  LearnDemo
//
//  Created by tianfei on 2018/7/3.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

+ (CGSize )calculateStringSize:(NSString *)string inSize:(CGSize )inSize attributes:(NSDictionary *)attributes
{
    CGSize  strSzie = [string boundingRectWithSize:inSize  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine)  attributes:attributes context:nil].size;
    
    CGSize reSzie = CGSizeMake(ceilf(strSzie.width) + 8 , ceilf(strSzie.height)+8);
    
    return reSzie;
}


// 字典转json格式字符串：
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    if (dic) {
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    else{
        return @"";
    }
}

- (id)JSONValue{
    
    NSError *error;
    
    if ([self isKindOfClass:[NSString class]]) {
        id object =[NSJSONSerialization JSONObjectWithData:[((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (error&&((NSString *)self).length>0) {
            NSLog(@"AnalysisJsonError: %@",error.userInfo);
        }
        return object;
    }
    else if ([self isKindOfClass:[NSData class]]) {
        id object =[NSJSONSerialization JSONObjectWithData:(NSData *)self options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSLog(@"AnalysisJsonError: %@",error.userInfo);
        }
        return object;
    }
    return nil;
}

+ (NSString *)getNoNullString:(id)object
{
    
    // 若不是字符串类型，直接转换位字符串返回
    if (!object || [object isEqual:[NSNull null]] || [object isEqual:@"<null>"]) {
        return @"";
    }
    else{
        return [NSString stringWithFormat:@"%@",object];
    }
}
- (NSString *)middleHiddenString{
    NSInteger len =[self length];
    if (len <=2) {
        return self;
    }else if(len <3){
        NSString *strLastChar =[self substringFromIndex:len -1];
        NSString *string =[NSString stringWithFormat:@"*%@",strLastChar];
        return string;
    }else if (len ==11){
        NSMutableString *stringBlackPoint =[[NSMutableString alloc] initWithString:@""];
        for (NSInteger i=0; i<len -7; i++) {
            [stringBlackPoint appendString:@"*"];
        }
        NSString *strFirstChar =[self substringToIndex:3];
        NSString *strLastChar =[self substringFromIndex:len -4];
        
        NSString *string =[NSString stringWithFormat:@"%@%@%@",strFirstChar,stringBlackPoint,strLastChar];
        return string;
    }else{
        NSMutableString *stringBlackPoint =[[NSMutableString alloc] initWithString:@""];
        for (NSInteger i=0; i<len -2; i++) {
            [stringBlackPoint appendString:@"*"];
        }
        NSString *strFirstChar =[self substringToIndex:1];
        NSString *strLastChar =[self substringFromIndex:len -1];
        NSString *string =[NSString stringWithFormat:@"%@%@%@",strFirstChar,stringBlackPoint,strLastChar];
        return string;
    }
    return self;
}

@end

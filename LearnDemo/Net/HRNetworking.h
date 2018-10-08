//
//  HRNetworking.h
//  LearnDemo
//
//  Created by tianfei on 2018/9/14.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString *const RequestBaseUrl = @"";
// 请求成功的Block
typedef void(^HRHttpRequestSuccess)(id responseObject);

// 请求失败的Block
typedef void(^HRHttpRequestFailed)(NSError *error);
/**
 上传或者下载的进度
 
 @param progress 进度 completedUnitCount:当前大小 totalUnitCount:总大小
 
 */
typedef void(^LRHttpProgress)(NSProgress *progress);
@interface HRNetworking : NSObject
+ (void)cancelAllRequest;
+ (void)cancelRequestWithURL:(NSString *)URL;
@end

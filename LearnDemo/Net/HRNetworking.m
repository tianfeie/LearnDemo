//
//  HRNetworking.m
//  LearnDemo
//
//  Created by tianfei on 2018/9/14.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "HRNetworking.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "MBProgressHUD.h"
static NSMutableArray *_allSessionTask;
static AFHTTPSessionManager *_sessionManager;

@interface HRNetworking()

@end
@implementation HRNetworking
#pragma mark - 初始化AFHTTPSessionManager相关属性

/**
 *  所有的HTTP请求共享一个AFHTTPSessionManager
 *  原理参考地址:http://www.jianshu.com/p/5969bbb4af9f
 */
+ (void)initialize {
    _sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _sessionManager.requestSerializer.timeoutInterval = 45.f;
}
+ (NSURLSession *)getHttpSession
{
    return _sessionManager.session;
}
// 取消所有请求
+ (void)cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}


// 取消特定 Url 请求
+ (void)cancelRequestWithURL:(NSString *)URL {
    if (HRStringIsEmpty(URL)) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}
/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

#pragma mark - GET请求
+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(NSDictionary *)parameters
                  success:(HRHttpRequestSuccess)success
                  failure:(HRHttpRequestFailed)failure {
    
    NSDictionary *param = [self addPublicParam:parameters];
    NSString *newUrl = [NSString stringWithFormat:@"%@/%@",RequestBaseUrl,URL];
    NSURLSessionTask *sessionTask = [_sessionManager GET:newUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(NSDictionary *)parameters
                   success:(HRHttpRequestSuccess)success
                   failure:(HRHttpRequestFailed)failure inSuperView:(UIView *)superView{
    
    NSDictionary *param = [self addPublicParam:parameters];
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",RequestBaseUrl,URL];
    
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"加载中...";
    hud.label.textColor = [UIColor darkGrayColor];
    
    HRLog(@"\n------------请求地址参数-------------\n地址 == %@\n参数 == %@\n------------*************-------------", newUrl, param);
    NSURLSessionTask *sessionTask = [_sessionManager POST:newUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allSessionTask] removeObject:task];
        HRLog(@"\n------------返回数据-------------\n%@\n------------*************-------------", responseObject);
        success ? success(responseObject) : nil;
        [hud setHidden:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
        [hud setHidden:YES];
    }];
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}

#pragma mark - 上传文件
+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                             parameters:(NSDictionary *)parameters
                                   name:(NSString *)name
                               filePath:(NSString *)filePath
                               progress:(LRHttpProgress)progress
                                success:(HRHttpRequestSuccess)success
                                failure:(HRHttpRequestFailed)failure {
    
    
    NSDictionary *param = [self addPublicParam:parameters];
    NSString *newUrl = [NSString stringWithFormat:@"%@/%@",RequestBaseUrl,URL];
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:newUrl parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:name error:&error];
        (failure && error) ? failure(error) : nil;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - 上传多张图片
+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                               parameters:(NSDictionary *)parameters
                                     name:(NSString *)name
                                   images:(NSArray<UIImage *> *)images
                                fileNames:(NSArray<NSString *> *)fileNames
                               imageScale:(CGFloat)imageScale
                                imageType:(NSString *)imageType
                                 progress:(LRHttpProgress)progress
                                  success:(HRHttpRequestSuccess)success
                                  failure:(HRHttpRequestFailed)failure{
    
    NSDictionary *param = [self addPublicParam:parameters];
    NSString *newUrl = [NSString stringWithFormat:@"%@/%@",RequestBaseUrl,URL];

    NSURLSessionTask *sessionTask = [_sessionManager POST:newUrl parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSUInteger i = 0; i < images.count; i++) {
            // 图片经过等比压缩后得到的二进制文件
            NSData *imageData = UIImageJPEGRepresentation(images[i], imageScale?: 1.f);
            // 默认图片的文件名, 若fileNames为nil就使用
            NSString *str = [[HRGlobalData shareInstance] getSystemTimeWithFormatter:@"yyyyMMddHHmmss"];
            NSString *imageFileName = [NSString stringWithFormat:@"%@%ld.%@",str,(unsigned long)i,imageType?:@"jpg"];
            
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:fileNames?[NSString stringWithFormat:@"%@.%@",fileNames[i],imageType?:@"jpg"]:imageFileName
                                    mimeType:[NSString stringWithFormat:@"image/%@",imageType ?: @"jpg"]];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - 下载文件
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(LRHttpProgress)progress
                              success:(void(^)(NSURL *fileUrl))success
                              failure:(HRHttpRequestFailed)failure {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
   
    __block NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录 默认保存到 Download
        NSString *saveFile = @"Download";
        if (fileDir && fileDir.length > 0) {
            saveFile = fileDir;
        }
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:saveFile];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[self allSessionTask] removeObject:downloadTask];
        success?success(filePath) : nil;
    }];
    //开始下载
    [downloadTask resume];
    // 添加sessionTask到数组
    downloadTask ? [[self allSessionTask] addObject:downloadTask] : nil ;
    
    return downloadTask;
}

+ (NSDictionary *)addPublicParam:(NSDictionary *)param
{
    if ([[param allKeys]  containsObject:@"msgHead"]) {
        return param;
    }
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"client",@"userType",@"ios",@"clientType",@"1",@"sourceID",[HRGlobalData shareInstance].appVersion,@"versionName",@"IOS",@"channelId", nil];
    if (!param) {
        return mutableDic;
    }
    
    [mutableDic addEntriesFromDictionary:param];
    return mutableDic;
}
@end

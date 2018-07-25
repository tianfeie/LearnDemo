//
//  TFCameraViewController.h
//  LearnDemo
//
//  Created by tianfei on 2018/7/3.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CameraViewController;
@protocol TFCameraDelegate <NSObject>

/**
 选择图片完成

 @param editedImage 选择的图片
 */
- (void)cameraViewControllerDidFinished:(UIImage *)editedImage;

/**
 取消选择
 */
- (void)cameraDidFinishedDidCancel;

@end

@interface TFCameraViewController : UIViewController
//代理
@property (nonatomic, assign) id<TFCameraDelegate> delegate;
@end

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

- (void)cameraViewControllerDidFinished:(UIImage *)editedImage;
- (void)cameraDidFinishedDidCancel;
@end

@interface TFCameraViewController : UIViewController
//代理
@property (nonatomic, assign) id<TFCameraDelegate> delegate;
@end

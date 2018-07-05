//
//  TFCameraManager.h
//  LearnDemo
//
//  Created by tianfei on 2018/7/3.
//  Copyright © 2018年 huarong. All rights reserved.
//
typedef NS_ENUM(NSInteger,ImagePickerType)
{
    ImagePickerCamera = 0,
    ImagePickerPhoto = 1
};

#import <Foundation/Foundation.h>
@protocol TFImagePickerDelegate <NSObject>

- (void)imagePickerDidFinished:(UIImage *)editedImage;
- (void)imagePickerDidCancel;
@end

@interface TFImagePicker : NSObject
//选择原图片
- (void)showOriginalImagePickerWithType:(ImagePickerType)type InViewController:(UIViewController *)viewController;
//代理
@property (nonatomic, assign) id<TFImagePickerDelegate> delegate;
@end


//
//  TFImageCropViewController.h
//  LearnDemo
//
//  Created by tianfei on 2018/7/3.
//  Copyright © 2018年 huarong. All rights reserved.
//
typedef enum {
    TFImageCropTypeArc = 0,
    TFImageCropTypeRect
}TFImageCropType;
#import <UIKit/UIKit.h>

@protocol TFImageCropViewControllerDelegate;

@interface TFImageCropViewController : UIViewController
@property (weak, nonatomic) id<TFImageCropViewControllerDelegate> delegate;

@property (nonatomic,assign) TFImageCropType imageCropType;
/**
 Designated initializer. Initializes and returns a newly allocated view controller object with the specified image.
 
 @param originalImage The image for cropping.
 */
- (instancetype)initWithImage:(UIImage *)originalImage;

-(instancetype)initWithImage:(UIImage *)originalImage imageCropType:(TFImageCropType)type;

/**
 The image for cropping.
 */
@property (strong, nonatomic) UIImage *originalImage;
@end


@protocol TFImageCropViewControllerDelegate <NSObject>
/**
 Tells the delegate that crop image has been canceled.
 */
- (void)imageCropViewControllerDidCancelCrop:(TFImageCropViewController *)controller;

/**
 Tells the delegate that the original image has been cropped.
 */
- (void)imageCropViewController:(TFImageCropViewController *)controller didCropImage:(UIImage *)croppedImage;


@end


//
//  TFCameraManager.m
//  LearnDemo
//
//  Created by tianfei on 2018/7/3.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "TFImagePicker.h"
#import "TFImageCropViewController.h"
#import "TFCameraViewController.h"
@interface TFImagePicker ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,TFImageCropViewControllerDelegate,TFCameraDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) TFCameraViewController *cameraViewController;
@end
@implementation TFImagePicker

- (void)showOriginalImagePickerWithType:(ImagePickerType)type InViewController:(UIViewController *)viewController{
    if (type == ImagePickerCamera) {
        [viewController presentViewController:self.cameraViewController animated:YES completion:nil];
    }else{
        
        [viewController presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}
#pragma mark - Getters
- (UIImagePickerController *)imagePickerController{
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    }
    return _imagePickerController;
}
- (TFCameraViewController *)cameraViewController{
    if (!_cameraViewController) {
        _cameraViewController = [[TFCameraViewController alloc] init];
        _cameraViewController.delegate = self;
    }
    return _cameraViewController;
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    TFImageCropViewController *imageCropViewController = [[TFImageCropViewController alloc] initWithImage:image];
    imageCropViewController.delegate = self;
    [picker pushViewController:imageCropViewController animated:YES];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    if (self.delegate) {
        [self.delegate imagePickerDidCancel];
    }
}

#pragma mark - TFImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(TFImageCropViewController *)controller
{
    [controller.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(TFImageCropViewController *)controller didCropImage:(UIImage *)croppedImage{
    if (self.delegate) {
        [self.delegate imagePickerDidFinished:croppedImage];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TFCameraDelegate
- (void)cameraViewControllerDidFinished:(UIImage *)editedImage{
    if (self.delegate) {
        [self.delegate imagePickerDidFinished:editedImage];
    }
}

- (void)cameraDidFinishedDidCancel{
    if (self.delegate) {
        [self.delegate imagePickerDidCancel];
    }
}
@end

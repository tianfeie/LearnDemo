//
//  TFCameraViewController.m
//  LearnDemo
//
//  Created by tianfei on 2018/7/3.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "TFCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TFImageCropViewController.h"
@interface TFCameraViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,TFImageCropViewControllerDelegate>
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;

@property (nonatomic)AVCaptureStillImageOutput *imageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic)UIButton *PhotoButton;
@property (nonatomic)UIButton *flashButton;
@property (nonatomic)UIImageView *focusView;
@property (nonatomic)BOOL isflashOn;
@property (nonatomic)UIImage *image;

@property (nonatomic)BOOL canCa;
@end

@implementation TFCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    _canCa = [self canUserCamear];
    if (_canCa) {
        [self customCamera];
        [self customUI];
    }else{
        return;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.session startRunning];
}

#pragma mark - 设置UI
- (void)customUI{
    UIImageView *topBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TFSCREEN_WIDTH, 50)];
    topBg.backgroundColor = [UIColor blackColor];
    topBg.alpha = 0.7;
    [self.view addSubview:topBg];
    UIImageView *bottomBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, TFSCREEN_HEIGHT - 140, TFSCREEN_WIDTH, 140)];
    bottomBg.backgroundColor = [UIColor blackColor];
    bottomBg.alpha = 0.7;
    [self.view addSubview:bottomBg];
    
    UILabel *photoLb = [[UILabel alloc] initWithFrame:CGRectMake(0, bottomBg.top + 17, self.view.width, 18)];
    photoLb.text = @"照片";
    photoLb.textColor = [UIColor whiteColor];
    photoLb.font = TFSysFontOfSize(13);
    photoLb.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:photoLb];
    
    _PhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _PhotoButton.frame = CGRectMake(TFSCREEN_WIDTH*1/2.0-30, TFSCREEN_HEIGHT-90, 60, 60);
    [_PhotoButton setImage:[UIImage imageNamed:@"photograph"] forState: UIControlStateNormal];
    //    [_PhotoButton setImage:[UIImage imageNamed:@"photograph_Select"] forState:UIControlStateNormal];
    [_PhotoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_PhotoButton];
    
    _focusView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 122, 122)];
    _focusView.image = [UIImage imageNamed:@"focus"];
    [self.view addSubview:_focusView];
    _focusView.hidden = YES;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(25, TFSCREEN_HEIGHT- 54, 52, 52);
    leftButton.centerY = _PhotoButton.centerY;
    
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [leftButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(TFSCREEN_WIDTH - 80, TFSCREEN_HEIGHT-100, 60, 60);
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(17.5, 15, 17.5, 15);
    [rightButton setImage:[UIImage imageNamed:@"changeCamera"] forState:UIControlStateNormal];
    rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    rightButton.centerY = _PhotoButton.centerY;
    [rightButton addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _flashButton.frame = CGRectMake(0, 0, 70, 50);
    _flashButton.imageEdgeInsets = UIEdgeInsetsMake(15, 20, 15, 20);
    [_flashButton setImage:[UIImage imageNamed:@"flashOpen"] forState:UIControlStateNormal];
    [_flashButton addTarget:self action:@selector(FlashOn) forControlEvents:UIControlEventTouchUpInside];
    _isflashOn = YES;
    [self.view addSubview:_flashButton];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - 设置相机
- (void)customCamera{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.imageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
        
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.imageOutPut]) {
        [self.session addOutput:self.imageOutPut];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, TFSCREEN_WIDTH, TFSCREEN_HEIGHT);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
}

#pragma mark - 闪光灯
- (void)FlashOn{
    if ([_device lockForConfiguration:nil]) {
        if (_isflashOn) {
            if ([_device isFlashModeSupported:AVCaptureFlashModeOff]) {
                [_device setFlashMode:AVCaptureFlashModeOff];
                _isflashOn = NO;
                [_flashButton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
                //                [_flashButton setTitle:@"闪光灯关" forState:UIControlStateNormal];
            }
        }else{
            if ([_device isFlashModeSupported:AVCaptureFlashModeOn]) {
                [_device setFlashMode:AVCaptureFlashModeOn];
                _isflashOn = YES;
                [_flashButton setImage:[UIImage imageNamed:@"flashOpen"] forState:UIControlStateNormal];
            }
        }
        
        [_device unlockForConfiguration];
    }
}

#pragma mark - 切换摄像头
- (void)changeCamera{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        
        CATransition *animation = [CATransition animation];
        
        animation.duration = .5f;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        animation.type = @"oglFlip";
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        AVCaptureDevicePosition position = [[_input device] position];
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
        }
        else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
        }
        
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [self.previewLayer addAnimation:animation forKey:nil];
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:_input];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.input = newInput;
                
            } else {
                [self.session addInput:self.input];
            }
            
            [self.session commitConfiguration];
            
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
        
    }
}
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}
- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
}

#pragma mark - 截取照片
- (void) shutterCamera{
    AVCaptureConnection * videoConnection = [self.imageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        
        NSLog(@"image size = %@",NSStringFromCGSize(self.image.size));
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.imageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        self.image = image;
        [self.session stopRunning];
        NSLog(@"image size = %@",NSStringFromCGSize(self.image.size));
        TFImageCropViewController *imageCropViewController = [[TFImageCropViewController alloc] initWithImage:_image];
        imageCropViewController.delegate = self;
        [self addChildViewController:imageCropViewController];
        [self.view addSubview:imageCropViewController.view];
    }];
}

#pragma mark - TFImageCropViewControllerDelegate
- (void)imageCropViewController:(TFImageCropViewController *)controller didCropImage:(UIImage *)croppedImage{
    [self dismissViewControllerAnimated:YES completion:^{
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
        [self.session stopRunning];
    }];
    [self saveImageToPhotoAlbum:croppedImage];
    if (self.delegate) {
        [self.delegate cameraViewControllerDidFinished:croppedImage];
    }
}

- (void)imageCropViewControllerDidCancelCrop:(TFImageCropViewController *)controller
{
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
    [self.session startRunning];
}

#pragma - 保存至相册
- (void)saveImageToPhotoAlbum:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
    if(error != NULL){
        NSLog(@"保存图片失败");
    }else{
        NSLog(@"保存图片成功");
    }
}
-(void)cancle{
    [self.session startRunning];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate) {
        [self.delegate cameraDidFinishedDidCancel];
    }
}

#pragma mark - 检查相机权限
- (BOOL)canUserCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Title"
                                                                       message:@"App未获得您的相机权限，请在设置中开启相机权限"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  //响应事件
                                                                  NSLog(@"action = %@", action);
                                                              }];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 //响应事件
                                                                 NSLog(@"action = %@", action);
                                                                 NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                                 if([[UIApplication sharedApplication] canOpenURL:url]) {
                                                                     [[UIApplication sharedApplication] openURL:url];
                                                                 }
                                                             }];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];

        return NO;
    }
    else{
        return YES;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

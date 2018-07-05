//
//  TFImageCropViewController.m
//  LearnDemo
//
//  Created by tianfei on 2018/7/3.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "TFImageCropViewController.h"
#import "TFImageScrollView.h"
#import "UIImage+Utils.h"
@interface TFImageCropViewController ()
@property (strong, nonatomic) TFImageScrollView *imageScrollView;
@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) CAShapeLayer *maskLayer;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *chooseButton;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGestureRecognizer;
@end

@implementation TFImageCropViewController
- (instancetype)initWithImage:(UIImage *)originalImage
{
    self = [super init];
    if (self) {
        _originalImage = originalImage;
    }
    return self;
}
-(instancetype)initWithImage:(UIImage *)originalImage imageCropType:(TFImageCropType)type{
    self = [super init];
    if (self) {
        _originalImage = originalImage;
        _imageCropType = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageScrollView];
    [self.view addSubview:self.overlayView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.cancelButton];
    [self.bottomView addSubview:self.chooseButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self layoutImageScrollView];
    [self layoutOverlayView];
    [self updateMaskPath];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!self.imageScrollView.zoomView) {
        [self displayImage];
    }
}
#pragma mark - Custom Accessors

- (TFImageScrollView *)imageScrollView
{
    if (!_imageScrollView) {
        _imageScrollView = [[TFImageScrollView alloc] init];
        _imageScrollView.clipsToBounds = NO;
    }
    return _imageScrollView;
}

- (UIView *)overlayView
{
    if (!_overlayView) {
        _overlayView = [[UIView alloc] init];
        [_overlayView.layer addSublayer:self.maskLayer];
        _overlayView.userInteractionEnabled =NO;
    }
    return _overlayView;
}

- (CAShapeLayer *)maskLayer
{
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.fillRule = kCAFillRuleEvenOdd;
        _maskLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
    }
    return _maskLayer;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, TFSCREEN_HEIGHT - TF_TABBARBAR_HEIGHT, TFSCREEN_WIDTH, TF_TABBARBAR_HEIGHT)];
        _bottomView.backgroundColor = TFColorFromRGBA(0x000000, 0.7);
    }
    return _bottomView;
}
- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        //        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        _cancelButton.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 49);
        [_cancelButton setTitle:@"重新选择" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor clearColor];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton addTarget:self action:@selector(onCancelButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        //        _cancelButton.opaque = NO;
    }
    return _cancelButton;
}

- (UIButton *)chooseButton
{
    if (!_chooseButton) {
        _chooseButton = [[UIButton alloc] init];
        //        _chooseButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_chooseButton setTitle:@"使用照片" forState:UIControlStateNormal];
        [_chooseButton addTarget:self action:@selector(onChooseButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        _chooseButton.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 49);
        _chooseButton.backgroundColor = [UIColor clearColor];
        [_chooseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _chooseButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _chooseButton;
}

- (UITapGestureRecognizer *)doubleTapGestureRecognizer
{
    if (!_doubleTapGestureRecognizer) {
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTapGestureRecognizer.delaysTouchesEnded = NO;
        _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    }
    return _doubleTapGestureRecognizer;
}

#pragma mark - Action handling

- (void)onCancelButtonTouch:(UIBarButtonItem *)sender
{
    [self cancelCrop];
}

- (void)onChooseButtonTouch:(UIBarButtonItem *)sender
{
    [self cropImage];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [self resetZoomScale:YES];
    [self resetContentOffset:YES];
}

#pragma mark - Private

- (void)resetZoomScale:(BOOL)animated
{
    CGFloat zoomScale;
    if (CGRectGetWidth(self.view.bounds) > CGRectGetHeight(self.view.bounds)) {
        zoomScale = CGRectGetHeight(self.view.bounds) / self.originalImage.size.height;
    } else {
        zoomScale = CGRectGetWidth(self.view.bounds) / self.originalImage.size.width;
    }
    [self.imageScrollView setZoomScale:zoomScale animated:animated];
}

- (void)resetContentOffset:(BOOL)animated
{
    CGSize boundsSize = self.imageScrollView.bounds.size;
    CGRect frameToCenter = self.imageScrollView.zoomView.frame;
    CGPoint contentOffset = self.imageScrollView.contentOffset;
    contentOffset.x = (frameToCenter.size.width - boundsSize.width) / 2.0;
    contentOffset.y = (frameToCenter.size.height - boundsSize.height) / 2.0;
    [self.imageScrollView setContentOffset:contentOffset animated:animated];
}

- (void)displayImage
{
    if (self.originalImage) {
        [self.imageScrollView displayImage:self.originalImage];
        [self resetZoomScale:NO];
    }
}

- (void)layoutImageScrollView
{
    self.imageScrollView.frame = [self maskRect];
    //    self.imageScrollView.frame = self.view.bounds;
}

- (void)layoutOverlayView
{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) * 2, CGRectGetHeight(self.view.bounds) * 2);
    self.overlayView.frame = frame;
}

- (void)updateMaskPath
{
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:self.overlayView.frame];
    //bezierPathWithRect --矩形--
    UIBezierPath *maskPath ;
    
    if (self.imageCropType == TFImageCropTypeArc) {
        maskPath = [UIBezierPath bezierPathWithOvalInRect:[self maskRect]];
    }else if (self.imageCropType == TFImageCropTypeRect){
        maskPath = [UIBezierPath bezierPathWithRect:[self maskRect]];
    }
    
    [clipPath appendPath:maskPath];
    clipPath.usesEvenOddFillRule = YES;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = [CATransaction animationDuration];
    pathAnimation.timingFunction = [CATransaction animationTimingFunction];
    [self.maskLayer addAnimation:pathAnimation forKey:@"path"];
    
    self.maskLayer.path = [clipPath CGPath];
}

- (CGRect)maskRect
{
    CGRect bounds = self.view.bounds;
    
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);
    
    CGFloat diameter;
    
    diameter = MIN(width, height) - 20;
    
    CGFloat radius = diameter / 2;
    CGPoint center = CGPointMake(width / 2, height / 2);
    
    CGRect maskRect = CGRectMake(center.x - radius, center.y - radius - 25, diameter, diameter);
    
    if (self.imageCropType == TFImageCropTypeArc) {
        
    }else if(self.imageCropType == TFImageCropTypeRect){
        maskRect = CGRectMake(5, center.y - radius -25, diameter-10, diameter - 10);
    }
    
    return maskRect;
}

- (CGRect)cropRect
{
    CGRect cropRect = CGRectZero;
    float zoomScale = 1.0 / self.imageScrollView.zoomScale;
    
    cropRect.origin.x = self.imageScrollView.contentOffset.x * zoomScale;
    cropRect.origin.y = self.imageScrollView.contentOffset.y * zoomScale;
    cropRect.size.width = CGRectGetWidth(self.imageScrollView.bounds) * zoomScale;
    cropRect.size.height = CGRectGetHeight(self.imageScrollView.bounds) * zoomScale;
    
    CGSize imageSize = self.originalImage.size;
    CGFloat x = CGRectGetMinX(cropRect);
    CGFloat y = CGRectGetMinY(cropRect);
    CGFloat width = CGRectGetWidth(cropRect);
    CGFloat height = CGRectGetHeight(cropRect);
    
    UIImageOrientation imageOrientation = self.originalImage.imageOrientation;
    if (imageOrientation == UIImageOrientationRight || imageOrientation == UIImageOrientationRightMirrored) {
        cropRect.origin.x = y;
        cropRect.origin.y = imageSize.width - CGRectGetWidth(cropRect) - x;
        cropRect.size.width = height;
        cropRect.size.height = width;
    } else if (imageOrientation == UIImageOrientationLeft || imageOrientation == UIImageOrientationLeftMirrored) {
        cropRect.origin.x = imageSize.height - CGRectGetHeight(cropRect) - y;
        cropRect.origin.y = x;
        cropRect.size.width = height;
        cropRect.size.height = width;
    } else if (imageOrientation == UIImageOrientationDown || imageOrientation == UIImageOrientationDownMirrored) {
        cropRect.origin.x = imageSize.width - CGRectGetWidth(cropRect) - x;;
        cropRect.origin.y = imageSize.height - CGRectGetHeight(cropRect) - y;
    }
    
    return cropRect;
}

- (UIImage *)croppedImage:(UIImage *)image cropRect:(CGRect)cropRect
{
    CGImageRef croppedCGImage = CGImageCreateWithImageInRect(image.CGImage, cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:croppedCGImage scale:1.0f orientation:image.imageOrientation];
    CGImageRelease(croppedCGImage);
    return [croppedImage fixOrientation];
}

- (void)cropImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *croppedImage = [self croppedImage:self.originalImage cropRect:[self cropRect]];
        croppedImage = [croppedImage cropCircleImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(imageCropViewController:didCropImage:)]) {
                [self.delegate imageCropViewController:self didCropImage:croppedImage];
            }
        });
    });
}

- (void)cancelCrop
{
    if ([self.delegate respondsToSelector:@selector(imageCropViewControllerDidCancelCrop:)]) {
        [self.delegate imageCropViewControllerDidCancelCrop:self];
    }
}

@end

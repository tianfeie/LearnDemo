//
//  TFCameraViewController.m
//  LearnDemo
//
//  Created by tianfei on 2018/7/3.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFImageScrollView : UIScrollView<UIScrollViewDelegate>{

    @private

    CGSize _imageSize;
    
    CGPoint _pointToCenterAfterResize;
    CGFloat _scaleToRestoreAfterResize;
}

@property (nonatomic, strong) UIImageView *zoomView;

- (void)displayImage:(UIImage *)image;

@end

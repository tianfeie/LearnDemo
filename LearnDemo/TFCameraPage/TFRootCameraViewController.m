//
//  TFRootCameraViewController.m
//  LearnDemo
//
//  Created by tianfei on 2018/7/12.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "TFRootCameraViewController.h"
#import "TFImagePicker.h"
#import "UIImage+Utils.h"

@interface TFRootCameraViewController ()<TFImagePickerDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) TFImagePicker *imagePicker;
@property (nonatomic, strong) UIButton *button;
@end

@implementation TFRootCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initSubViews{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"选择图片" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showSheetView)
     forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor grayColor];
    button.frame = CGRectMake((TFSCREEN_WIDTH - 200)*0.5, self.imageView.bottom + 40 , 200, TF_TABBARBAR_HEIGHT - TF_IPHONE_HOME_HEIGHT);
    [self.view addSubview:button];
}
- (void)textHRPayFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textField:%@",textField.text);
}
- (TFImagePicker *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[TFImagePicker alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, TF_NAVIGATIONBAR_HEIGHT + 10, TFSCREEN_WIDTH -20, TFSCREEN_WIDTH -20)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.borderWidth = 0.5;
        _imageView.layer.borderColor = [UIColor orangeColor].CGColor;
        UIImage *image = [[UIImage imageNamed:@"tf_default.jpg"] cropCircleImage];
        _imageView.image = image;
    }
    return _imageView;
}

#pragma mark - UIAlertController
- (void)showSheetView{
    
    TFWeakSelf;
    //显示弹出框列表选择
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             NSLog(@"action = %@", action);
                                                         }];
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             NSLog(@"action = %@", action);
                                                             [weakSelf.imagePicker showOriginalImagePickerWithType:ImagePickerPhoto InViewController:self];
                                                         }];
    UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           //响应事件
                                                           NSLog(@"action = %@", action);
                                                           [weakSelf.imagePicker showOriginalImagePickerWithType:ImagePickerCamera InViewController:self];
                                                       }];
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    [alert addAction:deleteAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark -
- (void)imagePickerDidFinished:(UIImage *)editedImage{
    self.imageView.image = editedImage;
}
- (void)imagePickerDidCancel{
    NSLog(@"取消使用图片");
}
@end

//
//  HRPayTextField.m
//  LearnDemo
//
//  Created by tianfei on 2018/7/12.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import "HRPayTextField.h"
#import "CKKeyboard.h"

@interface HRPayContentTextField : UITextField
@end
@implementation HRPayContentTextField

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}
@end

@interface HRPayTextField ()<UITextFieldDelegate>
@property (nonatomic, strong) HRPayContentTextField *textField;
@end
@implementation HRPayTextField
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews{
    //子控件宽
    CGFloat w = 50;
    //子控件高
    CGFloat h = 50;
    //计算间距
    CGFloat margin =(self.width - w*6)/5.0;
    for (int i= 0; i<6; i++) {
        CGFloat x = i * (margin + w);
        CGFloat y = 0;
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setTitle:@"" forState:UIControlStateNormal];
        [button1 setTitleColor:TFColorFromRGB(0x333333) forState:UIControlStateNormal];
        button1.userInteractionEnabled =  NO;
        button1.frame = CGRectMake(x,y,w,h);
        button1.tag = 1000 + i;
        button1.layer.borderWidth = 0.5;
        button1.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:button1];
    }
    self.textField = [[HRPayContentTextField alloc] initWithFrame:self.bounds];
    self.textField.tintColor = [UIColor clearColor];
    self.textField.textColor = [UIColor clearColor];
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.delegate = self;
    // 设置安全输入键盘
//    CKKeyboard *safeKB = [[CKKeyboard alloc] initWithType:CKBTypeASCIICapable];
//    self.textField.inputView = safeKB;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChangeValue) name:UITextFieldTextDidChangeNotification object:nil];
//    safeKB.inputSource = self.textField;
    [self addSubview:self.textField];
}

//- (void)textFieldChangeValue{
//    if (self.textField.text.length>6) {
//        self.textField.text = [self.textField.text substringToIndex:6];
//        return;
//    }
//    for (int i = 0; i< 6; i++) {
//        UIButton *button = [self viewWithTag:1000 + i];
//        if (button) {
//            if (i>=self.textField.text.length) {
//                [button setTitle:@"" forState:UIControlStateNormal];
//            }else{
//                [button setTitle:@"●" forState:UIControlStateNormal];
//            }
//        }
//    }
//}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length>6) {
        return NO;
    }
    NSLog(@"%ld",range.location);
    UIButton *button = [self viewWithTag:1000+range.location];
    if (button) {
        if ([string isEqualToString:@""]) {
            [button setTitle:@"" forState:UIControlStateNormal];
        }else{
            [button setTitle:@"●" forState:UIControlStateNormal];
        }
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(textHRPayFieldDidEndEditing:)]) {
        [self.delegate textHRPayFieldDidEndEditing:textField];
    }
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if ([self pointInside:point withEvent:event]) {
        NSLog(@"hitTest:ContainsPoint");
        return [super hitTest:point withEvent:event];
    }else{
        NSLog(@"hitTest:NotContainsPoint");
        [self endEditing:YES];
        return nil;
    }
}
- (void)clearPassWord{
    for (NSInteger i=0; i <6; i++) {
        UIButton *btnTmp=(UIButton *)[self viewWithTag:1000+i];
        [btnTmp setTitle:@"" forState:UIControlStateNormal];
    }
    self.textField.text = @"";
}
@end

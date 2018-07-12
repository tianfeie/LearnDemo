//
//  HRPayTextField.h
//  LearnDemo
//
//  Created by tianfei on 2018/7/12.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HRPayTextFieldDelegate <NSObject>
- (void)textHRPayFieldDidEndEditing:(UITextField *)textField;
@end
@interface HRPayTextField : UIView
@property (nonatomic, weak) id<HRPayTextFieldDelegate>delegate;
- (void)clearPassWord;
@end

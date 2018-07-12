//
//  CKKeyboard.h
//  CKKeyboard
//
//  Created by rck on 2018/3/27.
//  Copyright © 2018年 rck. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    
    CKBTypeNumberPad = 1 << 0,  // 纯数字
    CKBTypeDecimalPad = 1 << 1,  // 动态纯数字
    CKBTypeASCIICapable = 1 << 2  // ASCII 码
    
} CKBType;



@interface CKKeyboard : UIView


/**
 键盘类型
 */
@property (nonatomic, assign, readonly) CKBType type;


/*!
 *  @brief such as UITextField,UITextView,UISearchBar
 */
@property (nonatomic, nullable, weak) UIView *inputSource;



/**
 创建实例对象
 
 @param type 键盘类型  NS_DESIGNATED_INITIALIZER
 @return 返回实例
 */
- (nonnull instancetype)initWithType:(CKBType)type;

@end

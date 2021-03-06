//
//  HRNomalMacro.h
//  LearnDemo
//
//  Created by tianfei on 2018/9/19.
//  Copyright © 2018年 huarong. All rights reserved.
//

#ifndef HRNomalMacro_h
#define HRNomalMacro_h

#define HRNavBarColor (HRColorFromRGB(0xce2c2c))        // 导航栏颜色
#define HRMainWordColor (HRColorFromRGB(0x333333))      // 主要文字颜色
#define HRSubWordColor (HRColorFromRGB(0x666666))       // 次要文字颜色
#define HRHintWordColor (HRColorFromRGB(0x999999))      // 提示文字颜色
#define HRRedColor (HRColorFromRGB(0xe1393b))           // 内容中的红色
#define HRBlueColor   (HRColorFromRGB(0x0075ff))          // 蓝色
#define HROrangeColor   (HRColorFromRGB(0xec9107))      // 橙色

#define HRSeparatorColor (HRColorFromRGB(0xeeeeee))     // 分割线颜色
#define HRBackgroundColor (HRColorFromRGB(0xf5f5f5))    // 背景颜色

#define HRHintInfoColor   (HRColorFromRGB(0xd4393a))    // 提示信息的红色
#define HRShadowColor   (HRColorFromRGB(0xf0f0f0))      // 阴影颜色

/************************************ Size ********************************************/
#define HRSCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define HRSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define HRAdaptiveWidthValue(value) (((value)/375.0f)*[UIScreen mainScreen].bounds.size.width)
#define HRAdaptiveHeightValue(value) (((value)/667.0f)*[UIScreen mainScreen].bounds.size.height)

#define HR_NAVIGATIONBAR_HEIGHT (iPhoneX?88:64)     // 导航栏高度
#define HR_TABBARBAR_HEIGHT (iPhoneX?83:49)         // tabbar 高度
#define HR_IPHONE_HOME_HEIGHT (iPhoneX?34:0)        // iPhone X home高度

/************************************ Size ********************************************/


/*********************************** Color ********************************************/

// 设置随机颜色
#define HRRandomColor [UIColor colorWitTFed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

// 设置RGB颜色/设置RGBA颜色
#define HRRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HRRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

// rgb颜色转换（16进制->10进制）
#define HRColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HRColorFromRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
/**
 *    @brief    系统字体.
 */
#define HRSysFontOfSize(_size) [UIFont systemFontOfSize:_size]

/**
 *  @brief  加粗系统字体.
 */
#define HRBoldSysFontOfSize(_size) [UIFont boldSystemFontOfSize:_size]
/***********************************Color********************************************/
// 判断是否为 iPhone 4/4s
#define iPhone4s ((HRSCREEN_WIDTH == 320.0f) && (HRSCREEN_HEIGHT == 480.0f))

// 判断是否为 iPhone 5/5s/SE
#define iPhone5_SE ((HRSCREEN_WIDTH == 320.0f) && (HRSCREEN_HEIGHT == 568.0f))

// 判断是否为iPhone 6/6s/7/8
#define iPhone6_7_8 ((HRSCREEN_WIDTH == 375.0f) && (HRSCREEN_HEIGHT == 667.0f))

// 判断是否为iPhone 6Plus/6sPlus/7Plus/8Plus
#define iPhone6P_7P_8P ((HRSCREEN_WIDTH == 414.0f) && (HRSCREEN_HEIGHT == 736.0f))

// 判断是否 iPhone X
#define iPhoneX ((CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame])==44.0f?YES:NO))


// 获取系统版本
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

/***********************************Empty********************************************/

// 判断字符串是否为空
#define HRStringIsEmpty(str) ((!str || [str isKindOfClass:[NSNull class]] || ([str length] < 1))? YES:NO)

// 判断数组是否为空
#define HRArrayIsEmpty(array) ((!array || [array isKindOfClass:[NSNull class]] || (array.count == 0))? YES:NO)

// 判断字典是否为空
#define HRDictIsEmpty(dic) ((!dic || [dic isKindOfClass:[NSNull class]] || (dic.allKeys.count == 0))? YES:NO)

#define HRSafeString(str)((!str || [str isKindOfClass:[NSNull class]] || ([str length] < 1))? @"":str)
/**
 *  定义弱引用
 */
#define HRWeakSelf  __weak typeof(self) weakSelf = self;
//5.自定义 NSLog
#ifdef DEBUG
#define HRLog(format, ...) printf("class: <%p %s:(%d 行) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define HRLog(...)
#endif

#endif /* HRNomalMacro_h */

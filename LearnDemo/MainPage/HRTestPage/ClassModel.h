//
//  ClassModel.h
//  LearnDemo
//
//  Created by tianfei on 2018/10/8.
//  Copyright © 2018年 huarong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassModel : NSObject
@property (nonatomic, copy) NSString *className;
@property (nonatomic, strong) NSArray *studentModels;
@end

NS_ASSUME_NONNULL_END

//
//  MJExtensionConfig.m
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/25.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import "MJExtensionConfig.h"
#import <MJExtension.h>
#import "MJTopic.h"

@implementation MJExtensionConfig

/**
 *  @author Mooney.Wang, 16-05-25 14:05:19
 *
 *  这个方法会在MJExtensionConfig类加载进内存的时候调用一次
 */
+ (void)load {
    // MJTopic中的ID属性对应着字典中的id,desc属性对应着字典中的description
    [MJTopic mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 @"desc" : @"description"
                 };
    }];
}

@end

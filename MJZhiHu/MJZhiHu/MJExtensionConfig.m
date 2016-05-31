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
#import "MJStory.h"
#import "MJDailyStory.h"
#import "MJLatestStory.h"

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
    
    // MJStory中的ID属性对应着字典中的id
    [MJStory mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 @"desc" : @"description"
                 };
    }];
    
    // MJDailyStory中的stories数组中存放MJStory模型
    [MJDailyStory mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"stories" : @"MJStory"
                 };
    }];
    
    // MJLatestStory中的top_stories数组中存放MJStory模型
    [MJLatestStory mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"top_stories" : @"MJStory"};
    }];
}

@end

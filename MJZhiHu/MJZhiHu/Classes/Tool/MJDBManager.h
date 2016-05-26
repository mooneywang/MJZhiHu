//
//  MJDBManager.h
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/26.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MJTopic;

@interface MJDBManager : NSObject

+ (instancetype)sharedManager;

/**  将专题插入topics表*/
- (void)insertIntoTopics:(MJTopic *)topic;

/**  查询topics表，返回所有专题*/
- (NSArray *)searchAllTopics;

@end

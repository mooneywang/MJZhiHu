//
//  MJTopic.h
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/25.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJTopic : NSObject

/** 专题id */
@property (nonatomic, assign) NSUInteger ID;

/** 专题名称 */
@property (nonatomic, copy) NSString *name;

/** 专题配图 */
@property (nonatomic, copy) NSString *thumbnail;

/** 专题描述 */
@property (nonatomic, copy) NSString *desc;

/** 是否被关注 */
@property (nonatomic, assign) BOOL isFollowed;

@end

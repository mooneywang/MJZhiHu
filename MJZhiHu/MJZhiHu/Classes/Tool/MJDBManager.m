//
//  MJDBManager.m
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/26.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import "MJDBManager.h"
#import <FMDatabase.h>
#import "MJTopic.h"

@implementation MJDBManager{
    FMDatabase *_database;
}

+ (instancetype)sharedManager {
    static MJDBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MJDBManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        // 创建数据库的路径
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"zhihu.sqlite"];
        NSLog(@"path:%@",path);
        // 创建数据库
        _database = [[FMDatabase alloc] initWithPath:path];
        // 打开数据库
        if ([_database open] == NO) NSLog(@"数据库打开失败");
        // 数据库打开成功，创建topics表(存放专题信息)
        NSString *createTopicTableSql = @"CREATE TABLE IF NOT EXISTS topics (id INTEGER PRIMARY KEY AUTOINCREMENT,name VARCHAR(50),thumbnail CHAR(200),desc VARCHAR(1000),isFollowed BOOL)";
        [_database executeUpdate:createTopicTableSql];
    }
    return self;
}

- (void)insertIntoTopics:(MJTopic *)topic {
    NSString *insertSql = @"INSERT INTO topics (name,thumbnail,desc,isFollowed) values (?,?,?,?)";
    [_database executeUpdate:insertSql,topic.name,topic.thumbnail,topic.desc,@(topic.isFollowed)];
}

- (NSArray *)searchAllTopics {
    NSString *selectedSql = @"SELECT * FROM topics";
    FMResultSet *rs = [_database executeQuery:selectedSql];
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        MJTopic *topic = [[MJTopic alloc] init];
        topic.name = [rs stringForColumn:@"name"];
        topic.thumbnail = [rs stringForColumn:@"thumbnail"];
        topic.desc = [rs stringForColumn:@"desc"];
        topic.isFollowed = [rs intForColumn:@"isFollowed"];
        [array addObject:topic];
    }
    return array;
}

@end

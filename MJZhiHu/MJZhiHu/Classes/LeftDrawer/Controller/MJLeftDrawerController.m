//
//  MJLeftDrawerController.m
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/18.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import "MJLeftDrawerController.h"
#import "MJTopic.h"
#import "MJTopicCell.h"
#import <AFHTTPSessionManager.h>
#import <MJExtension.h>
#import "MJDBManager.h"

@interface MJLeftDrawerController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** tableView的数据源 */
@property (nonatomic, strong) NSMutableArray *topics;

@end

@implementation MJLeftDrawerController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}

#pragma mark - private methods

- (void)setupTableView {
    self.tableView.backgroundColor = kLeftDrawerThemeColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - tableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topics.count;
}

- (MJTopicCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJTopic *topic = self.topics[indexPath.row];
    MJTopicCell *cell = [MJTopicCell topicCellWithTableView:tableView];
    cell.topic = topic;
    return cell;
}

#pragma mark - getter & setter

- (NSMutableArray *)topics {
    if (!_topics) {
        _topics = [NSMutableArray array];
        // 先从数据库取
        MJDBManager *dbManager = [MJDBManager sharedManager];
        [_topics addObjectsFromArray:[dbManager searchAllTopics]];
        if (_topics.count == 0) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:GET_TOPIC_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                _topics = [MJTopic mj_objectArrayWithKeyValuesArray:responseObject[@"others"]];
                MJTopic *topic = [[MJTopic alloc] init];
                topic.name = @"首页";
                topic.isFollowed = YES;
                [_topics insertObject:topic atIndex:0];
                [self.tableView reloadData];
                // 将topics存入数据库
                for (MJTopic *topic in _topics) {
                    [dbManager insertIntoTopics:topic];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
    }
    return _topics;
}

@end

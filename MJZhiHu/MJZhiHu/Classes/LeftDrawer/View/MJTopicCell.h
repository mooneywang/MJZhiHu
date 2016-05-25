//
//  MJTopicCell.h
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/25.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJTopic;

@interface MJTopicCell : UITableViewCell

@property (nonatomic, strong) MJTopic *topic;

+ (instancetype)topicCellWithTableView:(UITableView *)tableView;

@end

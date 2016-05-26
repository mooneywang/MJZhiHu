//
//  MJTopicCell.h
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/25.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJTopic;
@class MJTopicCell;

@protocol MJTopicCellDelegate <NSObject>

@optional
- (void)topicCellDidClickAccessoryButton:(MJTopicCell *)topicCell;

@end

@interface MJTopicCell : UITableViewCell

@property (nonatomic, strong) MJTopic *topic;

@property (nonatomic, weak) id<MJTopicCellDelegate> delegate;

+ (instancetype)topicCellWithTableView:(UITableView *)tableView;

@end

//
//  MJStoryCell.h
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/30.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJStory;

@interface MJStoryCell : UITableViewCell

@property (nonatomic, strong) MJStory *story;

+ (instancetype)storyCellWithTableView:(UITableView *)tableView;

@end

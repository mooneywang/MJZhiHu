//
//  MJTopicCell.m
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/25.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import "MJTopicCell.h"
#import "MJTopic.h"
#import <FrameAccessor.h>

@interface MJTopicCell ()

@property (nonatomic, strong) UIButton *accessoryBtn;

@end

@implementation MJTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)topicCellWithTableView:(UITableView *)tableView {
    static NSString *topicCellReuseId = @"topicCellReuseId";
    MJTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:topicCellReuseId];
    if (!cell) {
        cell = [[MJTopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topicCellReuseId];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = kLeftDrawerThemeColor;
        UIButton *accessoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        accessoryBtn.width = 15;
        accessoryBtn.height = 18;
        [accessoryBtn setBackgroundImage:[UIImage imageNamed:@"Menu_Enter"] forState:UIControlStateDisabled];
        [accessoryBtn setBackgroundImage:[UIImage imageNamed:@"Menu_Follow"] forState:UIControlStateNormal];
        cell.accessoryView = accessoryBtn;
    }
    return cell;
}

- (void)setTopic:(MJTopic *)topic {
    _topic = topic;
    self.textLabel.text = topic.name;
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = MJColor(21, 26, 31, 1);
}

- (UIButton *)accessoryBtn {
    if (!_accessoryBtn) {
        
    }
    return _accessoryBtn;
}

@end

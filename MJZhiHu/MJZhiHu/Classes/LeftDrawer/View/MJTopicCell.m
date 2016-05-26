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
        cell.accessoryView = cell.accessoryBtn;
    }
    return cell;
}

- (void)setTopic:(MJTopic *)topic {
    _topic = topic;
    self.textLabel.text = topic.name;
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = MJColor(21, 26, 31, 1);
    self.accessoryBtn.enabled = !topic.isFollowed;
}

- (UIButton *)accessoryBtn {
    if (!_accessoryBtn) {
        _accessoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _accessoryBtn.width = 15;
        _accessoryBtn.height = 18;
        [_accessoryBtn addTarget:self action:@selector(accessoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_accessoryBtn setBackgroundImage:[UIImage imageNamed:@"Menu_Enter"] forState:UIControlStateDisabled];
        [_accessoryBtn setBackgroundImage:[UIImage imageNamed:@"Menu_Follow"] forState:UIControlStateNormal];
    }
    return _accessoryBtn;
}

- (void)accessoryBtnClick {
    NSLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(topicCellDidClickAccessoryButton:)]) {
        [self.delegate topicCellDidClickAccessoryButton:self];
    }
}

@end

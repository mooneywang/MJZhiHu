//
//  MJStoryCell.m
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/30.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import "MJStoryCell.h"
#import "MJStory.h"
#import <UIImageView+WebCache.h>

@interface MJStoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UIImageView *multiPicView;

@end

@implementation MJStoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)storyCellWithTableView:(UITableView *)tableView {
    static NSString *storyCellReuseId = @"storyCellReuseId";
    MJStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:storyCellReuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MJStoryCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setStory:(MJStory *)story {
    _story = story;
    self.contentLabel.text = story.title;
    if (story.images.count > 0) {
        [self.pictureView sd_setImageWithURL:[NSURL URLWithString:[story.images firstObject]]];
    }
    self.multiPicView.hidden = !story.multipic;
}

@end

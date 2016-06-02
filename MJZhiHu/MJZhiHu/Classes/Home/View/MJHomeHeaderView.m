//
//  MJHomeHeaderView.m
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/31.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import "MJHomeHeaderView.h"

@interface MJHomeHeaderView ()

@property (nonatomic, weak) UILabel *dateLabel;

@end

@implementation MJHomeHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kNavBarThemeColor;
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView {
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont boldSystemFontOfSize:15];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:dateLabel];
    _dateLabel = dateLabel;
}

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    static NSString *headerVeiwReuseId = @"headerVeiwReuseId";
    MJHomeHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerVeiwReuseId];
    if (!headerView) {
        headerView = [[MJHomeHeaderView alloc] initWithReuseIdentifier:headerVeiwReuseId];
    }
    return headerView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dateLabel.frame = self.bounds;
}

- (void)setDate:(NSString *)date {
    _date = date;
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    [dateF setDateFormat:@"yyyyMMdd"];
    NSDate *pertDate = [dateF dateFromString:date];
    [dateF setDateFormat:@"MM月dd日 EEEE"];
    [dateF setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    self.dateLabel.text = [dateF stringFromDate:pertDate];
}

@end

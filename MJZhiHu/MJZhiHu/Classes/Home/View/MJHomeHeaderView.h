//
//  MJHomeHeaderView.h
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/31.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJHomeHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *date;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@end

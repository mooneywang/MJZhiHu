//
//  MJHomeController.m
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/18.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import "MJHomeController.h"
#import "MJDrawerController.h"
#import "MJDBManager.h"
#import <Masonry.h>
#import "MJRefreshCycle.h"

#define kLeftButtonW       (kTopBarH - kStatusBarH)
#define kLeftButtonH       (kLeftButtonW)
#define kRefreshCycleW     (20)
#define kRefreshCycleH     (kRefreshCycleW)
#define kPicturesViewH     (220)

@interface MJHomeController ()

@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UIView *picturesView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIButton *leftButton;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) MJRefreshCycle *refreshCycle;

@end

@implementation MJHomeController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavigationBar];
    [self setupTableView];
    [self setupPicturesView];
    [self setupHeaderView];
    [self setupLeftButton];
    [self setupTitleLabel];
    [self setupRefreshCycle];
}

#pragma mark - private methods

- (void)setupNavigationBar {
    self.navigationController.navigationBarHidden = YES;
}

- (void)didClickLeftButton:(UIButton *)sender {
    [kNotificationCenter postNotificationName:kToggleLeftDrawer object:nil];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kPicturesViewH)];
    tableHeaderView.backgroundColor = [UIColor brownColor];
    tableView.tableHeaderView = tableHeaderView;
    [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    _tableView = tableView;
}

- (void)setupPicturesView {
    UIView *picturesView = [[UIView alloc] init];
    picturesView.backgroundColor = [UIColor redColor];
    [self.view addSubview:picturesView];
    [picturesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.height.equalTo(@kPicturesViewH);
    }];
    _picturesView = picturesView;
}

- (void)setupHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, kScreenW, kTopBarH);
    headerView.backgroundColor = kNavBarThemeColor;
    headerView.alpha = 0;
    [self.view addSubview:headerView];
    _headerView = headerView;
}

- (void)setupLeftButton {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"Home_Icon"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(10, 20, kLeftButtonW, kLeftButtonH);
    [leftButton addTarget:self action:@selector(didClickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    _leftButton = leftButton;
}

- (void)setupTitleLabel {
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.view addSubview:titleLabel];
    titleLabel.text = @"今日要闻";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [titleLabel sizeToFit];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.leftButton.mas_centerY);
    }];
    _titleLabel = titleLabel;
}

- (void)setupRefreshCycle {
    MJRefreshCycle *refreshCycle = [[MJRefreshCycle alloc] init];
    refreshCycle.backgroundColor = [UIColor clearColor];
    [self.view addSubview:refreshCycle];
    [refreshCycle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftButton.mas_centerY);
        make.width.equalTo(@(kRefreshCycleW));
        make.height.equalTo(@(kRefreshCycleH));
        make.right.equalTo(self.titleLabel.mas_left).offset(-5);
    }];
    _refreshCycle = refreshCycle;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    MJDrawerController *drawerController = (MJDrawerController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if (drawerController.isOpen) {
        [kNotificationCenter postNotificationName:kToggleLeftDrawer object:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.tableView && [keyPath isEqualToString:@"contentOffset"]) {
        CGFloat yOffset = self.tableView.contentOffset.y;
        [self.picturesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(kPicturesViewH - yOffset));
        }];
        // 改变导航条的透明度（0 ～ 1）
        self.headerView.alpha = yOffset / (kPicturesViewH - kTopBarH);
        // 改变MJRefreshCycle的radius(0 ~ 2PI)
        self.refreshCycle.angle = ABS(yOffset)/(kTopBarH) * M_PI * 2;
    }
}

@end

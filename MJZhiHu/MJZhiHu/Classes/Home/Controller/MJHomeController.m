//
//  MJHomeController.m
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/18.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import "MJHomeController.h"

#define kNavBarHeight          (56)
#define kLeftButtonWidth       (kNavBarHeight - 20)
#define kLeftButtonHeight      (kLeftButtonWidth)

@interface MJHomeController ()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UIButton *leftButton;

@end

@implementation MJHomeController

#pragma mark - getter & setter

- (UIView *)headerView {
    if (!_headerView) {
        UIView *headerView = [[UIView alloc] init];
        headerView.frame = CGRectMake(0, 0, kScreenW, kNavBarHeight);
        headerView.backgroundColor = [UIColor colorWithRed:23/255.0 green:144/255.0 blue:211/255.0 alpha:1];
        [self.view addSubview:headerView];
        _headerView = headerView;
    }
    return _headerView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setImage:[UIImage imageNamed:@"Home_Icon"] forState:UIControlStateNormal];
        leftButton.frame = CGRectMake(10, 20, kLeftButtonWidth, kLeftButtonHeight);
        [leftButton addTarget:self action:@selector(didClickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:leftButton];
        _leftButton = leftButton;
    }
    return _leftButton;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];
    [self headerView];
    [self leftButton];
    [self setupTableView];
}

- (void)dealloc {
    NSLog(@"MJHomeController 被销毁了");
}

#pragma mark - private methods

- (void)setupNavigationBar {
    self.navigationController.navigationBarHidden = YES;
}

- (void)didClickLeftButton:(UIButton *)sender {
    [kNotificationCenter postNotificationName:kToggleLeftDrawer object:nil];
}

- (void)setupTableView {
    
}

@end

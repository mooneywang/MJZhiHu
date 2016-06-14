//
//  MJHomeController.m
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/18.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import "MJDBManager.h"
#import "MJDailyStory.h"
#import "MJDrawerController.h"
#import "MJHomeController.h"
#import "MJHomeHeaderView.h"
#import "MJLatestStory.h"
#import "MJPicturesView.h"
#import "MJRefreshCycle.h"
#import "MJStory.h"
#import "MJStoryCell.h"
#import "NSDate+Extension.h"
#import <AFHTTPSessionManager.h>
#import <FrameAccessor.h>
#import <MJExtension.h>
#import <Masonry.h>

#define kLeftButtonW (kTopBarH - kStatusBarH)
#define kLeftButtonH (kLeftButtonW)
#define kRefreshCycleW (20)
#define kRefreshCycleH (kRefreshCycleW)
#define kPicturesViewH (220)

@interface MJHomeController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) UIView *headerView;
@property(nonatomic, weak) MJPicturesView *picturesView;
@property(nonatomic, weak) UITableView *tableView;
@property(nonatomic, weak) UIButton *leftButton;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) MJRefreshCycle *refreshCycle;

/** 循环滚动新闻（5条）*/
@property(nonatomic, strong) NSArray *topStories;
/** 新闻组*/
@property(nonatomic, strong) NSMutableArray *storyGroup;

@end

@implementation MJHomeController

#pragma mark - life cycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  self.automaticallyAdjustsScrollViewInsets = NO;
  [self setupNavigationBar];
  [self setupTableView];
  [self setupPicturesView];
  [self setupHeaderView];
  [self setupLeftButton];
  [self setupTitleLabel];
  [self setupRefreshCycle];
  [self loadData];
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
    make.top.equalTo(self.view.mas_top).offset(20);
    make.leading.equalTo(self.view.mas_leading);
    make.trailing.equalTo(self.view.mas_trailing);
    make.bottom.equalTo(self.view.mas_bottom);
  }];
  UIView *tableHeaderView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, kScreenW, kPicturesViewH - 20)];
  tableHeaderView.backgroundColor = [UIColor whiteColor];
  tableView.tableHeaderView = tableHeaderView;
  tableView.dataSource = self;
  tableView.delegate = self;
  tableView.rowHeight = 80;
  [tableView addObserver:self
              forKeyPath:@"contentOffset"
                 options:NSKeyValueObservingOptionNew
                 context:nil];
  _tableView = tableView;
}

- (void)setupPicturesView {
  MJPicturesView *picturesView = [[MJPicturesView alloc] init];
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
  [leftButton setImage:[UIImage imageNamed:@"Home_Icon"]
              forState:UIControlStateNormal];
  leftButton.frame = CGRectMake(10, 20, kLeftButtonW, kLeftButtonH);
  [leftButton addTarget:self
                 action:@selector(didClickLeftButton:)
       forControlEvents:UIControlEventTouchUpInside];
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
  MJDrawerController *drawerController =
      (MJDrawerController *)[UIApplication sharedApplication]
          .keyWindow.rootViewController;
  if (drawerController.isOpen) {
    [kNotificationCenter postNotificationName:kToggleLeftDrawer object:nil];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context {
  if (object == self.tableView && [keyPath isEqualToString:@"contentOffset"]) {
    CGFloat yOffset = self.tableView.contentOffset.y;
    [self.picturesView mas_updateConstraints:^(MASConstraintMaker *make) {
      make.height.equalTo(@(kPicturesViewH - yOffset));
    }];
    // 改变导航条的透明度（0 ～ 1）
    self.headerView.alpha = yOffset / (kPicturesViewH - kTopBarH);
    // 如果向下拉，改变MJRefreshCycle的radius(0 ~ 2PI)
    if (yOffset <= 0) {
      self.refreshCycle.angle = ABS(yOffset) / (kTopBarH)*M_PI * 2;
    }
  }
}

- (void)loadData {
  [self.refreshCycle beginRefresh];
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  [manager GET:GET_LATEST_NEWS
      parameters:nil
      progress:nil
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nullable responseObject) {
        MJLatestStory *latestStory =
            [MJLatestStory mj_objectWithKeyValues:responseObject];
        _topStories = latestStory.top_stories;
        self.picturesView.topStories = _topStories;
        if (_storyGroup.count > 0) {
          // 清空数组
          [self.storyGroup removeAllObjects];
        }
        [self.storyGroup insertObject:latestStory atIndex:0];
        [self.tableView reloadData];
        [self.refreshCycle endRefresh];
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error){

      }];
}

- (void)loadMoreData {
  // 取出最后一组数据的日期拼接url
  MJDailyStory *dailyStory = [self.storyGroup lastObject];
  NSString *dailyUrl =
      [NSString stringWithFormat:GET_DAILY_NEWS, dailyStory.date];
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  [manager GET:dailyUrl
      parameters:nil
      progress:nil
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nullable responseObject) {
        MJDailyStory *dailyStory =
            [MJDailyStory mj_objectWithKeyValues:responseObject];
        [self.storyGroup addObject:dailyStory];
        [self.tableView reloadData];
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error){

      }];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
  if (scrollView.contentOffset.y <= -kTopBarH) {
    [self loadData];
  }
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.storyGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  MJDailyStory *dailyStory = (MJDailyStory *)self.storyGroup[section];
  return dailyStory.stories.count;
}

- (MJStoryCell *)tableView:(UITableView *)tableView
     cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MJStoryCell *cell = [MJStoryCell storyCellWithTableView:tableView];
  // 获取数据模型
  MJDailyStory *dailyStory = (MJDailyStory *)self.storyGroup[indexPath.section];
  MJStory *story = dailyStory.stories[indexPath.row];
  cell.story = story;
  return cell;
}

#pragma mark - Table View Delegate

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  MJHomeHeaderView *headerView =
      [MJHomeHeaderView headerViewWithTableView:tableView];
  MJDailyStory *dailyStory = (MJDailyStory *)self.storyGroup[section];
  headerView.date = dailyStory.date;
  return section ? headerView : nil;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return section ? 36 : CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView
    willDisplayHeaderView:(UIView *)view
               forSection:(NSInteger)section {
  if (section == 0) {
    self.headerView.height = kTopBarH;
    self.titleLabel.alpha = 1;
  }
  // 当显示最后一组的组头的时候要加载下一组
  if (section == self.storyGroup.count - 1) {
    [self loadMoreData];
  }
}

- (void)tableView:(UITableView *)tableView
    didEndDisplayingHeaderView:(UIView *)view
                    forSection:(NSInteger)section {
  if (section == 0) {
    self.headerView.height = 20;
    self.titleLabel.alpha = 0;
  }
}

#pragma mark - getter & setter

- (NSMutableArray *)storyGroup {
  if (!_storyGroup) {
    _storyGroup = [NSMutableArray array];
  }
  return _storyGroup;
}

@end

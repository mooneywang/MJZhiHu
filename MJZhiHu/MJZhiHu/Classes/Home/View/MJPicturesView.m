//
//  MJPicturesView.m
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/27.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//  该图片轮播器利用3个UIImageView,实现了UIImageView的复用

#import "MJPicturesView.h"
#import <UIImageView+WebCache.h>
#import "MJStory.h"

#define kImageViewCount (3)

@interface MJPicturesView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *imageViewL;
@property (nonatomic, weak) UIImageView *imageViewC;
@property (nonatomic, weak) UIImageView *imageViewR;
@property (nonatomic, weak) UIPageControl *pageController;
// 当前图片索引
@property (nonatomic, assign) NSUInteger currentImageIndex;
// 图片总数
@property (nonatomic, assign) NSUInteger imageCount;

@end

@implementation MJPicturesView{
    NSTimer *_timer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initDefault];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initDefault];
    }
    return self;
}

- (void)initDefault {
    _currentImageIndex = 0;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    UIImageView *imageViewL = [[UIImageView alloc] init];
    imageViewL.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:imageViewL];
    _imageViewL = imageViewL;
    
    UIImageView *imageViewC = [[UIImageView alloc] init];
    imageViewC.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:imageViewC];
    _imageViewC = imageViewC;
    
    UIImageView *imageViewR = [[UIImageView alloc] init];
    imageViewR.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:imageViewR];
    _imageViewR = imageViewR;
    
    UIPageControl *pageController = [[UIPageControl alloc] init];
    [self addSubview:pageController];
    _pageController = pageController;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    // 垂直方向不需滚动直接设置为0
    self.scrollView.contentSize = CGSizeMake(kScreenW * kImageViewCount, 0);
    self.imageViewL.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.imageViewC.frame = CGRectMake(kScreenW, 0, self.bounds.size.width, self.bounds.size.height);
    self.imageViewR.frame = CGRectMake(kScreenW * 2, 0, self.bounds.size.width, self.bounds.size.height);
    self.pageController.center = CGPointMake(kScreenW * 0.5, self.bounds.size.height * 0.9);
}

- (void)setTopStories:(NSArray *)topStories {
    _topStories = topStories;
    _imageCount = topStories.count;
    // 滚动scrollView至中间（显示中间一个UIImageView）
    [self.scrollView setContentOffset:CGPointMake(kScreenW, 0) animated:YES];
    self.pageController.numberOfPages = _imageCount;
    // 设置最后一张、第一张以及第二张图片，分别对应左中右三个UIImageView
    MJStory *storyC = (MJStory *)topStories[0];
    [_imageViewC sd_setImageWithURL:[NSURL URLWithString:storyC.image]];
    MJStory *storyR = (MJStory *)topStories[1];
    [_imageViewR sd_setImageWithURL:[NSURL URLWithString:storyR.image]];
    MJStory *storyL = (MJStory *)topStories[_imageCount - 1];
    [_imageViewL sd_setImageWithURL:[NSURL URLWithString:storyL.image]];
    // 添加定时器
    [self addTimer];
}

-(void)reloadImage{
    NSUInteger leftImageIndex, rightImageIndex;
    CGPoint offset = [self.scrollView contentOffset];

    if (offset.x > kScreenW) { // 向右滑动
        _currentImageIndex = (_currentImageIndex + 1) % _imageCount;
    } else if (offset.x < kScreenW) { //　向左滑动
        _currentImageIndex = (_currentImageIndex + _imageCount -1) % _imageCount;
    }
    leftImageIndex = (_currentImageIndex + _imageCount-1) % _imageCount;
    rightImageIndex = (_currentImageIndex + 1) % _imageCount;
    MJStory *storyC = (MJStory *)_topStories[_currentImageIndex];
    [_imageViewC sd_setImageWithURL:[NSURL URLWithString:storyC.image]];
    MJStory *storyR = (MJStory *)_topStories[rightImageIndex];
    [_imageViewR sd_setImageWithURL:[NSURL URLWithString:storyR.image]];
    MJStory *storyL = (MJStory *)_topStories[leftImageIndex];
    [_imageViewL sd_setImageWithURL:[NSURL URLWithString:storyL.image]];
}

- (void)nextImage {
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSUInteger currentPage = _currentImageIndex;
    if (scrollView.contentOffset.x >= kScreenW * 1.5) {
        currentPage += 1;
    }else if (scrollView.contentOffset.x <= kScreenW * 0.5) {
        currentPage -= 1;
    }
    self.pageController.currentPage = currentPage;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //重新加载图片
    [self reloadImage];
    //移动到中间
    [_scrollView setContentOffset:CGPointMake(kScreenW, 0) animated:NO];
}

// 当手开始拖拽的时候移除定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

// 当手停止拖拽的时候添加定时器
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self addTimer];
}

#pragma mark - timer

- (void)addTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    // 将timer
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}

@end

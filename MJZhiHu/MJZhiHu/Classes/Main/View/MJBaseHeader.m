//
//  MJBaseHeader.m
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/6/6.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import "MJBaseHeader.h"
#import "MJRefreshCycle.h"
#import <Masonry.h>

@interface MJBaseHeader ()

@property (nonatomic, weak) UIButton *backButton;

@property (nonatomic, weak) UILabel *themeLabel;

@property (nonatomic, weak) UIButton *followButton;

@property (nonatomic, weak) UIImageView *backgroundImageView;

@property (nonatomic, weak) MJRefreshCycle *refreshCycle;

@end

@implementation MJBaseHeader

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initDefault];
        [self addSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initDefault];
        [self addSubViews];
    }
    return self;
}

- (void)initDefault {
    self.backgroundColor = kNavBarThemeColor;
}

- (void)addSubViews {
    // 背景图片
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    [self addSubview:backgroundImageView];
    _backgroundImageView = backgroundImageView;
    
    // 返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"Back_White"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    _backButton = backButton;
    
    // 标题Label
    UILabel *themeLabel = [[UILabel alloc] init];
    themeLabel.textAlignment = NSTextAlignmentCenter;
    themeLabel.font = [UIFont boldSystemFontOfSize:15];
    themeLabel.textColor = [UIColor whiteColor];
    [self addSubview:themeLabel];
    _themeLabel = themeLabel;
    
}

- (void)back {
    NSLog(@"%s",__func__);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // make top, left, bottom, right equal self
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

@end

//
//  MJDrawerController.m
//  MJDrawerController
//
//  Created by Mengjie.Wang on 16/5/24.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import "MJDrawerController.h"

@interface MJDrawerController ()

@end

@implementation MJDrawerController

#pragma mark - life cycle

- (instancetype)init {
    if ([super init]) {
        [self configDefault];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        [self configDefault];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self configDefault];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:self.centerController];
    [self.view addSubview:self.centerController.view];
    self.centerController.view.frame = self.view.bounds;
    
    if (_leftDrawerController) {
        [self addChildViewController:_leftDrawerController];
        [self.view addSubview:_leftDrawerController.view];
        _leftDrawerController.view.frame = CGRectMake(- _leftDrawerWidth, 0, _leftDrawerWidth, kScreenH);
    }
    
    [kNotificationCenter addObserver:self selector:@selector(showLeftDrawerWithAnimate:) name:kOpenLeftDrawer object:nil];
    [kNotificationCenter addObserver:self selector:@selector(closeLeftDrawerWithAnimate:) name:kCloseLeftDrawer object:nil];
    [kNotificationCenter addObserver:self selector:@selector(toggleDrawerWithAnimate:) name:kToggleLeftDrawer object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - getter & setter

- (UIViewController *)centerController {
    if (!_centerController) {
        _centerController = [[UIViewController alloc] init];
        _centerController.view.backgroundColor = [UIColor whiteColor];
    }
    return _centerController;
}

#pragma mark - private methods

- (void)configDefault {
    _isOpen = NO;
    _leftDrawerWidth = 200;
}

- (void)showLeftDrawerWithAnimate:(BOOL)animate {
    _isOpen = YES;
    [UIView animateWithDuration:1.0 animations:^{
        _centerController.view.frame = CGRectMake(_leftDrawerWidth, 0, kScreenW, kScreenH);
        _leftDrawerController.view.frame = CGRectMake(0, 0, _leftDrawerWidth, kScreenH);
    }];
}

- (void)closeLeftDrawerWithAnimate:(BOOL)animate {
    _isOpen = NO;
    [UIView animateWithDuration:1.0 animations:^{
        _centerController.view.frame = CGRectMake(0, 0, kScreenW, kScreenH);
        _leftDrawerController.view.frame = CGRectMake(- _leftDrawerWidth, 0, _leftDrawerWidth, kScreenH);
    }];
}

- (void)toggleDrawerWithAnimate:(BOOL)animate {
    if (_isOpen) {
        [self closeLeftDrawerWithAnimate:animate];
    }else {
        [self showLeftDrawerWithAnimate:animate];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

@end

//
//  MJMainViewController.m
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/18.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import "MJMainViewController.h"
#import "MJHomeController.h"
#import "MJLeftDrawerController.h"

@interface MJMainViewController ()

@end

@implementation MJMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置左侧可展开的最大宽度
    self.maximumLeftDrawerWidth = 200;
    self.shouldStretchDrawer = NO;
    self.showsShadow = YES;
    
    self.centerViewController = [[MJHomeController alloc] init];
    self.leftDrawerViewController = [[MJLeftDrawerController alloc] init];
    
    self.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.closeDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
}


@end

//
//  MJLaunchController.m
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/18.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import "MJLaunchController.h"
#import "MJDrawerController.h"
#import "MJHomeController.h"
#import "MJLeftDrawerController.h"
#import "MJNavigationController.h"
#import <UIImageView+WebCache.h>
#import <AFHTTPSessionManager.h>

#define LAUNCH_IMAGE_URL_KEY @"LAUNCH_IMAGE_URL_KEY"

@interface MJLaunchController ()

@property (nonatomic, strong) MJDrawerController *drawerController;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation MJLaunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *url = [kUserDefaults valueForKey:LAUNCH_IMAGE_URL_KEY];
    if (url) {
        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    }
    // 就算之前已经保存了url还要再获取一遍，保持最新
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:GET_LAUNCH_IMAGE_URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"downloadProgress:%@",downloadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        NSString *launchImageUrl = responseDict[@"img"];
        // 将launchImageUrl存起来
        [kUserDefaults setValue:launchImageUrl forKey:LAUNCH_IMAGE_URL_KEY];
        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:launchImageUrl]];
        
        [self changeRootViewController];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error:%@",error.localizedDescription);
        [self changeRootViewController];
        
    }];
}

- (void)dealloc {
    NSLog(@"MJLaunchController 被销毁了");
}

- (void)changeRootViewController {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2.0秒之后执行此处代码
        [UIView animateWithDuration:1.5 animations:^{
            // 放大
            self.backgroundImageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
            // 透明
            self.backgroundImageView.alpha = 0;
        } completion:^(BOOL finished) {
            [UIApplication sharedApplication].keyWindow.rootViewController = self.drawerController;
        }];
    });
}

- (MJDrawerController *)drawerController {
    if (!_drawerController) {
        _drawerController = [[MJDrawerController alloc] init];
        // 主视图控制器
        MJHomeController *homeController = [[MJHomeController alloc] init];
        MJNavigationController *homeNavController = [[MJNavigationController alloc] initWithRootViewController:homeController];
        _drawerController.centerController = homeNavController;
        // 左侧抽屉视图控制器
        MJLeftDrawerController *leftDrawerController = [[MJLeftDrawerController alloc] init];
        _drawerController.leftDrawerController = leftDrawerController;
    }
    return _drawerController;
}



@end

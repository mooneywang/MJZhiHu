//
//  MJDrawerController.h
//  MJDrawerController
//
//  Created by Mengjie.Wang on 16/5/24.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJDrawerController : UIViewController

@property (nonatomic, strong) UIViewController *centerController;
@property (nonatomic, strong) UIViewController *leftDrawerController;
// 抽屉控制器可打开的宽度
@property (nonatomic, assign) CGFloat leftDrawerWidth;
@property (nonatomic, assign) BOOL isOpen;

@end

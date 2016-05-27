//
//  MJRefreshCycle.m
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/27.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import "MJRefreshCycle.h"

@implementation MJRefreshCycle

- (void)drawRect:(CGRect)rect {
    // 设置圆心
    CGFloat centerX = rect.size.width * 0.5;
    CGFloat centerY = centerX;
    CGPoint centerPoint = CGPointMake(centerX, centerY);
    // 设置半径
    CGFloat radius = rect.size.width * 0.5 - 1;
    
    // 画一个灰色底圆
    UIBezierPath *grayPath = [[UIBezierPath alloc] init];
    [grayPath addArcWithCenter:centerPoint radius:radius startAngle:0 endAngle:((_angle == 0) ? 0 : (M_PI * 2)) clockwise:YES];
    grayPath.lineWidth = 2;
    [[UIColor grayColor] setStroke];
    [grayPath stroke];
    
    // 画动态的白色圆弧
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:centerPoint radius:radius startAngle:0 endAngle:_angle clockwise:YES];
    path.lineWidth = 2;
    path.lineCapStyle = kCGLineCapRound;
    [[UIColor whiteColor] setStroke];
    [path stroke];
}

- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    [self setNeedsDisplay];
}

@end

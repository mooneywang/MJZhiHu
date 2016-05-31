//
//  MJStory.h
//  MJZhiHu
//
//  Created by Mengjie.Wang on 16/5/27.
//  Copyright © 2016年 Mooney.Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJStory : NSObject

@property (nonatomic, assign) long long ID;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *ga_prefix;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) BOOL multipic;

@end

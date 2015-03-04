//
//  HXLoginViewController.h
//  Hxdd_exam
//
//  Created by  MAC on 14-8-25.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXCrudListRowResult.h"

@interface HXCrudListResult : NSObject<NSCoding>
/**
 * 返回数据条数
 */
@property(nonatomic)int count;
/**
 * 返回数据列表
 */
@property(nonatomic,strong)NSMutableArray * body;

-(id)init;

-(void)setBody:(NSMutableArray *)body;

@end

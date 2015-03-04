//
//  HXLoginViewController.h
//  Hxdd_exam
//
//  Created by  MAC on 14-8-25.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXCrudListRowResult : NSObject<NSCoding>

/**
 * 列表id
 */
@property(nonatomic,strong)NSString * Id;
/**
 * 返回数据列表
 */
@property(nonatomic,strong)NSMutableDictionary * columns;

-(id)init;

-(void)setMyColumns:(NSMutableArray *)columns;

@end

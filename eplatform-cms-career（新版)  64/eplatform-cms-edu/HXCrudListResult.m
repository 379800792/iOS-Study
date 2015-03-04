//
//  HXLoginViewController.h
//  Hxdd_exam
//
//  Created by  MAC on 14-8-25.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import "HXCrudListResult.h"

@implementation HXCrudListResult

-(id)init
{
    if (self = [super init]) {
        _count = 0;
        _body = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

-(void)setBody:(NSMutableArray *)body
{
    if (body == nil) {
        [_body removeAllObjects];
        return;
    }
    for (id obj in body) {
        HXCrudListRowResult * row = [[HXCrudListRowResult alloc]init];
        row.Id = [obj objectForKey:@"id"];
        [row setMyColumns:[obj objectForKey:@"columns"]];
        [_body addObject:row];
    }
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.count forKey:@"count"];
    [aCoder encodeObject:self.body forKey:@"body"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.count = [aDecoder decodeIntForKey:@"count"];
        _body = [aDecoder decodeObjectForKey:@"body"];
    }
    return self;
}
@end

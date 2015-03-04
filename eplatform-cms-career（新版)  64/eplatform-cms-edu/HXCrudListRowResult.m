//
//  HXLoginViewController.h
//  Hxdd_exam
//
//  Created by  MAC on 14-8-25.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import "HXCrudListRowResult.h"

@implementation HXCrudListRowResult

-(id)init
{
    if (self = [super init]) {
        _Id = 0;
        _columns = [[NSMutableDictionary alloc]initWithCapacity:8];
    }
    return self;
}

-(void)setMyColumns:(NSMutableArray *)columns
{
    for (id obj in columns) {
        [_columns setObject:[obj objectForKey:@"value"] forKey:[obj objectForKey:@"name"]];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.columns forKey:@"columns"];
    [aCoder encodeObject:self.Id forKey:@"Id"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.Id = [aDecoder decodeObjectForKey:@"Id"];
        _columns = [aDecoder decodeObjectForKey:@"columns"];
    }
    return self;
}
@end

//
//  hxTool.h
//  Hxdd_xlxb
//
//  Created by  MAC on 14-7-28.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

typedef void (^CompleteBlock_)(NSArray *array);
typedef void (^ErrorBlock_)(NSString *error);

@interface hxTool : NSObject<NSXMLParserDelegate>
+ (BOOL)isConnectionAvalible;
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;
+(NSArray *)rangesOfString:(NSString *)searchString inString:(NSString *)str;
+(NSString*)userNamePath;
+(NSString *)filterHTML:(NSString *)html;
@end

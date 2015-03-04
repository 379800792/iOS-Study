//
//  hxTool.m
//  Hxdd_xlxb
//
//  Created by  MAC on 14-7-28.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import "hxTool.h"
@implementation hxTool{
    CompleteBlock_ completeBlock_;
    ErrorBlock_ errorBlock_;
    NSMutableArray *_dataArray;
}
- (id)init{
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}
+(NSArray *)rangesOfString:(NSString *)searchString inString:(NSString *)str {
    
    
    
    NSMutableArray *results = [NSMutableArray array];
    
    
    
    NSRange searchRange = NSMakeRange(0, [str length]);
    
    
    
    NSRange range;
    
    
    
    while ((range = [str rangeOfString:searchString options:0 range:searchRange]).location != NSNotFound) {
        
        
        
        [results addObject:[NSString stringWithFormat:@"%d",range.location]];
        
        
        
        searchRange = NSMakeRange(NSMaxRange(range), [str length] - NSMaxRange(range));
        
        
        
    }
    
    
    
    return results;
    
    
    
}



+ (BOOL)isConnectionAvalible{
    BOOL isConnected = YES;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            isConnected = NO;
            break;
        case ReachableViaWWAN:
            isConnected = YES;
        case ReachableViaWiFi:
            isConnected = YES;
            break;
    }
    if (!isConnected) {
        NSLog(@"noNet!");
    }
    return isConnected;
}
//16进制颜色(html颜色值)字符串转为UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    html = [html stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"—"];
    html = [html stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    html = [html stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    html = [html stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    html = [html stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    html = [html stringByReplacingOccurrencesOfString:@"&copy;" withString:@"©"];
    html = [html stringByReplacingOccurrencesOfString:@"&reg;" withString:@"®"];
    html = [html stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
    html = [html stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
    html = [html stringByReplacingOccurrencesOfString:@"&hellip;" withString:@"..."];

    return html;
}




@end

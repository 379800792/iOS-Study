//
//  NewDetailViewController.h
//  eplatform-cms-edu
//
//  Created by Marble on 14/10/23.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"

@interface NewDetailViewController : UIViewController<UIWebViewDelegate,UMSocialUIDelegate>
@property (nonatomic,copy) NSString *NewsHtmlUrl;
@property (nonatomic,assign) BOOL isNavPushed;
@end

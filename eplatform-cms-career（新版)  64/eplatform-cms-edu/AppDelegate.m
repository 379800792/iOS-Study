//
//  AppDelegate.m
//  eplatform-cms-edu
//
//  Created by Marble on 14/10/22.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "ViewController.h"
#import "APService.h"
#import "NewDetailViewController.h"
#import "common.h"
#import "AFNetworking.h"
@interface AppDelegate (){
    NSString *_newVersionURlString;
    CustomIOS7AlertView *_myAlertView;

}


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.rootViewController = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    self.window.rootViewController = _rootViewController;
    [self setUMSocial];
    [self checkAppUpdate];
    //测试下git 再次测试

#if 0
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
#endif
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    [self showNewsDetailViewController:remoteNotification];
    NSLog(@"%@",remoteNotification);
    return YES;
}
- (void)setUMSocial{
    [UMSocialData setAppKey:@"53df1315fd98c5bd8d000520"];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    [UMSocialWechatHandler setWXAppId:@"wx332a053db497d6bf" appSecret:@"d1100788880642163cd3ae3c99003c61" url:@"http://sns.whalecloud.com/tencent2/callback"];
    [UMSocialQQHandler setQQWithAppId:@"1103447169" appKey:@"HUk9EeAArHSq4nXz" url:@"http://sns.whalecloud.com/tencent2/callback"];
}
#if 0
//极光推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}
// ios8 用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得自定义字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"newsId"]; //自定义参数，key是自己定义的
    NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field =[%@]",content,badge,sound,customizeField1);
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

#ifdef __IPHONE_7_0


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"this is iOS7 Remote Notification");
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得自定义字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"newsId"]; //自定义参数，key是自己定义的
    NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field =[%@]",content,badge,sound,customizeField1);
    
    [self showNewsDetailViewController:userInfo];
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
#endif

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#endif

// 接受推送过来的新闻id 弹出新闻详情

-(void)showNewsDetailViewController:(NSDictionary*)userInfo{
    
    NSString *strNewsID = [userInfo valueForKey:@"newsId"];
    
    if (strNewsID == nil) {
        return;
    }

    NewDetailViewController *newDetail = [[NewDetailViewController alloc] init];
    newDetail.isNavPushed = NO;
    newDetail.NewsHtmlUrl = [NSString stringWithFormat:@"http://m.edu-edu.com.cn/career/editor/_detail/article_%@/index.html",strNewsID];
    UINavigationController *tempNavController = [[UINavigationController alloc] initWithRootViewController:newDetail];
    
    [self.rootViewController presentViewController:tempNavController
                                          animated:YES
                                        completion:^(void) {
                                            
                                        }];

}


//构建提示框内容view
- (UIView *)createViewWith:(NSString *)versionNum andWithFeatures:(NSString *)featureStr AndWithFeatureCount:(NSInteger)count{
    
    //构建alertView 上的view
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 290, 150)];
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 290, 30)];
    titleLabel.text = @"提示";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    [contentView addSubview:titleLabel];
    //副标题
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, GetNeedFrame_Y_From(titleLabel), 290, 25)];
    contentLabel.text = [NSString stringWithFormat:@"最新版本为%@,是否更新？",versionNum];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:contentLabel];
    //更新详细
    
    UILabel *featureLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, GetNeedFrame_Y_From(contentLabel)-5, 270, 25*count)];
    featureLabel.numberOfLines = 0;
    featureLabel.textAlignment = NSTextAlignmentLeft;
    featureLabel.font = [UIFont systemFontOfSize:14];
    featureLabel.lineBreakMode = NSLineBreakByCharWrapping;
    featureLabel.text = featureStr;
    [contentView addSubview:featureLabel];
    
    [contentView setFrame:CGRectMake(0, 0, 290, 30+25+25*count)];
    return contentView;
}


//检测新版本

-(void)checkAppUpdate
{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    _myAlertView = [[CustomIOS7AlertView alloc]init];
    [_myAlertView setButtonTitles:[NSMutableArray arrayWithObjects:@"暂不",@"立即更新",nil]];
    [_myAlertView setUseMotionEffects:true];
    [manager GET:APP_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
#if IS_Enterprise_App
        
        //企业版下载更新
        NSDictionary * rightDic = responseObject;
        NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
        NSString *localVersion =[localDic objectForKey:@"CFBundleVersion"];
        NSString * newVersion = [rightDic objectForKey:@"version"];
        
        NSString * newVersionLabel = [rightDic objectForKey:@"versionLabel"];
        
        NSArray *features = [rightDic objectForKey:@"features"];
        NSMutableString *featureStr = [[NSMutableString alloc]init];
        for (int i = 0 ; i < features.count; i++) {
            NSString *str = [features  objectAtIndex:i];
            if (i == 0) {
                [featureStr appendString:[NSString stringWithFormat:@"%d、%@",i+1,str]];
                
            }else{
                [featureStr appendString:[NSString stringWithFormat:@"\n%d、%@",i+1,str]];
                
            }
        }
        NSLog(@"%@",featureStr);
        
        if ([newVersion doubleValue] > [localVersion doubleValue]) {
            _newVersionURlString = [rightDic objectForKey:@"updateUrl"];
            
            _myAlertView.containerView =[self createViewWith:newVersionLabel andWithFeatures:featureStr AndWithFeatureCount:features.count];
            
            [_myAlertView show];
            
            __weak NSString *updateStr = _newVersionURlString ;
            
            [_myAlertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
                if (buttonIndex == 0)
                {
                    [alertView close];
                }else{
                    if(updateStr)
                    {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateStr]];
                        [alertView close];
                    }
                }
            }];
            
            /*
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"立即更新",nil];
             alertView.tag = 1000;
             alertView.delegate = self;
             [alertView show];
             */
        }
#else
        //appStore下载更新
        NSArray * rightArr = [responseObject objectForKey:@"results"];
        if (rightArr.count !=0) {
            NSDictionary * rightDic = [rightArr objectAtIndex:0];
            
            NSString * newVersion = [rightDic objectForKey:@"version"];
            
            NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
            NSString *localVersion =[localDic objectForKey:@"CFBundleShortVersionString"];
            
            if ([newVersion doubleValue] > [localVersion doubleValue]) {
                _newVersionURlString = [[rightDic objectForKey:@"trackViewUrl"] copy];
                
                NSString *msg = [NSString stringWithFormat:@"最新版本为%@,是否更新？",newVersion];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"立即更新",nil];
                alertView.tag = 1000;
                [alertView show];
            }else {
                NSLog(@"当前就是最新版本");
            }
        }
#endif
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"检测更新失败");
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        if (alertView.tag == 1000) {
            if(_newVersionURlString)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_newVersionURlString]];
            }
        }
    }
}




- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [UMSocialSnsService handleOpenURL:url];
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [[NSNotificationCenter defaultCenter] postNotificationName:Refresh object:nil];
    //进入前台就检测下新版本
    [self checkAppUpdate];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

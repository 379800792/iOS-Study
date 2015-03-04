//
//  common.h
//  eplatform-cms-edu
//
//  Created by Marble on 14/10/22.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hxTool.h"
#import "SVProgressHUD.h"

#define SCREENWIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height
/**
 * 获取某个控件的size 等等
 */
#define GetFrame_X_From(a) a.frame.origin.x
#define GetFrame_Y_From(a) a.frame.origin.y
#define GetFrame_Width_From(a) a.frame.size.width
#define GetFrame_Height_From(a) a.frame.size.height

#define GetNeedFrame_X_From(a) GetFrame_X_From(a)+GetFrame_Width_From(a)
#define GetNeedFrame_Y_From(a) GetFrame_Y_From(a)+GetFrame_Height_From(a)

//刷新的通知

#define Refresh @"refresh"

//是否是企业版应用（升级的时候需要判断） 1 企业版  0 AppStore版
#define IS_Enterprise_App 1


#ifdef IS_Enterprise_App
#define APP_URL @"http://eplatform.edu-edu.com.cn/_apps_update/cms_career_ios.json"  //企业更新地址
#else
#define APP_URL @"https://itunes.apple.com/lookup?id=918019592"   //appStore地址
#endif


//是否是测试环境（如果要切换到正式环境，请注释掉下面一行）
//#define EPLATFORM_SERVICE 1

#ifdef EPLATFORM_SERVICE
//测试环境
#define IndexUrl @"http://training.edu-edu.com.cn/edu/editor/_detail/article_%@/index.html"
#define ImgUrl @"http://eplatform.edu-edu.com.cn/cms/public/article/%@/images/%@"
#define hostUrl @"http://eplatform.edu-edu.com.cn"
#define ShareImgUrl @"http://training.edu-edu.com.cn"
#define NewsMenuListUrl @"/cms/public/column/articles/cates?_columnCode=android_developing"

#else
//正式环境
#define IndexUrl @"http://m.edu-edu.com.cn/career/editor/_detail/article_%@/index.html"
#define ImgUrl @"http://i.edu-edu.com.cn/cms/public/article/%@/images/%@"
#define hostUrl @"http://i.edu-edu.com.cn"
#define ShareImgUrl @"http://m.edu-edu.com.cn"
#define NewsMenuListUrl @"/cms/public/column/articles/cates?_columnCode=career_editor"

#endif

#define NewsListUrl @"/cms/public/column/articles/list/%d"
#define NewsSonListUrl @"cms/public/column/articles/search/%d"
//参数 page 页码 _coulumnId


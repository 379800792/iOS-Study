//
//  NewDetailViewController.m
//  eplatform-cms-edu
//
//  Created by Marble on 14/10/23.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import "NewDetailViewController.h"
#import "AFNetworking.h"
#import "common.h"
#import "SVProgressHUD.h"
@interface NewDetailViewController (){
    UIWebView *_webview;
    NSURLRequest *_request;
    
    //分享用
    NSString *_imgUrl;
    NSString *_titleText;
    
    UIActivityIndicatorView *activityIndicator;
    //404错误
    UIView *blankBg;
}
@end

@implementation NewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [hxTool hexStringToColor:@"#45CB6D"];
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"ic_menu_Return"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 4.5, 30, 30);
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *Button = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    [self.navigationItem setLeftBarButtonItem:Button];

    //分享按钮
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setImage:[UIImage imageNamed:@"ic_menu_share"] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 4.5, 35, 35);
    [btn1 addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *Button1 = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    
    [self.navigationItem setRightBarButtonItem:Button1];

    _webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,SCREENHEIGHT)];
    _webview.delegate = self;
    _webview.scalesPageToFit =NO;
    _webview.scrollView.bounces = NO;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:self.view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];


    [self.view addSubview:_webview];
    [self.view addSubview:activityIndicator];

    [self startWebRequest];


}

- (void)back{
    if (self.isNavPushed) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        }];
    }
}
- (void)shareButtonPressed{
    NSString *shareUrl;
    if([self.NewsHtmlUrl rangeOfString:@"?"].location != NSNotFound)//_roaldSearchText
    {
        shareUrl = [NSString stringWithFormat:@"%@%@",self.NewsHtmlUrl,@"&_crossc=1"];
    }
    else
    {
        shareUrl = [NSString stringWithFormat:@"%@%@",self.NewsHtmlUrl,@"?_crossc=1"];
    }
    NSString *shareStr = [_titleText stringByAppendingString:shareUrl];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
    [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
    [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
    
    NSData *data;
    
    if (![_imgUrl isEqualToString:ShareImgUrl]) {
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imgUrl]];
    }else{
        int n = arc4random()%5+1;
        NSString *resourcePath = [ [NSBundle mainBundle] resourcePath];
        NSString *filePath  = [resourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"xlxb_%d.jpg",n]];
        data = [NSData dataWithContentsOfFile:filePath];
    }
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"53df1315fd98c5bd8d000520"
                                      shareText:shareStr
                                     shareImage:data
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,nil]
                                       delegate:self];

}
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
//如果是404 显示一个友好界面
- (void)setThe404Error{
    blankBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    blankBg.backgroundColor  = [UIColor whiteColor];
    UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-45)/2, 90, 90/2, 77/2)];
    logoImg.image = [UIImage imageNamed:@"ic_empty_tip"];
    [blankBg addSubview:logoImg];
    UILabel *warnMsg = [[UILabel alloc]initWithFrame:CGRectMake(0, GetNeedFrame_Y_From(logoImg), SCREENWIDTH, 30)];
    warnMsg.text = @"该文章还不可访问哦！o(>﹏<)o";
    warnMsg.textColor = [hxTool hexStringToColor:@"#C8C8C8"];
    warnMsg.font = [UIFont systemFontOfSize:13];
    warnMsg.textAlignment = NSTextAlignmentCenter;
    [blankBg addSubview:warnMsg];
    [self.view addSubview:blankBg];

}
//开始请求
- (void)startWebRequest{
    BOOL isHaveNet = [hxTool isConnectionAvalible];
    if ( isHaveNet) {
        _request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.NewsHtmlUrl]];
        
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        manger.requestSerializer = [AFJSONRequestSerializer serializer];
        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manger GET:self.NewsHtmlUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *responseStr =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"responseStr = %@",responseStr);
            NSRange range = [responseStr rangeOfString:@"<center><h1>404 Not Found</h1></center>"];
            if(range.length>0)
            {
                NSLog(@"这是一个错误的404页面");
                [self setThe404Error];
                return ;
            }
            [_webview loadRequest:_request];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error.description);
            [self setThe404Error];
          
        }];
        
        
        //[_webview loadRequest:_request];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"当前网络不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark webviewDelegate 
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [activityIndicator startAnimating];
    [webView setHidden:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"$('.back-top').hide();"];
    
    
    //缩小上边栏间距
    
    [webView stringByEvaluatingJavaScriptFromString:@"$('.ui-widget.ui-widget-42').attr('style','padding-top:0;');"];
    
    //去掉footer 跟点赞按钮
    
    [webView stringByEvaluatingJavaScriptFromString:@"$('footer').hide();$('.hx-share-container').hide();"];
    
    
    //去掉web上的导航栏
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('ui_base_template_header').style.display=\"none\""];

    int64_t delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [activityIndicator stopAnimating];
                       [webView setHidden:NO];
                       
                   });
    
    //获取分享内容
    
    _imgUrl = [NSString stringWithFormat:@"%@%@",ShareImgUrl,[webView stringByEvaluatingJavaScriptFromString:@"$('.title-image img').attr('src');"]];
    _titleText =[webView stringByEvaluatingJavaScriptFromString:@"$('.box.content-box h1').text();"];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    //文章中的带链接的 直接跳转Safari打开
    NSURL *requestURL =[ request URL]  ;
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL: requestURL   ];
    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

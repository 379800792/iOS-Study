//
//  ViewController.m
//  eplatform-cms-edu
//
//  Created by Marble on 14/10/22.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "HXCrudListResult.h"
#import "HXCrudListRowResult.h"
#import "TableViewCell.h"
#import "NewDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PopoverView.h"
#import "common.h"
@interface ViewController (){
    
    UITableView *_myTableView; //新闻列表
    
    int currentPageList; //页码
    
    HXCrudListResult *_newsDataSource;  //存储新闻json 的model

    NSMutableArray *_popArray; //下拉menu数据源
    
    NSString *currentUrl; //当前请求的新闻url
    
    NSDictionary * params; //post请求存参数用（点击切换栏目用）

    UIImageView *navTopLogo; //导航栏logo
    
    PopoverView *typepopView; //第三方的popview空间 盛放menulist用
    
    UITableView *popTableView; //menulist
   
    UIImageView *topImage; //文章置顶图片
}

@end
#define SCREENWIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //顶部的logo
    navTopLogo = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 136, 40)];
    navTopLogo.image = [UIImage imageNamed:@"logo"];
    [self.navigationController.navigationBar addSubview:navTopLogo];
    if (_newsDataSource.body.count ==0) {
        [_myTableView headerBeginRefreshing];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [navTopLogo removeFromSuperview];
    navTopLogo = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"    ";
    self.navigationItem.backBarButtonItem = backItem;
    
    //初始化数据源
    _newsDataSource = [[HXCrudListResult alloc]init];
    _popArray = [[NSMutableArray alloc]initWithCapacity:0];
    currentPageList = 1;
    //全部新闻
    params = @{@"__ajax":@"true",@"pageCount":@"10",@"_columnId":@"4"};
    currentUrl = NewsListUrl;
    //目录按钮
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 4.5, 35, 35);
    [btn1 addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *Button1 = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    
    [self.navigationItem setRightBarButtonItem:Button1];
    
    CGRect rect = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    
    _myTableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [_myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_myTableView setBackgroundColor:[hxTool hexStringToColor:@"#DEE0E1"]];
    //[_myTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:_myTableView];
    [self setupTableHeaderRefresh];
    
    
    popTableView = [[UITableView alloc]initWithFrame:CGRectMake(4, 13, 142, 228) style:UITableViewStylePlain];
    [popTableView setSeparatorInset:UIEdgeInsetsZero];
    popTableView.layer.cornerRadius = 5.5;
    popTableView.dataSource = self;
    popTableView.delegate = self;
    popTableView.scrollsToTop = NO;
    [self requestTheMenuList];
    //接受通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:Refresh object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:Refresh object:self];
}
- (void)refresh{
    [_myTableView headerBeginRefreshing];
    
}
#pragma mark - 下拉加载更多

- (void)setupTableHeaderRefresh
{
    //下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_myTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _myTableView.headerPullToRefreshText = @"下拉可以刷新了";
    _myTableView.headerReleaseToRefreshText = @"松开马上刷新了";
    _myTableView.headerRefreshingText = @"刷新中……";
    
    
    [_myTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    _myTableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _myTableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _myTableView.footerRefreshingText = @"加载中……";
}

/**
 *  设置上拉加载更多控件隐藏属性
 */
- (void)setTableFooterView:(BOOL)visible
{
    if (!visible) {
        [_myTableView setFooterHidden:YES];
    }else{
        [_myTableView setFooterHidden:NO];
    }
}

#pragma mark - 请求网络相关
- (void)requestTheMenuList{
    AFHTTPSessionManager *manger = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:hostUrl]];
    manger.requestSerializer.timeoutInterval = 5;
    NSString *url = [NSString stringWithFormat:NewsMenuListUrl];
    [manger GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"success"] intValue] == 1) {
            NSArray *array = [responseObject objectForKey:@"cates"];
            [_popArray removeAllObjects];
            for (NSDictionary *obj in array) {
                NSDictionary *model = @{@"name": [obj objectForKey:@"name"],@"id":[obj objectForKey:@"id"]};
                [_popArray addObject:model];
            }
            [popTableView reloadData];
        }else{
        
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void)requestTheNewsWith:(int)page andParameters:(NSDictionary *)parm{
    AFHTTPSessionManager *manger = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:hostUrl]];
    manger.requestSerializer.timeoutInterval = 5;
    NSMutableDictionary *parameters;

    [parameters setValuesForKeysWithDictionary:parm];
    

    NSString *url = [NSString stringWithFormat:currentUrl,page];
    [manger GET:url parameters:parm success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"success"] intValue] == 1)
        {
            _newsDataSource.count = [[responseObject objectForKey:@"count"]intValue];
            if (currentPageList == 1) {
                _newsDataSource.body = nil;  //先清空原始数据
            }
            if ([responseObject objectForKey:@"body"] != nil) {
                _newsDataSource.body = [responseObject objectForKey:@"body"];
            }
            if (_newsDataSource.count == 10) {
                [self setTableFooterView:YES];
                currentPageList++;
            }else{
                [self setTableFooterView:NO];
            }
            
        }else
        {
            NSLog(@"获取我的答疑室数据失败");
            
        }
        //设置空白界面
        if (_newsDataSource.count ==0 ) {
            UIView *blankBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            blankBg.backgroundColor  = [UIColor whiteColor];
            UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-45)/2, 90, 90/2, 77/2)];
            logoImg.image = [UIImage imageNamed:@"ic_empty_tip"];
            [blankBg addSubview:logoImg];
            UILabel *warnMsg = [[UILabel alloc]initWithFrame:CGRectMake(0, GetNeedFrame_Y_From(logoImg), SCREENWIDTH, 30)];
            warnMsg.text = @"该版块目前没有文章哦！o(>﹏<)o";
            warnMsg.textColor = [hxTool hexStringToColor:@"#C8C8C8"];
            warnMsg.font = [UIFont systemFontOfSize:13];
            warnMsg.textAlignment = NSTextAlignmentCenter;
            [blankBg addSubview:warnMsg];
            [_myTableView setTableHeaderView:blankBg];
        }else{
            [_myTableView setTableHeaderView:nil];
        
        }
        [_myTableView reloadData];
        
        [_myTableView headerEndRefreshing];
        [_myTableView footerEndRefreshing];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_myTableView headerEndRefreshing];
        [_myTableView footerEndRefreshing];

    }];
}
#pragma mark - 开始进入刷新状态
- (void)headerRereshing{
    if ([hxTool isConnectionAvalible]) {
        currentPageList = 1;
        [self requestTheNewsWith:currentPageList andParameters:params];
        if (_popArray.count == 0) {
            [self requestTheMenuList];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"网络没有连接"];
        [_myTableView  headerEndRefreshing];
    }
    
}
//上拉加载更多
- (void)footerRereshing
{
    [self requestTheNewsWith:currentPageList andParameters:params];

}
//点击事件
- (void)menuButtonPressed{
    

    if (typepopView == nil) {

        [popTableView setSeparatorInset:UIEdgeInsetsZero];

    }
    if (popTableView == nil) {
        NSLog(@"123");
    }
    
    CGPoint point = CGPointMake(SCREENWIDTH-30, 55);
    typepopView = [PopoverView showPopoverAtPoint:point
                                           inView:self.view
                                  withContentView:popTableView
                                         delegate:self];
    

}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _myTableView) {
        return _newsDataSource.body.count;

    }else{
        int numOfCell = _popArray.count+1;
        //ios 8 以上一下的尺寸才有用
        popTableView.frame = CGRectMake(SCREENWIDTH-142-11, 68, 142, 230/6*numOfCell);
        return numOfCell;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _myTableView) {
        
        static NSString *cellId = @"newsCell";
        
        TableViewCell *newCell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (newCell == nil) {
        
            newCell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        }
        
        HXCrudListRowResult *result = [_newsDataSource.body objectAtIndex:indexPath.row];
        
        //新闻的标题
        
        newCell.newsTitle.text = [self isNull:(NSString *)[result.columns objectForKey:@"title"]];
        
        CGSize sizeOfTitle = [newCell.newsTitle.text sizeWithFont:[UIFont systemFontOfSize:21] constrainedToSize:CGSizeMake(SCREENWIDTH-40, 999) lineBreakMode:NSLineBreakByCharWrapping];
        
        newCell.newsTitle.frame = CGRectMake(20,20, SCREENWIDTH-40, sizeOfTitle.height);
        
        //新闻的类型
        
        newCell.newsType.frame = CGRectMake(20,GetNeedFrame_Y_From(newCell.newsTitle), 70, 30);

        newCell.newsType.text = [self isNull:(NSString *)[result.columns objectForKey:@"categoryName"]];
        
        //华丽的分割线
        
        newCell.newsLine.frame = CGRectMake(10, GetNeedFrame_Y_From(newCell.newsType)+10, SCREENWIDTH-20, 1);
       
        //新闻内的图片
        
        if ([[result.columns objectForKey:@"titleImage"] isKindOfClass:[NSNull class]]) {
            
            //没有图
        
            newCell.newsImg.frame = CGRectMake(20, GetNeedFrame_Y_From(newCell.newsLine)+10, 0, 0);
        
        }else{
            
            newCell.newsImg.frame = CGRectMake(20, GetNeedFrame_Y_From(newCell.newsLine)+10,SCREENWIDTH-40, SCREENWIDTH-60);
            
            NSArray *array = [ (NSString *)[result.columns objectForKey:@"titleImage"] componentsSeparatedByString:@"/"];
            
            NSString *url = [NSString stringWithFormat:ImgUrl,result.Id,[array objectAtIndex:0]];

            NSURL *imgUrl = [NSURL URLWithString:url];
        
            [newCell.newsImg setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"empty_img"]];
        };
        
        //新闻的内容
        NSString *newsContentStr =[self filterHTML:[self isNull:(NSString *)[result.columns objectForKey:@"shortContent"]]];
        newCell.newsShortContent.text =newsContentStr;
        
        CGSize sizeOfShortContent = [ newCell.newsShortContent.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREENWIDTH-40, 999) lineBreakMode:NSLineBreakByCharWrapping];
        
        newCell.newsShortContent.frame = CGRectMake(20, GetNeedFrame_Y_From(newCell.newsImg), SCREENWIDTH-40, sizeOfShortContent.height);
        

        //新闻的发布日期
        
        newCell.newsDate.text = [self isNull:(NSString *)[result.columns objectForKey:@"publishTime"]];
        
        newCell.newsDate.frame = CGRectMake(GetNeedFrame_X_From(newCell.newsType), GetNeedFrame_Y_From(newCell.newsTitle), SCREENWIDTH-40, 30);
        
        // cell 的背景
        
        newCell.newsBg.frame = CGRectMake(10, 10, SCREENWIDTH-20, GetNeedFrame_Y_From(newCell.newsShortContent)+10);
        
        // 是否有置顶
        
        if ([[result.columns objectForKey:@"isTop"]intValue]==1) {
            //置顶
            newCell.topImage.hidden = NO;
        }else{
            newCell.topImage.hidden = YES;
        }
       
        return newCell;
    
    }else{
      
        static NSString *cellID = @"popCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        //设置选中时候的cell背景颜色
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y+4, cell.frame.size.width, cell.frame.size.height-8)];
        cell.selectedBackgroundView.backgroundColor = [hxTool hexStringToColor:@"#f8f8f8"];
        cell.textLabel.highlightedTextColor = [hxTool hexStringToColor:@"#33CB67"];
        if (indexPath.row == 0) {
            cell.textLabel.text =  @"全部文章" ;
        }else{
            NSDictionary *model = [_popArray objectAtIndex:indexPath.row-1];
            cell.textLabel.text =  [model objectForKey:@"name"] ;
        }
        cell.textLabel.textColor =[UIColor darkGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:19];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:19];
        return cell;

    }

}
-(NSString *)filterHTML:(NSString *)html
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
- (NSString *)isNull:(NSString *)str{
    if ([str isKindOfClass:[NSNull class]]) {
        return @"";
    }else{
        return str;
    }
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _myTableView) {
    
    HXCrudListRowResult *result = [_newsDataSource.body objectAtIndex:indexPath.row];
        CGFloat cellHeight = 90;
    if (![[result.columns objectForKey:@"titleImage"] isKindOfClass:[NSNull class]]) {
        //没有图
        cellHeight += SCREENWIDTH-60;
    }
    
    CGSize sizeOfShortContent = [[self filterHTML:[self isNull:(NSString *)[result.columns objectForKey:@"shortContent"]]] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREENWIDTH-40, 999) lineBreakMode:NSLineBreakByCharWrapping];
    CGSize sizeOfTitle = [[self isNull:(NSString *)[result.columns objectForKey:@"title"]] sizeWithFont:[UIFont systemFontOfSize:21] constrainedToSize:CGSizeMake(SCREENWIDTH-40, 999) lineBreakMode:NSLineBreakByCharWrapping];
        
    cellHeight+= sizeOfShortContent.height+sizeOfTitle.height;

    return cellHeight;
    }else
    return 230/6;;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == _myTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        NewDetailViewController *newDetail = [[NewDetailViewController alloc]init];
        newDetail.isNavPushed = YES;
        HXCrudListRowResult *result = [_newsDataSource.body objectAtIndex:indexPath.row];
        newDetail.NewsHtmlUrl = [NSString stringWithFormat:IndexUrl,result.Id];
        [self.navigationController pushViewController:newDetail animated:YES];
        
    }else{
        [typepopView dismiss:YES];

        //__ajax=true&pageCount=10&_columnCode=android_developing&_columnId=3
        if (indexPath.row == 0) {
            params = @{@"__ajax":@"true",@"pageCount":@"10",@"_columnId":@"4"};
            currentUrl = NewsListUrl;
        }else{
            NSDictionary *model = [_popArray objectAtIndex:indexPath.row-1];
            NSString *nowId = (NSString *)[model objectForKey:@"id"];
            currentUrl = NewsSonListUrl;
//eplatform.edu-edu.com.cn/cms/public/column/articles/search/1?pageCount=10&_columnId=3&__ajax=true
            params = @{@"__ajax":@"true",@"pageCount":@"10",@"_columnId":@"4",@"categoryId":nowId};

        }

        [_myTableView headerBeginRefreshing];

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

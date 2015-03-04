//
//  TableViewCell.m
//  eplatform-cms-edu
//
//  Created by Marble on 14/10/22.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _newsBg = [[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREENWIDTH-20, 0)];
        _newsBg.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_newsBg];
        
        _topImage = [[UIImageView alloc]initWithFrame:CGRectMake(GetFrame_Width_From(_newsBg)-30, 0, 30, 30)];
        _topImage.image = [UIImage imageNamed:@"ding"];
        _topImage.hidden = YES;
        [_newsBg addSubview:_topImage];

        
        _newsTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, SCREENWIDTH-40, 60)];
        _newsTitle.font = [UIFont systemFontOfSize:21];
        _newsTitle.numberOfLines = 0;
        _newsTitle.lineBreakMode = NSLineBreakByCharWrapping;
        _newsTitle.textColor = [hxTool hexStringToColor:@"#686868"];

        _newsTitle.lineBreakMode = NSLineBreakByCharWrapping;
        _newsTitle.text = @"";
        [self.contentView addSubview:_newsTitle];
        
        _newsType = [[UILabel alloc]initWithFrame:CGRectMake(20,GetNeedFrame_Y_From(_newsTitle), 70, 30)];
        _newsType.font = [UIFont systemFontOfSize:15];
        _newsType.textColor = [hxTool hexStringToColor:@"#838383"];
        _newsType.text = @"";
        [self.contentView addSubview:_newsType];
        
        _newsImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, GetNeedFrame_Y_From(_newsLine), SCREENWIDTH-40, SCREENWIDTH-60)];
        _newsImg.clipsToBounds = YES;
        _newsImg.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview: _newsImg];
        
        _newsShortContent = [[UILabel alloc]initWithFrame:CGRectMake(20, GetNeedFrame_Y_From(_newsImg), SCREENWIDTH-40, 100)];
        _newsShortContent.numberOfLines = 0;
        _newsShortContent.textColor = [hxTool hexStringToColor:@"#919191"];

        _newsShortContent.lineBreakMode  = NSLineBreakByCharWrapping;
        _newsShortContent.font = [UIFont systemFontOfSize:15];
        _newsShortContent.text = @"";
        [self.contentView addSubview:_newsShortContent];
        
        _newsLine = [[UILabel alloc]initWithFrame:CGRectMake(10, GetNeedFrame_Y_From(_newsType)+10, SCREENWIDTH-20, 0.7)];
        _newsLine.backgroundColor = [hxTool hexStringToColor:@"#C8C8C8"];
        [self.contentView addSubview:_newsLine];
        
        _newsDate = [[UILabel alloc]initWithFrame:CGRectMake(GetNeedFrame_X_From(_newsType)+10, GetNeedFrame_Y_From(_newsTitle), 100, 30)];
        _newsDate.text = @"";
        _newsDate.textColor = [hxTool hexStringToColor:@"#838383"];
        _newsDate.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_newsDate];
        

    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
   }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

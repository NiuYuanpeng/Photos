//
//  XHouseTableViewCell.m
//  YKHouse
//
//  Created by wjl on 14-5-11.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "XHouseTableViewCell.h"

@implementation XHouseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 110.0, 90.0)];
        imageView.backgroundColor=[UIColor redColor];
        imageView.image=[UIImage imageNamed:@"listLoad.png"];
        [self.contentView addSubview:imageView];
        
        UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+10.0, imageView.frame.origin.y, ScreenWidth-(imageView.frame.origin.x+imageView.frame.size.width+15.0), 20.0)];
        nameLabel.text=@"开祥御龙城";
        nameLabel.numberOfLines=0;
        nameLabel.font=[UIFont boldSystemFontOfSize:16.0];
        [self.contentView addSubview:nameLabel];
        
        UILabel *addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height+3.0, nameLabel.frame.size.width, 20.0)];
        addressLabel.text=@"金水  东风路与天明路交汇处(绿荫公园西)";
        addressLabel.font=[UIFont systemFontOfSize:13.0];
        addressLabel.textColor=[UIColor darkGrayColor];
        [self.contentView addSubview:addressLabel];
        
        UILabel *qxLabel=[[UILabel alloc] initWithFrame:CGRectMake(addressLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+3.0, addressLabel.frame.size.width-5.0, 20.0)];
        qxLabel.text=@"期房在售";
        qxLabel.font=[UIFont systemFontOfSize:13.0];
        qxLabel.textColor=[UIColor darkGrayColor];
        [self.contentView addSubview:qxLabel];
        
        UILabel *hxLabel=[[UILabel alloc] initWithFrame:CGRectMake(qxLabel.frame.origin.x, qxLabel.frame.origin.y+qxLabel.frame.size.height+3.0, qxLabel.frame.size.width/2.0, 20.0)];
        hxLabel.text=@"3号线 市中心";
        hxLabel.font=[UIFont systemFontOfSize:13.0];
        hxLabel.textColor=[UIColor redColor];
        [self.contentView addSubview:hxLabel];
        
        UILabel *moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(hxLabel.frame.origin.x+hxLabel.frame.size.width+0.0, hxLabel.frame.origin.y, qxLabel.frame.size.width/2.0-0.0, 20.0)];
        moneyLabel.text=@"10800元/平";
        moneyLabel.font=[UIFont boldSystemFontOfSize:18.0];
        moneyLabel.textColor=[UIColor redColor];
        [self.contentView addSubview:moneyLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

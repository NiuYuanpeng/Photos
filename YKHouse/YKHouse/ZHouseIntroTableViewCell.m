//
//  ZHouseIntroTableViewCell.m
//  YKHouse
//
//  Created by hnsi on 14-5-20.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "ZHouseIntroTableViewCell.h"

@implementation ZHouseIntroTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10.0, 5.0, ScreenWidth-20.0, 50.0)];
        nameLabel.text=@"五行嘉园 精装4房 俯瞰如意湖 随时看房";
        nameLabel.numberOfLines=0;
        nameLabel.font=[UIFont boldSystemFontOfSize:20];
        [self.contentView addSubview:nameLabel];
        
        UILabel *rentLabel=[[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height+5.0, nameLabel.frame.size.width, 20.0)];
        rentLabel.text=@"租金:6500元/月(付3押1)";
        rentLabel.textColor=[UIColor redColor];
        rentLabel.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:rentLabel];
        
        UILabel *fxLabel=[[UILabel alloc] initWithFrame:CGRectMake(rentLabel.frame.origin.x, rentLabel.frame.origin.y+rentLabel.frame.size.height+5.0, rentLabel.frame.size.width/2.0+20.0, 20.0)];
        fxLabel.text=@"房型:3室2厅2卫(整租)";
        [self.contentView addSubview:fxLabel];
        
        UILabel *zxLabel=[[UILabel alloc] initWithFrame:CGRectMake(fxLabel.frame.origin.x+fxLabel.frame.size.width+20.0, fxLabel.frame.origin.y, rentLabel.frame.size.width/2.0-10.0, 20.0)];
        zxLabel.text=@"装修:精装修";
        [self.contentView addSubview:zxLabel];
        
        UILabel *mjLabel=[[UILabel alloc] initWithFrame:CGRectMake(rentLabel.frame.origin.x, fxLabel.frame.origin.y+fxLabel.frame.size.height+5.0, fxLabel.frame.size.width, 20.0)];
        mjLabel.text=@"面积:6000平米";
        [self.contentView addSubview:mjLabel];
        
        UILabel *cxLabel=[[UILabel alloc] initWithFrame:CGRectMake(zxLabel.frame.origin.x, mjLabel.frame.origin.y, zxLabel.frame.size.width, 20.0)];
        cxLabel.text=@"朝向:向北";
        [self.contentView addSubview:cxLabel];
        
        UILabel *lcLabel=[[UILabel alloc] initWithFrame:CGRectMake(rentLabel.frame.origin.x, mjLabel.frame.origin.y+mjLabel.frame.size.height+5.0, mjLabel.frame.size.width, 20.0)];
        lcLabel.text=@"楼层:14/25";
        [self.contentView addSubview:lcLabel];
        
        UILabel *lxLabel=[[UILabel alloc] initWithFrame:CGRectMake(cxLabel.frame.origin.x, lcLabel.frame.origin.y, cxLabel.frame.size.width, 20.0)];
        lxLabel.text=@"类型:普通住宅";
        [self.contentView addSubview:lxLabel];

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

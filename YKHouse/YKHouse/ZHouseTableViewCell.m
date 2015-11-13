//
//  ZHouseTableViewCell.m
//  YKHouse
//
//  Created by wjl on 14-5-11.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "ZHouseTableViewCell.h"
#import "UIImageView+AFNetworking.h"
@implementation ZHouseTableViewCell
@synthesize iconUrl,nameString,addressString,hxString,moneyString,money;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 110.0, 90.0)];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureAddress,iconUrl]] placeholderImage:[UIImage imageNamed:@"listLoad.png"]];
        [self.contentView addSubview:imageView];
        
        NSLog(@"%f",ScreenWidth);
        nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+10.0, imageView.frame.origin.y+5.0, ScreenWidth-(imageView.frame.origin.x+imageView.frame.size.width+15.0), 20.0)];
        nameLabel.numberOfLines=0;
        nameLabel.font=[UIFont boldSystemFontOfSize:15.0];
        [self.contentView addSubview:nameLabel];
        
        addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height+5.0+5.0, nameLabel.frame.size.width, 20.0)];
        addressLabel.textColor=[UIColor darkGrayColor];
        addressLabel.font=[UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:addressLabel];
        
        hxLabel=[[UILabel alloc] initWithFrame:CGRectMake(addressLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+5.0+5.0, addressLabel.frame.size.width/2.0+35.0, 20.0)];
        hxLabel.textColor=[UIColor darkGrayColor];
        hxLabel.font=[UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:hxLabel];
        
        moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(hxLabel.frame.origin.x+hxLabel.frame.size.width-35.0, hxLabel.frame.origin.y, addressLabel.frame.size.width/2.0-15.0, 20.0)];
        moneyLabel.font=[UIFont boldSystemFontOfSize:20.0];
        moneyLabel.textAlignment=NSTextAlignmentRight;
        moneyLabel.textColor=[UIColor redColor];
        [self.contentView addSubview:moneyLabel];
        
        _month=[[UILabel alloc] initWithFrame:CGRectMake(moneyLabel.frame.origin.x+moneyLabel.frame.size.width, moneyLabel.frame.origin.y, 12, 20.0)];
        _month.font=[UIFont boldSystemFontOfSize:13.0];
        _month.textAlignment=NSTextAlignmentRight;
        _month.textColor=[UIColor redColor];
        _month.text=@"月";
        [self.contentView addSubview:_month];

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
-(void)setIconUrl:(NSString *)n{
    if (![n isKindOfClass:[NSNull class] ]) {
        if (![n isEqualToString:iconUrl]) {
            iconUrl = [n copy];
            [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureAddress,iconUrl]] placeholderImage:[UIImage imageNamed:@"listLoad.png"]];
        }
    }
}
-(void)setNameString:(NSString *)n {
    if (![n isKindOfClass:[NSNull class] ]) {
        if (![n isEqualToString:nameString]) {
            nameString = [n copy];
            nameLabel.text = nameString;
        }
    }
}
-(void)setAddressString:(NSString *)n {
    if (![n isKindOfClass:[NSNull class] ]) {
        if (![n isEqualToString:addressString]) {
            addressString = [n copy];
            addressLabel.text = addressString;
        }
    }
}
-(void)setHxString:(NSString *)n {
    //NSLog(@"%@",n);
    if (![n isKindOfClass:[NSNull class] ]) {
        if (![n isEqualToString:hxString]) {
            hxString = [n copy];
            hxLabel.text = hxString;
        }
    }
}
-(void)setMoneyString:(NSString *)n{
    //NSLog(@"%@",n);
    if (![n isKindOfClass:[NSNull class] ]) {
        if (![n isEqualToString:moneyString]) {
            moneyString = [n copy];
            moneyLabel.text = moneyString;
        }
    }
}
-(void)setMoney:(int)n{
    //NSLog(@"%d",n);
    moneyLabel.text = [NSString stringWithFormat:@"%d/",n];
    //NSLog(@"%@",moneyLabel.text);
}

@end

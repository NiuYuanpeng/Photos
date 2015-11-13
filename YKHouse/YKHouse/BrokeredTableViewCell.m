//
//  BrokeredTableViewCell.m
//  YKHouse
//
//  Created by hnsi on 14-5-20.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "BrokeredTableViewCell.h"

@implementation BrokeredTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10.0, 5.0, 80.0, 100.0)];
        imageView.backgroundColor=[UIColor redColor];
        imageView.image=[UIImage imageNamed:@"listLoad.png"];
        [self.contentView addSubview:imageView];
        
        UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+10.0, imageView.frame.origin.y, ScreenWidth-(imageView.frame.origin.x+imageView.frame.size.width+15.0), 20.0)];
        
        [self.contentView addSubview:nameLabel];
        
        UILabel *telNumberLabel=[[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height+5.0, nameLabel.frame.size.width, 20.0)];
        
        [self.contentView addSubview:telNumberLabel];
        
        UILabel *ssgsLabel=[[UILabel alloc] initWithFrame:CGRectMake(telNumberLabel.frame.origin.x, telNumberLabel.frame.origin.y+telNumberLabel.frame.size.height+5.0, telNumberLabel.frame.size.width, 20.0)];
        
        [self.contentView addSubview:ssgsLabel];
        
        UILabel *houseResourceLabel=[[UILabel alloc] initWithFrame:CGRectMake(ssgsLabel.frame.origin.x, ssgsLabel.frame.origin.y+ssgsLabel.frame.size.height+5.0, ssgsLabel.frame.size.width, 20.0)];
        
        [self.contentView addSubview:houseResourceLabel];
        
        UILabel *otherLabel=[[UILabel alloc] initWithFrame:CGRectMake(10.0, houseResourceLabel.frame.origin.y+houseResourceLabel.frame.size.height+5.0, ScreenWidth-imageView.frame.origin.x*2, 20.0)];
        
        [self.contentView addSubview:otherLabel];
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

//
//  SiftConditionView.m
//  YKang
//
//  Created by hnsi on 14-4-16.
//  Copyright (c) 2014年 hnsi. All rights reserved.
//

#import "SiftConditionView.h"

@implementation SiftConditionView
@synthesize leftTableV;
@synthesize rightTableV;
@synthesize segmentTitleArray=_segmentTitleArray;
@synthesize firstArray=_firstArray;
@synthesize secondArray=_secondArray;
@synthesize thirdArray=_thirdArray;
@synthesize firstLeftCurrentIndex=_firstLeftCurrentIndex;
@synthesize firstRightCurrentIndex=_firstRightCurrentIndex;
@synthesize secondLeftCurrentIndex=_secondLeftCurrentIndex;
@synthesize thirdLeftCurrentIndex=_thirdLeftCurrentIndex;
@synthesize thirdRightCurrentIndex=_thirdRightCurrentIndex;
@synthesize secondRightCurrentIndex=_secondRightCurrentIndex;
@synthesize firstTempIndex=firstTempIndex;
@synthesize secondTempIndex=secondTempIndex;
@synthesize thirdTempIndex=thirdTempIndex;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
        // Initialization code
        _firstArray=[[NSMutableArray alloc] init];
        _secondArray=[[NSMutableArray alloc] init];
        _thirdArray=[[NSMutableArray alloc] init];
        
        leftTableV=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
        leftTableV.delegate=self;
        leftTableV.dataSource=self;
        leftTableV.separatorStyle=SiftConditionViewLeftTableSeparatorStyleNone;
        leftTableV.backgroundColor=[UIColor clearColor];
        [self addSubview:leftTableV];
        
        rightTableV=[[UITableView alloc] initWithFrame:CGRectMake(140.0, 0.0, self.bounds.size.width-120.0, self.bounds.size.height) style:UITableViewStylePlain];
        rightTableV.delegate=self;
        rightTableV.dataSource=self;
        rightTableV.backgroundColor=[UIColor whiteColor];
        rightTableV.hidden=YES;
        [self addSubview:rightTableV];
        
        line=[[UIImageView alloc] initWithFrame:CGRectMake(139.0, 0.0, 1.0, self.bounds.size.height)];
        line.hidden=YES;
        line.backgroundColor=[UIColor colorWithRed:67/255.0 green:184/255.0 blue:252/255.0 alpha:1.0];
        [self addSubview:line];
        
        _firstLeftCurrentIndex=0;
        _firstRightCurrentIndex=-1;
        _secondLeftCurrentIndex=-1;
        _secondRightCurrentIndex=-1;
        _thirdLeftCurrentIndex=0;
        _thirdRightCurrentIndex=-1;
        firstTempIndex=self.firstLeftCurrentIndex;
        secondTempIndex=self.secondLeftCurrentIndex;
        thirdTempIndex=self.thirdLeftCurrentIndex;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==leftTableV) {
        if (self.selectSegmentValue==0&&self.firstArray.count>0) {
            return self.firstArray.count;
        }else if (self.selectSegmentValue==1&&self.secondArray.count>0){
            return self.secondArray.count;
        }else if (self.selectSegmentValue==2&&self.thirdArray.count>0){
            return self.thirdArray.count;
        }
    }else if(tableView==rightTableV){
        if (self.selectSegmentValue==0&&self.firstArray.count>0) {
            NSDictionary *dic=[self.firstArray objectAtIndex:self.firstLeftCurrentIndex];
            if ([[dic objectForKey:@"listarea"] isKindOfClass:[NSArray class]]) {
                NSArray *rightArray=[dic objectForKey:@"listarea"];
                return rightArray.count;
            }
        }else if (self.selectSegmentValue==1&&self.secondArray.count>0){
            NSDictionary *dic=[self.secondArray objectAtIndex:self.secondLeftCurrentIndex];
            if ([[dic objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                NSArray *rightArray=[dic objectForKey:@"list"];
                return rightArray.count;
            }
        }else if (self.selectSegmentValue==2&&self.thirdArray.count>0){
            NSDictionary *dic=[self.thirdArray objectAtIndex:self.thirdLeftCurrentIndex];
            if ([[dic objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                NSArray *rightArray=[dic objectForKey:@"list"];
                return rightArray.count;
            }
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (tableView==leftTableV) {
            UIImageView *rightAccessoryView=[[UIImageView alloc] initWithFrame:CGRectMake(131.0, 15.0, 9.0, 11.0)];
            rightAccessoryView.hidden=YES;
            rightAccessoryView.tag=88888;
            rightAccessoryView.image=[UIImage imageNamed:@"三角移动符号.png"];
            [cell.contentView addSubview:rightAccessoryView];
        }
    }
    cell.textLabel.text=@"";
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.textLabel.font=[UIFont systemFontOfSize:15.0];
    if (tableView==leftTableV) {
        line.hidden=YES;
        UIImageView *rightView=(UIImageView *)[cell.contentView viewWithTag:88888];
        rightView.hidden=YES;
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        if (self.selectSegmentValue==0) {
            NSDictionary *firstDic=[self.firstArray objectAtIndex:indexPath.row];
            NSString *strUrl = [[firstDic objectForKey:@"area"] stringByReplacingOccurrencesOfString:@" " withString:@""];
            cell.textLabel.text=strUrl;
            if (self.firstLeftCurrentIndex==indexPath.row) {
                [cell.textLabel setTextColor:[UIColor blueColor]];
                if ([[firstDic objectForKey:@"listarea"] isKindOfClass:[NSArray class]]) {
                    NSArray *listAreaArray=(NSArray *)[firstDic objectForKey:@"listarea"];
                    if (listAreaArray.count>0) {
                       rightView.hidden=NO;
                    }
                }
            }
        }else if (self.selectSegmentValue==2) {
            NSDictionary *thirdDic=[self.thirdArray objectAtIndex:indexPath.row];
            cell.textLabel.text=[thirdDic objectForKey:@"name"];
            if (self.thirdLeftCurrentIndex==indexPath.row) {
                [cell.textLabel setTextColor:[UIColor blueColor]];
                if ([[thirdDic objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                    NSArray *listArray=(NSArray *)[thirdDic objectForKey:@"list"];
                    if (listArray.count>0) {
                        rightView.hidden=NO;
                    }
                }
            }
        }else if (self.selectSegmentValue==1){
            NSDictionary *secondDic=[self.secondArray objectAtIndex:indexPath.row];
            cell.textLabel.text=[secondDic objectForKey:@"name"];
            if (self.secondLeftCurrentIndex==indexPath.row) {
                [cell.textLabel setTextColor:[UIColor blueColor]];
                if ([[secondDic objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                    NSArray *listArray=(NSArray *)[secondDic objectForKey:@"list"];
                    if (listArray.count>0) {
                        rightView.hidden=NO;
                    }
                }
            }
        }
    }else if(tableView==rightTableV){
        line.hidden=NO;
            [cell.textLabel setTextColor:[UIColor blackColor]];
            cell.backgroundColor=[UIColor clearColor];
            if (self.selectSegmentValue==0) {
                NSDictionary *firstDic=[self.firstArray objectAtIndex:self.firstLeftCurrentIndex];
                NSArray *rightArray=(NSArray *)[firstDic objectForKey:@"listarea"];
                NSString *strUrl = [[rightArray objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@""];
                cell.textLabel.text=strUrl;
                //cell.textLabel.text=[rightArray objectAtIndex:indexPath.row];
                
                if (firstTempIndex==self.firstLeftCurrentIndex) {
                    if (indexPath.row==self.firstRightCurrentIndex) {
                        [cell.textLabel setTextColor:[UIColor blueColor]];
                        cell.backgroundColor=[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
                    }
                }
            }else if (self.selectSegmentValue==1){
                NSDictionary *secondDic=[self.secondArray objectAtIndex:self.secondLeftCurrentIndex];
                NSArray *rightArray=(NSArray *)[secondDic objectForKey:@"list"];
                cell.textLabel.text=[rightArray objectAtIndex:indexPath.row];
                
                if (secondTempIndex==self.secondLeftCurrentIndex) {
                    if (indexPath.row==self.secondRightCurrentIndex) {
                        [cell.textLabel setTextColor:[UIColor blueColor]];
                        cell.backgroundColor=[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
                    }
                }
            }else if (self.selectSegmentValue==2){
                NSDictionary *thirdDic=[self.thirdArray objectAtIndex:self.thirdLeftCurrentIndex];
                NSArray *rightArray=(NSArray *)[thirdDic objectForKey:@"list"];
                cell.textLabel.text=[rightArray objectAtIndex:indexPath.row];
                if (thirdTempIndex==self.thirdLeftCurrentIndex) {
                    if (indexPath.row==self.thirdRightCurrentIndex) {
                        [cell.textLabel setTextColor:[UIColor blueColor]];
                        cell.backgroundColor=[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
                    }
                }
            }
            
        }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==leftTableV) {
        if (self.selectSegmentValue==0) {
            if (indexPath.row==self.firstLeftCurrentIndex) {
                NSDictionary *firstDic=[self.firstArray objectAtIndex:indexPath.row];
                if ([[firstDic objectForKey:@"listarea"] isKindOfClass:[NSArray class]]) {
                    NSArray *listAreaArray=(NSArray *)[firstDic objectForKey:@"listarea"];
                    if (listAreaArray.count>0) {
                        //firstTempIndex=self.firstLeftCurrentIndex;
                        rightTableV.hidden=NO;
                        [rightTableV reloadData];
                    }
                }
            }
        }else if (self.selectSegmentValue==2){
            NSDictionary *thirdDic=[self.thirdArray objectAtIndex:indexPath.row];
            if ([[thirdDic objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                NSArray *listAreaArray=(NSArray *)[thirdDic objectForKey:@"list"];
                if (listAreaArray.count>0) {
                    //secondTempIndex=self.secondLeftCurrentIndex;
                    rightTableV.hidden=NO;
                    [rightTableV reloadData];
                }
            }
        }else if (self.selectSegmentValue==1){
            if (indexPath.row==self.secondLeftCurrentIndex) {
                NSDictionary *secondDic=[self.secondArray objectAtIndex:indexPath.row];
                if ([[secondDic objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                    NSArray *listArray=(NSArray *)[secondDic objectForKey:@"list"];
                    if (listArray.count>0) {
                        //thirdTempIndex=self.thirdLeftCurrentIndex;
                        rightTableV.hidden=NO;
                        [rightTableV reloadData];
                    }
                }
            }
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==leftTableV) {
        if (self.selectSegmentValue==0) {
            
            NSDictionary *firstDic=[self.firstArray objectAtIndex:indexPath.row];
            NSLog(@"%d",self.firstArray.count);
            for (int i=0; i<self.firstArray.count; i++) {//清楚蓝色字体
                NSLog(@"%d",i);
                UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                UIImageView *rightView=(UIImageView *)[cell.contentView viewWithTag:88888];
                rightView.hidden=YES;
                [cell.textLabel setTextColor:[UIColor blackColor]];
            }
            UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            UIImageView *rightView=(UIImageView *)[cell.contentView viewWithTag:88888];
            rightView.hidden=YES;
            [cell.textLabel setTextColor:[UIColor blueColor]];
            if ([[firstDic objectForKey:@"listarea"] isKindOfClass:[NSArray class]]) {
                NSArray *listAreaArray=(NSArray *)[firstDic objectForKey:@"listarea"];
                if (listAreaArray.count>0) {
                    rightView.hidden=NO;
                    //firstTempIndex=indexPath.row;
                    self.firstLeftCurrentIndex=indexPath.row;
                    [rightTableV reloadData];
                    return;
                }
            }
            self.firstLeftCurrentIndex=indexPath.row;
            firstTempIndex=self.firstLeftCurrentIndex;
        }else if (self.selectSegmentValue==1){
            NSDictionary *secondDic=[self.secondArray objectAtIndex:indexPath.row];
            for (int i=0; i<self.secondArray.count; i++) {
                UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                UIImageView *rightView=(UIImageView *)[cell.contentView viewWithTag:88888];
                rightView.hidden=YES;
                [cell.textLabel setTextColor:[UIColor blackColor]];
            }
            UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            UIImageView *rightView=(UIImageView *)[cell.contentView viewWithTag:88888];
            rightView.hidden=YES;
            [cell.textLabel setTextColor:[UIColor blueColor]];
            if ([[secondDic objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                NSArray *listArray=(NSArray *)[secondDic objectForKey:@"list"];
                if (listArray.count>0) {
                    rightView.hidden=NO;
                    //secondTempIndex=indexPath.row;
                    self.secondLeftCurrentIndex=indexPath.row;
                    [rightTableV reloadData];
                    return;
                }
            }
            self.secondLeftCurrentIndex=indexPath.row;
            secondTempIndex=self.secondLeftCurrentIndex;
        }else if (self.selectSegmentValue==2){
            NSDictionary *thirdDic=[self.thirdArray objectAtIndex:indexPath.row];
            for (int i=0; i<self.thirdArray.count; i++) {
                UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                UIImageView *rightView=(UIImageView *)[cell.contentView viewWithTag:88888];
                rightView.hidden=YES;
                [cell.textLabel setTextColor:[UIColor blackColor]];
            }
            UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            UIImageView *rightView=(UIImageView *)[cell.contentView viewWithTag:88888];
            rightView.hidden=YES;
            [cell.textLabel setTextColor:[UIColor blueColor]];
            if ([[thirdDic objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                NSArray *listArray=(NSArray *)[thirdDic objectForKey:@"list"];
                if (listArray.count>0) {
                    rightView.hidden=NO;
                    //thirdTempIndex=indexPath.row;
                    self.thirdLeftCurrentIndex=indexPath.row;
                    [rightTableV reloadData];
                    return;
                }
            }
            self.thirdLeftCurrentIndex=indexPath.row;
            thirdTempIndex=self.thirdLeftCurrentIndex;
        }
    }else if (tableView==rightTableV){
        if (self.selectSegmentValue==0) {
            firstTempIndex=self.firstLeftCurrentIndex;
            self.firstRightCurrentIndex=indexPath.row;
        }else if (self.selectSegmentValue==1){
            secondTempIndex=self.secondLeftCurrentIndex;
            self.secondRightCurrentIndex=indexPath.row;
        }else if (self.selectSegmentValue==2){
            thirdTempIndex=self.thirdLeftCurrentIndex;
            self.thirdRightCurrentIndex=indexPath.row;
        }
    }
    NSString *titleForSelectedBtn=[self.segmentTitleArray objectAtIndex:self.selectSegmentValue];
    NSString *textForLeftSelectedCell=@"";
    NSString *textForRightSelectedCell=@"";
    int leftIndex=-1;
    int rightIndex=-1;
    if (self.selectSegmentValue==0) {
        self.firstLeftCurrentIndex=firstTempIndex;
        leftIndex=firstTempIndex;
        rightIndex=self.firstRightCurrentIndex;
        textForLeftSelectedCell=[[self.firstArray objectAtIndex:leftIndex] objectForKey:@"area"];
        textForRightSelectedCell=[[[self.firstArray objectAtIndex:leftIndex] objectForKey:@"listarea"] objectAtIndex:rightIndex];
    }else if (self.selectSegmentValue==1){
        self.secondLeftCurrentIndex=secondTempIndex;
        leftIndex=secondTempIndex;
        rightIndex=self.secondRightCurrentIndex;
        textForLeftSelectedCell=[[self.secondArray objectAtIndex:leftIndex] objectForKey:@"name"];
        textForRightSelectedCell=[[[self.secondArray objectAtIndex:leftIndex] objectForKey:@"list"] objectAtIndex:rightIndex];
    }else if (self.selectSegmentValue==2){
        self.thirdLeftCurrentIndex=thirdTempIndex;
        leftIndex=thirdTempIndex;
        rightIndex=self.thirdRightCurrentIndex;
        textForLeftSelectedCell=[[self.thirdArray objectAtIndex:leftIndex] objectForKey:@"name"];
        textForRightSelectedCell=[[[self.thirdArray objectAtIndex:leftIndex] objectForKey:@"list"] objectAtIndex:rightIndex];
    }
    [self.delegate siftConditionViewSelectedSegmentIndex:self.selectSegmentValue didSelectedLeftTableVCellString:textForLeftSelectedCell leftSelectedCellIndex:leftIndex didSelectedRightTableVCellString:textForRightSelectedCell rightSelectedCellIndex:rightIndex title:titleForSelectedBtn];
}

@end

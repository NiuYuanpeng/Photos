//
//  XYSiftConditionView.m
//  YKHouse
//
//  Created by wjl on 15/1/19.
//  Copyright (c) 2015年 wjl. All rights reserved.
//

#import "XYSiftConditionView.h"

@implementation XYSiftConditionView

@synthesize leftTableV;
@synthesize rightTableV;
@synthesize segmentTitleArray=_segmentTitleArray;
@synthesize firstArray=_firstArray;
@synthesize secondArray=_secondArray;
@synthesize thirdArray=_thirdArray;
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
    }
    return self;
}
-(void)initSegmentTitle:(NSArray *)titles{
    conditionIndexs = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.segmentTitleArray.count; i++) {
        XYSiftConditionIndex *conditionIndex = [[XYSiftConditionIndex alloc] init];
        conditionIndex.willSelectLeftIndex = 0;
        conditionIndex.didSelectLeftIndex = conditionIndex.willSelectLeftIndex;
        conditionIndex.didSelectRightIndex= -1;
        [conditionIndexs addObject:conditionIndex];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
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
        XYSiftConditionIndex *conditionIndex = (XYSiftConditionIndex *)[conditionIndexs objectAtIndex:self.selectSegmentValue];
        if (self.selectSegmentValue == 0) {
            if (self.firstArray.count>0) {
                NSDictionary *dic=[self.firstArray objectAtIndex:conditionIndex.willSelectLeftIndex];
                if ([[dic objectForKey:@"listarea"] isKindOfClass:[NSArray class]]) {
                    NSArray *rightArray=[dic objectForKey:@"listarea"];
                    return rightArray.count;
                }
            }
        }else {
            NSDictionary *dic = nil;
            if (self.selectSegmentValue == 1) {
                if (self.secondArray.count > 0){
                    dic = [self.secondArray objectAtIndex:conditionIndex.willSelectLeftIndex];
                }
            }else if (self.selectSegmentValue == 2){
                if (self.thirdArray.count > 0){
                    dic = [self.thirdArray objectAtIndex:conditionIndex.willSelectLeftIndex];
                }
            }
            //NSLog(@"%@",dic);
            if ([[dic objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                NSArray *rightArray=[dic objectForKey:@"list"];
                //NSLog(@"%d",rightArray.count);
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
    XYSiftConditionIndex *conditionIndex = (XYSiftConditionIndex *)[conditionIndexs objectAtIndex:self.selectSegmentValue];
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
            if (conditionIndex.didSelectLeftIndex == indexPath.row) {
                [cell.textLabel setTextColor:[UIColor blueColor]];
            }
            if ([[firstDic objectForKey:@"listarea"] isKindOfClass:[NSArray class]]) {
                NSArray *listAreaArray=(NSArray *)[firstDic objectForKey:@"listarea"];
                if (listAreaArray.count>0 && conditionIndex.willSelectLeftIndex == indexPath.row) {
                    rightView.hidden=NO;
                }
            }
        }else{
            NSDictionary *secondOrThirdDic = nil;
            if (self.selectSegmentValue == 1) {
                secondOrThirdDic = [self.secondArray objectAtIndex:indexPath.row];
            }else if (self.selectSegmentValue == 2){
                secondOrThirdDic = [self.thirdArray objectAtIndex:indexPath.row];
            }
            cell.textLabel.text = [secondOrThirdDic objectForKey:@"name"];
            if (conditionIndex.didSelectLeftIndex == indexPath.row) {
                [cell.textLabel setTextColor:[UIColor blueColor]];
            }
            if ([[secondOrThirdDic objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                NSArray *listArray = (NSArray *)[secondOrThirdDic objectForKey:@"list"];
                if (listArray.count > 0 && conditionIndex.willSelectLeftIndex == indexPath.row) {
                    rightView.hidden = NO;
                }
            }
        }
    }else if(tableView==rightTableV){
        line.hidden=NO;
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.backgroundColor=[UIColor clearColor];
        if (self.selectSegmentValue == 0) {
            NSDictionary *firstDic=[self.firstArray objectAtIndex:conditionIndex.willSelectLeftIndex];
            NSArray *rightArray=(NSArray *)[firstDic objectForKey:@"listarea"];
            NSString *strUrl = [[rightArray objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@""];
            cell.textLabel.text=strUrl;
            
            if (conditionIndex.willSelectLeftIndex == conditionIndex.didSelectLeftIndex) {
                if (indexPath.row==conditionIndex.didSelectRightIndex) {
                    [cell.textLabel setTextColor:[UIColor blueColor]];
                    cell.backgroundColor=[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
                }
            }
            
        } else {
            NSDictionary *secondOrThirdDic = nil;
            if (self.selectSegmentValue == 1) {
                secondOrThirdDic = [self.secondArray objectAtIndex:conditionIndex.willSelectLeftIndex];
            }else if (self.selectSegmentValue == 2){
                secondOrThirdDic = [self.thirdArray objectAtIndex:conditionIndex.willSelectLeftIndex];
            }
            NSArray *rightArray=(NSArray *)[secondOrThirdDic objectForKey:@"list"];
            cell.textLabel.text = [rightArray objectAtIndex:indexPath.row];
            if (conditionIndex.willSelectLeftIndex == conditionIndex.didSelectLeftIndex) {
                if (indexPath.row==conditionIndex.didSelectRightIndex) {
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
    XYSiftConditionIndex *conditionIndex = (XYSiftConditionIndex *)[conditionIndexs objectAtIndex:self.selectSegmentValue];
    //
    if (tableView==leftTableV) {
        //切换选项的时候保持选中的index
        if (indexPath.row == 0) {
           conditionIndex.willSelectLeftIndex = conditionIndex.didSelectLeftIndex; 
        }
        if (self.selectSegmentValue==0) {
            if (indexPath.row==conditionIndex.willSelectLeftIndex) {
                NSDictionary *firstDic=[self.firstArray objectAtIndex:indexPath.row];
                if ([[firstDic objectForKey:@"listarea"] isKindOfClass:[NSArray class]]) {
                    NSArray *listAreaArray=(NSArray *)[firstDic objectForKey:@"listarea"];
                    if (listAreaArray.count>0) {
                        rightTableV.hidden=NO;
                        [rightTableV reloadData];
                    }
                }
            }
        }else {
            if (indexPath.row == conditionIndex.willSelectLeftIndex) {
                NSDictionary *secondOrThirdDic = nil;
                if (self.selectSegmentValue == 1) {
                    secondOrThirdDic = [self.secondArray objectAtIndex:indexPath.row];
                }else if (self.selectSegmentValue == 2) {
                    secondOrThirdDic = [self.thirdArray objectAtIndex:indexPath.row];
                }
                if ([[secondOrThirdDic objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                    NSArray *listArray = (NSArray *)[secondOrThirdDic objectForKey:@"list"];
                    if (listArray.count > 0) {
                        rightTableV.hidden = NO;
                        [rightTableV reloadData];
                    }
                }
            }
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYSiftConditionIndex *conditionIndex = (XYSiftConditionIndex *)[conditionIndexs objectAtIndex:self.selectSegmentValue];
    
    if (tableView==leftTableV) {
        if (self.selectSegmentValue == 0) {
            for (int i=0; i<self.firstArray.count; i++) {//清楚蓝色字体
                UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                UIImageView *rightView=(UIImageView *)[cell.contentView viewWithTag:88888];
                rightView.hidden=YES;
                [cell.textLabel setTextColor:[UIColor blackColor]];
            }
        }else if (self.selectSegmentValue == 1){
            for (int i=0; i<self.secondArray.count; i++) {//清楚蓝色字体
                UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                UIImageView *rightView=(UIImageView *)[cell.contentView viewWithTag:88888];
                rightView.hidden=YES;
                [cell.textLabel setTextColor:[UIColor blackColor]];
            }
        }for (int i=0; i<self.thirdArray.count; i++) {//清楚蓝色字体
            UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            UIImageView *rightView=(UIImageView *)[cell.contentView viewWithTag:88888];
            rightView.hidden=YES;
            [cell.textLabel setTextColor:[UIColor blackColor]];
        }
        
        
        
        UITableViewCell *selectedCell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        UIImageView *selectedRightView=(UIImageView *)[selectedCell.contentView viewWithTag:88888];
        selectedRightView.hidden=NO;
        [selectedCell.textLabel setTextColor:[UIColor blueColor]];
        
        if (self.selectSegmentValue==0) {
            
            NSDictionary *firstDic=[self.firstArray objectAtIndex:indexPath.row];
            //NSLog(@"%d",self.firstArray.count);
            
            if ([[firstDic objectForKey:@"listarea"] isKindOfClass:[NSArray class]]) {
                NSArray *listAreaArray=(NSArray *)[firstDic objectForKey:@"listarea"];
                if (listAreaArray.count>0) {
                    conditionIndex.willSelectLeftIndex = indexPath.row;
                    rightTableV.hidden = NO;
                    [rightTableV reloadData];
                    return;
                }else if (listAreaArray.count == 0){
                    conditionIndex.willSelectLeftIndex = indexPath.row;
                    conditionIndex.didSelectLeftIndex = indexPath.row;
                    conditionIndex.didSelectRightIndex = -1;
                }
            }
        }else {
            NSDictionary *secondOrThirdDic = nil;
            if (self.selectSegmentValue == 1) {
                secondOrThirdDic = [self.secondArray objectAtIndex:indexPath.row];
            }else if (self.selectSegmentValue == 2) {
                secondOrThirdDic = [self.thirdArray objectAtIndex:indexPath.row];
            }
            
            if ([[secondOrThirdDic objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                NSArray *listArray=(NSArray *)[secondOrThirdDic objectForKey:@"list"];
                if (listArray.count>0) {
                    rightTableV.hidden = NO;
                    conditionIndex.willSelectLeftIndex=indexPath.row;
                    [rightTableV reloadData];
                    return;
                }
            }
            conditionIndex.willSelectLeftIndex = indexPath.row;
            conditionIndex.didSelectLeftIndex = indexPath.row;
            conditionIndex.didSelectRightIndex = -1;
        }
    }else if (tableView==rightTableV){
        conditionIndex.didSelectLeftIndex = conditionIndex.willSelectLeftIndex;
        conditionIndex.didSelectRightIndex = indexPath.row;
    }
    NSString *titleForSelectedBtn=[self.segmentTitleArray objectAtIndex:self.selectSegmentValue];
    NSString *textForLeftSelectedCell=@"";
    NSString *textForRightSelectedCell=@"";
    //NSLog(@"didSelectRightIndex:%ld",(long)conditionIndex.didSelectRightIndex);
    //NSLog(@"didSelectLeftIndexL:%ld",(long)conditionIndex.didSelectLeftIndex);
    if (self.selectSegmentValue==0) {
        textForLeftSelectedCell=[[self.firstArray objectAtIndex:conditionIndex.didSelectLeftIndex] objectForKey:@"area"];
        if (conditionIndex.didSelectRightIndex > -1) {
            textForRightSelectedCell=[[[self.firstArray objectAtIndex:conditionIndex.didSelectLeftIndex] objectForKey:@"listarea"] objectAtIndex:conditionIndex.didSelectRightIndex];
        }
    }else if (self.selectSegmentValue==1){
        textForLeftSelectedCell=[[self.secondArray objectAtIndex:conditionIndex.didSelectLeftIndex] objectForKey:@"name"];
        textForRightSelectedCell=[[[self.secondArray objectAtIndex:conditionIndex.didSelectLeftIndex] objectForKey:@"list"] objectAtIndex:conditionIndex.didSelectRightIndex];
    }else if (self.selectSegmentValue==2){
        textForLeftSelectedCell=[[self.thirdArray objectAtIndex:conditionIndex.didSelectLeftIndex] objectForKey:@"name"];
        textForRightSelectedCell=[[[self.thirdArray objectAtIndex:conditionIndex.didSelectLeftIndex] objectForKey:@"list"] objectAtIndex:conditionIndex.didSelectRightIndex];
    }
    [self.delegate siftConditionViewSelectedSegmentIndex:self.selectSegmentValue didSelectedLeftTableVCellString:textForLeftSelectedCell leftSelectedCellIndex:conditionIndex.didSelectLeftIndex didSelectedRightTableVCellString:textForRightSelectedCell rightSelectedCellIndex:conditionIndex.didSelectRightIndex title:titleForSelectedBtn];
}
@end

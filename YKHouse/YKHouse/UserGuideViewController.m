//
//  UserGuideViewController.m
//  YKHouse
//
//  Created by wjl on 14-7-16.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "UserGuideViewController.h"
#import "UIDevice+Resolutions.h"
@interface UserGuideViewController ()

@end

@implementation UserGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([UIDevice isRunningOniPhone5]) {
        _showPics = [NSMutableArray arrayWithObjects:@"guide1-1136.png",@"guide2-1136.png",@"guide3-1136.png",nil];
    }else{
        _showPics = [NSMutableArray arrayWithObjects:@"guide1-960.png",@"guide2-960.png",@"guide3-960.png",nil];
    }
    showScView=[[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    showScView.delegate=self;
    showScView.showsHorizontalScrollIndicator = NO;
    showScView.contentSize=CGSizeMake([[UIScreen mainScreen] bounds].size.width*_showPics.count, self.view.bounds.size.height);
    showScView.pagingEnabled=YES;
    [showScView setBounces:NO];
    [self.view addSubview:showScView];
    
    for (int i=0; i<_showPics.count; i++) {
        UIImageView *imagev=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*i, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        imagev.backgroundColor=[UIColor blueColor];
        imagev.image=[UIImage imageNamed:[_showPics objectAtIndex:i]];
        [showScView addSubview:imagev];
        
        if (i == _showPics.count-1) {
            UIButton *goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //goBtn.backgroundColor=[UIColor redColor];
            imagev.userInteractionEnabled=YES;
            [goBtn addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
            goBtn.frame=CGRectMake((self.view.bounds.size.width-200)/2, self.view.bounds.size.height-110, 200, 40);
            [imagev addSubview:goBtn];
        }
    }
    
    // Do any additional setup after loading the view.
}
#pragma mark - UIScrollViewDelegate

//更改pageControl的currentPage
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // NSLog(@"scrollViewDidEndDecelerating");
    //int page=scrollView.contentOffset.x/showScView.bounds.size.width;
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)go{
    [self.delegate hiddenUserGuideVC];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

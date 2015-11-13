//
//  ShowHSPictureViewController.m
//  YKHouse
//
//  Created by wjl on 14-7-1.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "ShowHSPictureViewController.h"
#import "UIImageView+AFNetworking.h"
@interface ShowHSPictureViewController ()

@end

@implementation ShowHSPictureViewController
@synthesize showPics=_showPics;
@synthesize currentPage=_currentPage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _showPics=[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    self.navigationItem.title=[NSString stringWithFormat:@"%d/%d",self.currentPage,self.showPics.count];
    showScView=[[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height-60.0)];
    showScView.delegate=self;
    showScView.contentSize=CGSizeMake(self.view.bounds.size.width*self.showPics.count, self.view.bounds.size.height-60.0);
    showScView.pagingEnabled=YES;
    [self.view addSubview:showScView];
    float minimumScale = showScView.frame.size.width / showScView.frame.size.width;
    [showScView setMinimumZoomScale:minimumScale];
    [showScView setMaximumZoomScale:4];
    
    for (int i=0; i<self.showPics.count; i++) {
        UIImageView *imagev=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*i, 0, self.view.bounds.size.width , self.view.bounds.size.height)];
        imagev.tag=101+i;
        imagev.contentMode = UIViewContentModeScaleAspectFit;
        imagev.center=CGPointMake(showScView.center.x+self.view.bounds.size.width*i, showScView.center.y);
        [imagev setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureAddress,[self.showPics objectAtIndex:i]]] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"detailInfoDefault" ofType:@"png"]]];
        [showScView addSubview:imagev];
    }
    [showScView setContentOffset:CGPointMake(showScView.bounds.size.width*(self.currentPage-1), 0)];
    // Do any additional setup after loading the view.
}
#pragma mark - UIScrollViewDelegate

//更改pageControl的currentPage
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // NSLog(@"scrollViewDidEndDecelerating");
    int page=scrollView.contentOffset.x/showScView.bounds.size.width;
    self.navigationItem.title=[NSString stringWithFormat:@"%d/%d",page+1,self.showPics.count];
    
}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    UIImageView *imgview=(UIImageView *)[showScView viewWithTag:(scrollView.contentOffset.x/showScView.bounds.size.width)+101];
//    return imgview;
//}
//
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
//{
//    [scrollView setZoomScale:scale animated:NO];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

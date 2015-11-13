//
//  ScrollerShowView.m
//  YKang
//
//  Created by hnsi on 14-4-18.
//  Copyright (c) 2014年 hnsi. All rights reserved.
//

#import "ScrollerShowView.h"
#import "UIImageView+AFNetworking.h"

@implementation myImageView
@synthesize imageUrlPath;
@synthesize currentP=_currentP;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageUrlPath=@"dd";
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
@end


@implementation ScrollerShowView
@synthesize imageArray=_imageArray;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"广告图字数底色块.png"]];
        self.userInteractionEnabled=YES;
        headerView=[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        headerView.userInteractionEnabled=YES;
        headerView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"detailInfoDefault" ofType:@"png"]];
        [self addSubview:headerView];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    scrollView.delegate=self;
    scrollView.backgroundColor=[UIColor clearColor];
    [headerView addSubview:scrollView];
    
    scrollView.contentSize=CGSizeMake((self.bounds.size.width)*self.imageArray.count, -10.0);
    scrollView.pagingEnabled=YES;
    for (int i=0; i<self.imageArray.count; i++) {
        myImageView *scrollImageView=[[myImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width)*i, 0, self.bounds.size.width, self.bounds.size.height)];
        scrollImageView.tag=i+1;
       // - (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage
        [scrollImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureAddress,[self.imageArray objectAtIndex:i]]] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"detailInfoDefault" ofType:@"png"]]];
        scrollImageView.imageUrlPath=[NSString stringWithFormat:@"%@%@",PictureAddress,[self.imageArray objectAtIndex:i]];
        scrollImageView.currentP=i+1;
        scrollImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *_tapGestureRecognizer = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(tapOnimageViewBG:)];
        [scrollImageView addGestureRecognizer:_tapGestureRecognizer];
        [scrollView addSubview:scrollImageView];
    }
    
    UILabel *scrollViewTitle=[[UILabel alloc] initWithFrame:CGRectMake(20, self.bounds.size.height-62.0, self.bounds.size.width-40, 30)];
    //scrollViewTitle.text=[[self.imageArray objectAtIndex:0] objectForKey:@"title"];
    scrollViewTitle.textColor=[UIColor clearColor];
    scrollViewTitle.backgroundColor=[UIColor blackColor];
    scrollViewTitle.alpha=0.5;
    //[headerView addSubview:scrollViewTitle];
    
    UIPageControl *pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(self.bounds.size.width-28.0-150.0, self.bounds.size.height-27.0, 150, 20)];
    pageControl.numberOfPages=self.imageArray.count;
    if (!([[[UIDevice currentDevice] systemVersion] doubleValue]<6.0)) {
        pageControl.pageIndicatorTintColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"未选中点" ofType:@"png"]]];
        pageControl.currentPageIndicatorTintColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"选中点" ofType:@"png"]]];
    }
    [pageControl addTarget:self action:@selector(changeCurrentScrollView:) forControlEvents:UIControlEventValueChanged];
    [headerView addSubview:pageControl];
}
- (void)tapOnimageViewBG:(UITapGestureRecognizer *)tapGestureRecognizer
{
    myImageView *tapImgView=(myImageView *)tapGestureRecognizer.view;
    [self.delegate didSelectedImageViewForShowViewUrlpath:tapImgView.imageUrlPath currentPage:tapImgView.currentP];
}
//更改pageControl的currentPage
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // NSLog(@"scrollViewDidEndDecelerating");
    int page=-1;
    for (id obj in headerView.subviews)  {
        if ([obj isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scView=(UIScrollView *)obj;
            if (scrollView==scView) {
                float a=scrollView.contentOffset.x;
                page=floor(a/(self.bounds.size.width-40.0));
                NSLog(@"%d",page);
            }
        }else if ([obj isKindOfClass:[UIPageControl class]]){
            UIPageControl *myPageControl=(UIPageControl *)obj;
            if (page!=-1) {
                myPageControl.currentPage=page;
            }
        }else if ([obj isKindOfClass:[UILabel class]]){
            if (page!=-1) {
                //UILabel *lab=(UILabel *)obj;
                //lab.text=[[self.imageArray objectAtIndex:page] objectForKey:@"title"];
            }
        }
    }
}
//根据pageControl更改显示的scrollView
-(void)changeCurrentScrollView:(UIPageControl *)pageControl{
    for (id obj in headerView.subviews)  {
        if ([obj isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scView=(UIScrollView *)obj;
            scView.contentOffset=CGPointMake((self.bounds.size.width-40.0)*pageControl.currentPage, 0);
        }else if ([obj isKindOfClass:[UILabel class]]){
            //UILabel *lab=(UILabel *)obj;
            //lab.text=[[self.imageArray objectAtIndex:pageControl.currentPage] objectForKey:@"title"];
        }
    }
}
@end
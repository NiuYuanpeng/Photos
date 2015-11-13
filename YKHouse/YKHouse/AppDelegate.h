//
//  AppDelegate.h
//  YKHouse
//
//  Created by wjl on 14-5-10.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface  UINavigationBar(my)

@end

@implementation UINavigationBar(my)

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)didMoveToSuperview{
    //NSLog(@"drawRec未标题-1t");
	if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], UITextAttributeTextColor,nil]];
        if ([self respondsToSelector:@selector(setBarTintColor:)]) {
            self.barTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部导航底色.png"]];
            
        }else{
            self.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部导航底色.png"]];
        }
        self.translucent = NO;
        //self.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部导航底色.png"]];
        //[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部导航底色.png"]]];
        
        UIImageView *line=[[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.bounds.size.height-1.5, self.bounds.size.width, 1.5)];
        line.image=[UIImage imageNamed:@"底部导航-蓝色条640px-3px.png"];
        [self addSubview:line];
    }
    
}

@end

@interface  UINavigationItem(my)

@end

@implementation UINavigationItem(my)


- (void)drawRect:(CGRect)rect{
    //[super drawLayer: inContext:];
    //NSLog(@"didMoveToSuperview未标题-1t");
    [self setHidesBackButton:YES];
	if ([self respondsToSelector:@selector(setLeftBarButtonItem:animated:)]) {
        UIImageView *backImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        backImgView.image=[UIImage imageWithContentsOfFile:navBackBtnPath];
        UIBarButtonItem *backBarBtn=[[UIBarButtonItem alloc] initWithCustomView:backImgView];
        self.backBarButtonItem=backBarBtn;
    }
    
}

@end

@interface UITabBarController(custom)
- (void) setHidden:(BOOL)hidden;
@end
@implementation UITabBarController (custom)

- (void) setHidden:(BOOL)hidden{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float fHeight = screenRect.size.height;
    if(  UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ){
        fHeight = screenRect.size.width;
    }
    
    if(!hidden) fHeight -= self.tabBar.frame.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        for(UIView *view in self.view.subviews){
            if([view isKindOfClass:[UITabBar class]]){
                [view setFrame:CGRectMake(view.frame.origin.x, fHeight, view.frame.size.width, view.frame.size.height)];
            }else{
                if(hidden) [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, fHeight)];
            }
        }
    }completion:^(BOOL finished){
        if(!hidden){
            
            [UIView animateWithDuration:0.25 animations:^{
                
                for(UIView *view in self.view.subviews)
                {
                    if(![view isKindOfClass:[UITabBar class]])
                        [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, fHeight)];
                }
                
            }];
        }
    }];
    
}

@end
#import "BMapKit.h"
#import "AFNetWorkManager.h"
#import "ADViewController.h"
#import "UserGuideViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate,AFNetWorkManagerDelegate,BMKLocationServiceDelegate,ADViewControllerDelegate,UserGuideViewControllerDelegate>
{
    UINavigationController *xinHouseNav;
    UINavigationController *zuHouseNav;
    UINavigationController *erShouHouseNav;
    UINavigationController *geRenNav;
    UITabBarController *tabBarController;
    BMKMapManager* _mapManager;
}
@property (strong,nonatomic) BMKMapManager *mapManager;
@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)NSMutableDictionary *dic;
@end

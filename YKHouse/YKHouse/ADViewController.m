//
//  ADViewController.m
//  YKHouse
//
//  Created by wjl on 14-7-16.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "ADViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIDevice+Resolutions.h"

@interface ADViewController ()

@end

@implementation ADViewController
#define guideWidth 64.0
#define guideHeight 94.0
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
//    NSLog(@"screen-height:%f,width:%f",[[UIScreen mainScreen] bounds].size.height,[[UIScreen mainScreen] bounds].size.width);
//    NSLog(@"view:height:%f,width:%f",self.view.frame.size.height,self.view.frame.size.width);
//    NSLog(@"screen-height:%f,width:%f",[[UIScreen mainScreen] nativeBounds].size.height,[[UIScreen mainScreen] nativeBounds].size.width);
    
    adImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self imagePathInDirectories]]) {
        [adImageView setImage:[UIImage imageWithContentsOfFile:[self imagePathInDirectories]]];
    }else{
        NSString *imagePath=nil;
        if ([UIDevice isRunningOniPhone5]) {
            imagePath=[[NSBundle mainBundle] pathForResource:@"Default-568h@2x" ofType:@"png"];
            [adImageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
        }else{
            imagePath=[[NSBundle mainBundle] pathForResource:@"Default@2x" ofType:@"png"];
            [adImageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
        }
    }
    [self.view addSubview:adImageView];
    
    AFNetWorkManager *adAfNetWorkManager=[[AFNetWorkManager alloc] init];
    adAfNetWorkManager.delegate=self;
    [adAfNetWorkManager getADWithScreenH:[[UIScreen mainScreen] bounds].size.height];
    
    guideImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-guideWidth)/2.0, self.view.bounds.size.height-1.5*guideHeight, 64.0, 94.0)];
    guideImageView.image = [UIImage imageNamed:@"guide.png"];
    guideImageView.hidden = YES;
    [self.view addSubview:guideImageView];
    // Do any additional setup after loading the view.
}
#pragma marks - AFNetWorkManagerDelegate
-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    if (isSuccess) {
        NSLog(@"%@",resultDic);
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        NSString *adImageString=[NSString stringWithFormat:@"%@%@",PictureAddress,[[[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"] objectAtIndex:0] objectForKey:@"adurl"]];
        
        if (![[userDefault objectForKey:@"adImagePath"] isEqualToString:adImageString]) {
            [userDefault setObject:adImageString forKey:@"adImagePath"];
            UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:adImageString]]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                //将图片写到Documents文件中
                [adImageView setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"adImagePath"]] placeholderImage:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    guideImageView.hidden = NO;
                });
                [UIImagePNGRepresentation(img)writeToFile: [self imagePathInDirectories] atomically:YES];
            });
        }else{
            guideImageView.hidden = NO;
        }
    }
}

-(NSString *)imagePathInDirectories{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"advertImage.png"];
    NSLog(@"uniquePath:%@",uniquePath);
    return uniquePath;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"%d",guideImageView.hidden);
    if (!guideImageView.hidden) {
        NSLog(@"--%d",guideImageView.hidden);
        [self.delegate hiddenADVC];
    }
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

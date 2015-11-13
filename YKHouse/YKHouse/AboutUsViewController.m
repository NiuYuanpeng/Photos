//
//  AboutUsViewController.m
//  YKHouse
//
//  Created by wjl on 14-7-13.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        // your code
        NSLog(@"%d",motion);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"关于我们";
    logoImageView=[[UIImageView alloc] initWithFrame:CGRectMake(60, 20, 200, 200)];
    [self.view addSubview:logoImageView];
    
    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, logoImageView.frame.origin.y+logoImageView.frame.size.height+20, 220, self.view.bounds.size.height-logoImageView.frame.origin.y-logoImageView.frame.size.height-20)];
    contentLabel.numberOfLines=0;
    contentLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:contentLabel];
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"topViewBG.png"]];
    AFNetWorkManager *getAboutUsInfoNetWorkManager = [[AFNetWorkManager alloc] init];
    getAboutUsInfoNetWorkManager.delegate=self;
    [getAboutUsInfoNetWorkManager getAboutUsInfo];
    // Do any additional setup after loading the view.
}

#pragma afnetworkmanagerdelegate
-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    //NSLog(@"%@",resultDic);
    NSArray *list = [[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
    if (isSuccess && list.count > 0) {
        contentLabel.text = [[list objectAtIndex:0] objectForKey:@"aboutus"];
        NSString *imagePath=[[list objectAtIndex:0] objectForKey:@"aboutusurl"];
        NSArray *arr1 = [imagePath componentsSeparatedByString:@"["];
        if (arr1.count>0) {
            imagePath = [arr1 lastObject];
            NSArray *arr2 = [imagePath componentsSeparatedByString:@"]"];
            if (arr2.count>0) {
                imagePath = [arr2 firstObject];
            }
        }
        [logoImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureAddress,imagePath]] placeholderImage:nil];
        
    }
}
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

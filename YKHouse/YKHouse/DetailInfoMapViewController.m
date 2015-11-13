//
//  DetailInfoMapViewController.m
//  YKHouse
//
//  Created by wjl on 14-6-29.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "DetailInfoMapViewController.h"

@interface DetailInfoMapViewController ()

@end

@implementation DetailInfoMapViewController
@synthesize lat=_lat;
@synthesize lng=_lng;
@synthesize houseTitle=_houseTitle;
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
    self.navigationItem.title=self.houseTitle;
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, NavigationBarLineY, self.view.bounds.size.width, self.view.bounds.size.height)];
    _mapView.delegate=self;
    self.view = _mapView;
    _mapView.zoomLevel=18.0;
    if (![self.lat isKindOfClass:[NSNull class]]) {
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake([self.lat doubleValue],[self.lng doubleValue]) animated:NO];
        BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
        item.coordinate = CLLocationCoordinate2DMake([self.lat doubleValue],[self.lng doubleValue]);
        item.title = self.houseTitle;
        [_mapView addAnnotation:item];
    }else{
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake([[userDefault objectForKey:@"lat"] doubleValue],[[userDefault objectForKey:@"lng"] doubleValue]) animated:NO];
    }
    
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
-(void)viewDidAppear:(BOOL)animated{
//    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    image.image =[self getAnnotationImage:@"sign.png" subTitle:@"美素新城"];
//    [self.view addSubview:image];
}
#pragma marks - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
//        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationId"];
//        newAnnotationView.canShowCallout = NO;
//        newAnnotationView.image=[self getAnnotationImage:@"sign.png" subTitle:annotation.title];
//        return newAnnotationView;
        
        BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationId"];
        if (annotationView == nil) {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationId"];
            annotationView.canShowCallout = NO;
            annotationView.image=[self getAnnotationImage:@"sign.png" subTitle:annotation.title];
            //annotationView.image=[UIImage imageNamed:@"sign.png"];
        }
        return annotationView;
        
    }
    return nil;
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    BMKAnnotationView *annotationView=(BMKAnnotationView *)[views objectAtIndex:0];
    [annotationView setSelected:YES animated:NO];
}
-(float)getMaxAnnotationViewLabelWidth:(NSString *)firstString secString:(NSString *)secondString{
    CGSize firstStringSize = [firstString sizeWithFont:[UIFont boldSystemFontOfSize:24.0] constrainedToSize:CGSizeMake(self.view.frame.size.width-40.0, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize secondStringSize = [firstString sizeWithFont:[UIFont boldSystemFontOfSize:24.0] constrainedToSize:CGSizeMake(self.view.frame.size.width-40.0, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    if (firstStringSize.width>30.0||secondStringSize.width>30.0) {
        if (firstStringSize.width>secondStringSize.width) {
            return firstStringSize.width+10.0;
        }else{
            return secondStringSize.width+10.0;
        }
    }
    return 55.0;
}
-(UIImage *)getAnnotationImage:(NSString *)imageName subTitle:(NSString *)subString{
    float maxWidth=[self getMaxAnnotationViewLabelWidth:subString secString:@""];
    float viewForAnnotation=sqrtf(20.0*20.0+maxWidth/2*maxWidth/2);
    UIView *viewForImage=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 2*viewForAnnotation, viewForAnnotation)];
    UIImageView *imageOnView=[[UIImageView alloc] initWithFrame:viewForImage.frame];
    imageOnView.image=[UIImage imageNamed:imageName];
    [viewForImage addSubview:imageOnView];
    UILabel *subLabel=[[UILabel alloc]initWithFrame:CGRectMake(viewForAnnotation-maxWidth/2, (viewForAnnotation-30)/2, maxWidth, 20.0)];
    
    subLabel.text=subString;
    subLabel.textAlignment=NSTextAlignmentCenter;
    subLabel.textColor=[UIColor whiteColor];
    subLabel.font=[UIFont boldSystemFontOfSize:24.0];
    subLabel.backgroundColor=[UIColor clearColor];
    [viewForImage addSubview:subLabel];
    return [self getImageFromView:viewForImage];
}
-(UIImage *)getImageFromView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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

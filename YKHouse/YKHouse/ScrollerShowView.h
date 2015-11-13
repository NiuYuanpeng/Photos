//
//  ScrollerShowView.h
//  YKang
//
//  Created by hnsi on 14-4-18.
//  Copyright (c) 2014年 hnsi. All rights reserved.
//
@protocol ScrollerShowViewDelegate <NSObject>
@optional
-(void)didSelectedImageViewForShowViewUrlpath:(NSString *)urlpath currentPage:(int)curPage;

@end
#import <UIKit/UIKit.h>
@interface myImageView : UIImageView{
    NSString *imageUrlPath;
    int _currentP;
}
@property(nonatomic,strong)NSString *imageUrlPath;//图片对应的html
@property(assign)int currentP;
@end
@interface ScrollerShowView : UIView<UIScrollViewDelegate,ScrollerShowViewDelegate>
{
    NSMutableArray *_imageArray;
    UIImageView *headerView;
}
@property (nonatomic, assign)  id <ScrollerShowViewDelegate> delegate;
@property(nonatomic,strong)NSMutableArray *imageArray;
@end



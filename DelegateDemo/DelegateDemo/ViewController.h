//
//  ViewController.h
//  DelegateDemo
//
//  Created by 牛元鹏 on 15/11/18.
//  Copyright © 2015年 牛元鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneViewController.h"

@interface ViewController : UIViewController <OneVCDelegate>
@property (weak, nonatomic) IBOutlet UILabel *Label;

@property (weak, nonatomic) IBOutlet UIButton *pressCasting;

@end


//
//  UIDevice+Resolutions.h
//  YKHouse
//
//  Created by wjl on 14-7-16.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    // iPhone 1,3,3GS 标准分辨率(320x480px)
    UIDevice_iPhoneStandardRes      = 1,
    // iPhone 4,4S 高清分辨率(640x960px)
    UIDevice_iPhoneHiRes            = 2,
    // iPhone 5 高清分辨率(640x1136px)
    UIDevice_iPhoneTallerHiRes      = 3,
    // iPad 1,2 标准分辨率(1024x768px)
    UIDevice_iPadStandardRes        = 4,
    // iPad 3 High Resolution(2048x1536px)
    UIDevice_iPadHiRes              = 5,
    // iPhone 6 高清分辨率(750x1334px)
    UIDevice_iPhoneTaller6HiRes     = 6,
    // iPhone 6P 高清分辨率(1080x1920px)
    UIDevice_iPhoneTaller6PHiRes    = 7
}; typedef NSUInteger UIDeviceResolution;

@interface UIDevice(Resolutions)
/*
 当前设备的分辨率
 */
+ (UIDeviceResolution) currentResolution;

/*
  是否运行在iphone5以上
 */
+ (BOOL)isRunningOniPhone5;
/*
 是否运行在iphone上
 */
+ (BOOL)isRunningOniPhone;
@end

//
//  AppDelegate+Initialize.h
//  STUDIES
//
//  Created by happyi on 2019/3/12.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Initialize)

//程序初始化
-(void)initApplication;
//U-Share平台设置
-(void)configUSharePlatforms;
//SVProgressHUD初始化
-(void)initSVProgressHUD;
//百度地图初始化
-(void)initBaiduMap;

@end

NS_ASSUME_NONNULL_END

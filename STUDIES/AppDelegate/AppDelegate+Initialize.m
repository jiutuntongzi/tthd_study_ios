//
//  AppDelegate+Initialize.m
//  STUDIES
//
//  Created by happyi on 2019/3/12.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "AppDelegate+Initialize.h"
#import "BaseTabBarViewController.h"
#import "BaseNavigationController.h"
#import <UMShare/UMShare.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BMKLocationKit/BMKLocationComponent.h>

@implementation AppDelegate (Initialize)

#pragma mark - 应用初始化
-(void)initApplication
{
    
    NSLog(@"1111     %f", [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom);

    
    BaseTabBarViewController *baseTabBarVC = [[BaseTabBarViewController alloc] init];
    BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:baseTabBarVC];
    [baseNav setNavigationBarHidden:YES];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = baseNav;
}

#pragma mark - 分享平台设置
-(void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        
    }
    
    return result;
}

#pragma mark - SVP初始化
-(void)initSVProgressHUD
{
    [SVProgressHUD setFont:[UIFont systemFontOfSize:18]];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];//设置HUD的Style
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];//设置HUD和文本的颜色
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];//设置HUD的背景颜色
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMaximumDismissTimeInterval:1];
}

#pragma mark - 百度地图初始化
-(void)initBaiduMap
{
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"DldyQLDWUsKTEauQm4bGByX0gYVYcAG0" authDelegate:nil];
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [mapManager start:@"DldyQLDWUsKTEauQm4bGByX0gYVYcAG0" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed");
    }else{
        NSLog(@"manager start success");
    }
}

@end

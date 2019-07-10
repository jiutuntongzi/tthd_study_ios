//
//  RequestManager.m
//  STUDIES
//
//  Created by happyi on 2019/4/3.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager

-(instancetype)init
{
    if (self = [super init]) {
        BANetManagerShare.isOpenLog = YES;
    }
    
    return self;
}

-(NSDictionary *)baseParameter
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"",       @"appkey",
                         @"",          @"sign",
                         nil];
    
    return dic;
}

#pragma mark - 当前网络类型
+(void)networkType
{
    [BANetManager ba_startNetWorkMonitoringWithBlock:^(BANetworkStatus status) {
        NSString *msg;
        UIView *parentView = [UIApplication sharedApplication].keyWindow;
        switch (status) {
            case 0:
            {
                msg = @"未知网络";
                [QMUITips showError:msg inView:parentView hideAfterDelay:2];
            }
                break;
            case 1:
            {
                msg = @"没有网络";
                [QMUITips showError:msg inView:parentView hideAfterDelay:2];
            }
                break;
            case 2:
            {
                msg = @"您的网络类型为：手机 3G/4G 网络";
                [QMUITips showSucceed:msg inView:parentView hideAfterDelay:2] ;
                
            }
                break;
            case 3:
            {
                msg = @"您的网络类型为：wifi 网络";
                [QMUITips showSucceed:msg inView:parentView hideAfterDelay:2];
            }
                break;
                
            default:
                break;
        }
    }];
}


@end

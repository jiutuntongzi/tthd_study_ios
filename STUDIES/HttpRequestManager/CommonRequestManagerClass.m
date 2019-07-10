//
//  CommonRequestManagerClass.m
//  STUDIES
//
//  Created by happyi on 2019/5/27.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "CommonRequestManagerClass.h"

@implementation CommonRequestManagerClass

#pragma mark - 获取首页banner
-(void)getBannerWithPosition:(NSString *)position requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      position, @"position",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_GETWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            [self.delegate requestSuccess:response[@"data"][@"list"] requestName:requestName];
        }else{
            [self.delegate requestFailure:nil requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 上传图片
-(void)uploadImages:(NSArray<UIImage *> *)images fileNames:(NSArray<NSString *> *)fileNames requestName:(NSString *)requestName
{
    BAImageDataEntity *entity = [BAImageDataEntity new];
    entity.imageArray = images;
    entity.imageType = @"jpeg/png";
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.imageScale = 0.5;
    entity.fileNames = fileNames;
    BANetManagerShare.isOpenLog = YES;
    [BANetManager ba_uploadImageWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            
            NSLog(@"11111111111111111111111");
            
            [self.delegate requestSuccess:response[@"data"] requestName:requestName];
        }
    } failurBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - 投诉举报
-(void)getReportWithPosition:(NSString *)position content:(NSString *)content complaints:(NSString *)complaints foreignId:(NSString *)foreignId token:(NSString *)token requestName:(NSString *)requestName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      position, @"position",
                                      content, @"content",
                                      complaints, @"complaints",
                                      foreignId, @"foreign_id",
                                      token, @"token",
                                      nil];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, requestName];
    entity.parameters = parameter;
    [entity setNeedCache:NO];
    
    [BANetManager ba_request_GETWithEntity:entity successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            [self.delegate requestSuccess:response[@"data"] requestName:requestName];
        }
    } failureBlock:^(NSError *error) {
        
        [self.delegate requestFailure:nil requestName:requestName];
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

@end

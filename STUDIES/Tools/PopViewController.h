//
//  PopViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/10.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopViewController : QMUIModalPresentationViewController

/** 提交的回调 */
@property(nonatomic, copy) void(^submitBlock)(NSString *reason);
/** 内容 */
@property(nonatomic, strong) NSString *content;

@end


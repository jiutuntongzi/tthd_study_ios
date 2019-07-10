//
//  MineHeaderView.h
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
#import "UserIndexModel.h"

@interface MineHeaderView : UIView
{
    UIImageView *_avatarImageView;
    QMUIButton *_dynamicButton;
    QMUIButton *_followsButton;
    QMUIButton *_fansButton;
}
/** 名称 */
@property (nonatomic, strong) QMUILabel *nameLabel;
/** 简介 */
@property (nonatomic, strong) QMUILabel *desLabel;
/** 未登录提示 */
@property (nonatomic, strong) UIButton *unloginButton;
/** 用户信息 */
@property (nonatomic, strong) UserInfoModel *infoModel;
/** 用户首页信息 */
@property (nonatomic, strong) UserIndexModel *indexModel;

/** 点击设置的block */
@property (nonatomic, copy) void(^setClickBlock)(void);
/** 点击动态的block */
@property (nonatomic, copy) void(^dynamicBlock)(void);
/** 点击关注的block */
@property (nonatomic, copy) void(^followBlock)(void);
/** 点击粉丝的block */
@property (nonatomic, copy) void(^fansBlock)(void);
/** 点击登录的block */
@property (nonatomic, copy) void(^loginBlock)(void);
/** 编辑的block */
@property (nonatomic, copy) void(^editBlock)(void);



@end


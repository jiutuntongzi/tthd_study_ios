//
//  Macros.h
//  STUDIES
//
//  Created by happyi on 2019/3/12.
//  Copyright © 2019 happyi. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

/** 基类相关 */
//TabBarView高度
#define BaseTabBarViewHeight            ([MyTools getPhoneType] == PhoneType_Screen_FULL ? 60 + 34 : 60)
//TabBarButton高度
#define BaseTabBarButtonHeight          60
//Nav高度
#define BaseNavViewHeight               49
//状态栏高度
#define BaseStatusViewHeight            ([MyTools getPhoneType] == PhoneType_Screen_FULL ? 44 : 20)
//状态栏颜色
#define BaseStatusBarColor              UIColorMakeWithHex(@"#94CDC0")
//导航栏颜色
#define BaseNavBarColor                 UIColorMakeWithHex(@"#94CDC0")
//背景基础色
#define BaseBackgroundColor             UIColorMakeWithHex(@"#FEFFFF")


/** UI相关 */
//首页Banner高度
#define Home_Banner_Height              ([MyTools getPhoneType] == PhoneType_Screen_FULL ? 250 : 230)
//首页Menu高度
#define Home_Menu_Height                200
//首页推荐高度
#define Home_Recommend_Height           70
//首页热门话题高度
#define Home_Hot_Height                 70
//首页人气直播高度
#define Home_Live_Height                200
//首页互动打call高度
#define Home_Interact_Height            230
//首页金牌导师高度
#define Home_Tearcher_Height            230
//首页热门路线高度
#define Home_Line_Height                200

/** 公共方法相关 */
//整型转字符串
#define StringWithInt(value)            [NSString stringWithFormat:@"%d", value]
//token
#define Token                           [MyTools userToken]

/** 网络请求相关 */
//banner位置
#define BannerPosition_Index            @"index"
#define BannerPosition_tutor            @"tutor"
#define BannerPosition_live             @"live"
#define BannerPosition_travels          @"travels"
#define BannerPosition_topic            @"topic"
#define BannerPosition_route            @"route"

//请求地址
#define BaseUrl                         @"https://teststudy.tthud.cn"
//获取验证码
#define GET_AUTHCODE                    @"/api/user/captcha"
//验证码登录
#define GET_LOGIN_CODE                  @"/api/user/mobilelogin"
//校验验证码
#define GET_CHECKCODE                   @"/api/validate/check_sms_correct"
//设置密码
#define GET_SETPWD                      @"/api/user/resetpwd"
//密码登录
#define GET_LOGIN_PWD                   @"/api/user/login"
//游记搜索
#define GET_NOTE_SEARCH                 @"/api/travels/search"
//游记详情
#define GET_NOTE_DETAIL                 @"/api/travels/detail"
//游记详情的评论列表
#define GET_NOTE_DETAIL_COMMENTS        @"/api/travels/more_reply"
//游记列表
#define GET_NOTE_LIST                   @"/api/travels/travels_list"
//获取banner
#define GET_BANNER                      @"/api/banner/lists"
//收藏游记
#define POST_NOTE_COLLECT               @"/api/travels/set_collect"
//关注用户
#define POST_FOLLOW_USER                @"/api/tutor/set_follow"
//回复列表
#define GET_NOTE_REPLY                  @"/api/travels/more_revert"
//首页
#define GET_HOME                        @"/api/index/index"
//路线热门主题
#define GET_LINE_HOTTHEME               @"/api/path/theme"
//路线热门目的地
#define GET_LINE_HOTDESTINATION         @"/api/path/hot_bourn"
//目的地路线
#define GET_LINE_DESTINATIONLINE        @"/api/path/bourn_search"
//目的地详情
#define GET_LINE_DETAIL                 @"/api/path/detail"
//路线搜索
#define GET_LINE_SEARCH                 @"/api/path/path_search"
//导师分类
#define GET_TEACHER_TYPE                @"/api/tutor/get_type"
//导师列表
#define GET_TEACHER_LIST                @"/api/tutor/sort_search"
//导师搜索
#define GET_TEACHER_SEARCH              @"/api/tutor/like_search"
//导师详情
#define GET_TEACHER_DETAIL              @"/api/tutor/details"
//导师路线
#define GET_TEACHER_LINE                @"/api/path/tutor_path"
//导师评价
#define GET_TEACHER_EVALUATE            @"/api/tutor/get_evaluate"
//导师的粉丝或关注
#define GET_TEACHER_FANSORFOLLOWS       @"/api/tutor/attention"
//话题列表
#define GET_TOPIC_LIST                  @"/api/topics/lists"
//话题详情
#define GET_TOPIC_DETAIL                @"/api/topics/details"
//收藏夹
#define GET_USER_COLLECT                @"/api/travels/my_collect"
//上传头像
#define GET_UPLOAD_IMAGE                @"/api/common/upload"
//修改个人信息
#define POST_USER_INFO                  @"/api/user/profile"
//修改手机号码
#define GET_CHANGE_MOBILE               @"/api/user/changemobile"
//个人中心信息
#define GET_USER_INDEX                  @"/api/user/info"
//动态列表
#define GET_DYNAMIC_LIST                @"/api/dynamics/lists"
//关注用户
#define POST_FOLLOW_USER                @"/api/tutor/set_follow"
//投诉举报
#define GET_REPORT                      @"/api/report/add"
//点赞
#define POST_PRAISE                     @"/api/travels/set_live"
//发布游记
#define POST_NOTE_SUBMIT                @"/api/travels/add"
//收藏线路
#define POST_LINE_COLLECT               @"/api/path/set_collect"
//搜索话题
#define POST_TOPIC_SEARCH               @"/api/topics/search"
//发布动态
#define POST_DYNAMIC_SUBMIT             @"/api/dynamics/add"
//动态评论列表
#define POST_DYNAMIC_COMMENTLIST        @"/api/dynamics/commentsList"
//动态点赞列表
#define POST_DYNAMIC_LIKELIST           @"/api/dynamics/likelist"
//动态点赞
#define POST_DYNAMIC_PRAISE             @"/api/dynamics/like"
//发布导师评价
#define POST_TEACHER_EVALUTE            @"/api/tutor/set_evaluate"
//搜索动态
#define POST_DYNAMIC_SEARCH             @"/api/dynamics/search"
//发布游记评论
#define POST_NOTE_COMMENT               @"/api/travels/set_reply"
//发布动态评论
#define POST_DYNAMIC_COMMENT            @"/api/dynamics/comments"
//点赞动态评论
#define POST_PRAISE_DYNAMICCOMMENT      @"/api/dynamics/commentlike"
//首页搜索
#define POST_HOME_SEARCH                @"/api/index/search"
//关注话题
#define POST_FOLLOW_TOPIC               @"/api/topics/follow"
//关注的话题
#define GET_TOPIC_FOLLOWLIST            @"/api/topics/mine"
//用户详情游记列表
#define GET_USER_NOTELIST               @"/api/travels/user_search"

/** 数据库相关 */
//个人信息
#define T_USERINFO                      @"USERINFO"


/** 通知 */
//登录
#define NOTIFICATION_LOGIN              @"notification_login"

#endif /* Macros_h */

//
//  MineEditDesViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "MineEditDesViewController.h"
#import "UserReqeustManagerClass.h"
#import "UserInfoModel.h"

@interface MineEditDesViewController ()<QMUITextViewDelegate, RequestManagerDelegate>

/** 编辑框 */
@property (nonatomic, strong) QMUITextView *desTextView;
/** 确定按钮 */
@property (nonatomic, strong) QMUIButton *sureButton;
/** 请求类 */
@property (nonatomic, strong) UserReqeustManagerClass *requestManager;

@end

@implementation MineEditDesViewController

#pragma mark - lazy
-(QMUITextView *)desTextView
{
    if (!_desTextView) {
        _desTextView = [QMUITextView new];
        _desTextView.placeholder = @"输入您的简介";
        _desTextView.font = UIFontMake(17);
        _desTextView.layer.cornerRadius = 5;
        _desTextView.layer.borderColor = UIColorGray.CGColor;
        _desTextView.layer.borderWidth = 0.5;
        _desTextView.delegate = self;
        _desTextView.backgroundColor = UIColorMakeWithHex(@"#E5E5E5");
        _desTextView.maximumTextLength = 20;
        UserInfoModel *model = [UserInfoModel bg_findAll:T_USERINFO][0];
        _desTextView.text = model.bio;
    }
    
    return _desTextView;
}

-(QMUIButton *)sureButton
{
    if (!_sureButton) {
        _sureButton = [QMUIButton new];
        [_sureButton setTitle:@"确定" forState:0];
        [_sureButton setTitleColor:UIColorBlack forState:0];
        [_sureButton setBackgroundColor:UIColorMakeWithHex(@"#FFDD4F")];
        _sureButton.titleLabel.font = UIFontMake(16);
        _sureButton.layer.cornerRadius = 5;
        [_sureButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sureButton;
}

-(UserReqeustManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [UserReqeustManagerClass new];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"修改简介";
    
    [self.navView addSubview:self.sureButton];
    [self.view addSubview:self.desTextView];
    
    _sureButton.sd_layout
    .rightSpaceToView(self.navView, 15)
    .centerYEqualToView(self.navView)
    .widthIs(70)
    .heightIs(30);
    
    _desTextView.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, 10 + BaseNavViewHeight + BaseStatusViewHeight)
    .rightSpaceToView(self.view, 10)
    .heightIs(120);
}

-(void)submit
{
    [_desTextView resignFirstResponder];
    [self.requestManager postUserInfoWithAvatar:@""
                                       username:@""
                                       nickname:@""
                                            bio:_desTextView.text
                                       password:@""
                                         gender:@""
                                          token:Token
                                    requestName:POST_USER_INFO];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:POST_USER_INFO]) {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        UserInfoModel *model = [UserInfoModel bg_findAll:T_USERINFO][0];
        model.bio = _desTextView.text;
        [model bg_saveOrUpdate];
        self.editDesSuccessBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

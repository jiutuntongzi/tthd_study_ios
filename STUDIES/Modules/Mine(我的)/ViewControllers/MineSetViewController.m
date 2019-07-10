//
//  MineSetViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "MineSetViewController.h"
#import "MineUserInfoViewController.h"
#import "MineBindPhoneViewController.h"
#import "MineSetPasswordViewController.h"
#import "MineFeedbackViewController.h"
#import "MineAboutViewController.h"
#import "UserInfoModel.h"
#import "LoginViewController.h"

@interface MineSetViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 主视图 */
@property (nonatomic, strong) UITableView *mainTableView;
/** 缓存 */
@property (nonatomic, strong) NSString *cacheString;
@end

@implementation MineSetViewController

#pragma mark - lazy
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, BaseNavViewHeight + BaseStatusViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight + BaseStatusViewHeight) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _mainTableView.scrollEnabled = NO;
    }
    
    return _mainTableView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mainTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"设置";
    
    [self GetImageCacheSize];
    
    [self.view addSubview:self.mainTableView];
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 2;
    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UserInfoModel *model = [UserInfoModel new];
    if ([UserInfoModel bg_findAll:T_USERINFO].count > 0) {
        model = [UserInfoModel bg_findAll:T_USERINFO][0];
    }
    
    NSArray *section1 = @[@"个人信息", @"换绑手机", @"修改密码"];
    NSArray *section2 = @[@"清空缓存"];
    NSArray *section3 = @[@"帮助与反馈", @"关于我们"];
    
    QMUILabel *title = [MyTools labelWithText:@"" textColor:UIColorBlack textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    [cell.contentView addSubview:title];
    
    QMUILabel *content = [MyTools labelWithText:@"" textColor:UIColorMakeWithHex(@"#333333") textFont:UIFontMake(14) textAlignment:NSTextAlignmentRight];
    [cell.contentView addSubview:content];
    
    if (indexPath.section == 0) {
        title.text = section1[indexPath.row];
        if (indexPath.row == 1) {
            content.text = model.mobile.length == 0 ? @"未绑定" : model.mobile;
        }
    }
    if (indexPath.section == 1) {
        title.text = section2[indexPath.row];
        content.text = _cacheString;
    }
    if (indexPath.section == 2) {
        title.text = section3[indexPath.row];
        if (indexPath.row == 1) {
            content.text = @"版本1.0.1";
        }
    }
    if (indexPath.section == 3) {
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    title.sd_layout
    .leftSpaceToView(cell.contentView, 15)
    .topSpaceToView(cell.contentView, 5)
    .widthIs(120)
    .heightIs(40);
    
    content.sd_layout
    .rightSpaceToView(cell.contentView, 10)
    .centerYEqualToView(title)
    .widthIs(120)
    .heightIs(40);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (!Token) {
                [self login];
                return;
            }
            [self.navigationController pushViewController:[MineUserInfoViewController new] animated:YES];
        }
        if (indexPath.row == 1) {
            if (!Token) {
                [self login];
                return;
            }
            [self.navigationController pushViewController:[MineBindPhoneViewController new] animated:YES];
        }
        if (indexPath.row == 2) {
            if (!Token) {
                [self login];
                return;
            }
            [self.navigationController pushViewController:[MineSetPasswordViewController new] animated:YES];
        }
    }
    if (indexPath.section == 1) {
        @weakify(self)
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            @strongify(self)
            [SVProgressHUD showSuccessWithStatus:@"缓存已清理"];
            self.cacheString = @"";
            [self.mainTableView reloadData];
        }];
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[MineFeedbackViewController new] animated:YES];
        }
        if (indexPath.row == 1) {
            [self.navigationController pushViewController:[MineAboutViewController new] animated:YES];
        }
    }
    if (indexPath.section == 3) {
        self.logoutBlock();
        [UserInfoModel bg_clear:T_USERINFO];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)login
{
    __weak __typeof (self)weakSelf = self;
    LoginViewController *loginVC = [LoginViewController new];
    loginVC.loginSuccessBlock = ^{
        [weakSelf.mainTableView reloadData];
    };
    [self presentViewController:loginVC animated:YES completion:nil];
}

-(void)GetImageCacheSize
{
    @weakify(self)
    [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        @strongify(self)
        double sizeKB = totalSize / 1024.0;
        NSString *sizeString = @"";
        if(sizeKB < 1024)
        {
            sizeString = [NSString stringWithFormat:@"%.1fKB",sizeKB];
        }
        else
        {
            double sizeMB = totalSize /1024.0 / 1024.0;
            if(sizeMB < 1024)
            {
                sizeString = [NSString stringWithFormat:@"%.1fMB",sizeMB];
            }
            else
            {
                double sizeGB = totalSize / 1024.0 / 1024.0 / 1024.0;
                sizeString = [NSString stringWithFormat:@"%.1fMB",sizeGB];
            }
        }
        
        self.cacheString = sizeString;
        [self.mainTableView reloadData];
    }];
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

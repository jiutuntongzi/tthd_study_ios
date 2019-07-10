//
//  DynamicUserViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/10.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicUserViewController.h"
#import "TeacherRequestManagerClass.h"
#import "UserModel.h"
#import "ChineseString.h"

@interface DynamicUserViewController ()<UITableViewDelegate, UITableViewDataSource, RequestManagerDelegate>

/** 请求类 */
@property (nonatomic, strong) TeacherRequestManagerClass *requestManager;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *userArray;
/** 列表 */
@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) NSMutableArray *indexArray;
@property (nonatomic, strong) NSMutableArray *letterResultArr;

@end

@implementation DynamicUserViewController

#pragma mark - lazy
-(TeacherRequestManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [TeacherRequestManagerClass new];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _userArray = [NSMutableArray array];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
    contentView.backgroundColor = UIColorWhite;
    
    UILabel *title = [MyTools labelWithText:@"联系人" textColor:UIColorMakeWithHex(@"#999999") textFont:UIFontMake(18) textAlignment:NSTextAlignmentCenter];
    title.backgroundColor = UIColorMakeWithHex(@"#F6F5F5");
    [contentView addSubview:title];
    
    QMUIButton *cancelBtn = [QMUIButton new];
    [cancelBtn setBackgroundImage:UIImageMake(@"teacher_icon_follow__selected") forState:0];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
    
    UISearchBar *mySearchBar = [[UISearchBar alloc] init];
    mySearchBar.placeholder = @"请输入关键字";
    mySearchBar.searchBarStyle = UISearchBarStyleDefault;
    mySearchBar.barStyle = UISearchBarStyleDefault;
    mySearchBar.backgroundImage = [[UIImage alloc] init];
    UIView *backgroundView = [mySearchBar subViewOfClassName:@"_UISearchBarSearchFieldBackgroundView"];
    backgroundView.layer.cornerRadius = 18;
    backgroundView.clipsToBounds = YES;
    backgroundView.layer.borderColor = UIColorMakeWithHex(@"#91CEC0").CGColor;
    backgroundView.layer.borderWidth = 1;
    [contentView addSubview:mySearchBar];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.sectionIndexColor = UIColorMakeWithHex(@"#999999");
    _mainTableView.tableFooterView = [UIView new];
    [contentView addSubview:_mainTableView];
    
    [self setContentView:contentView];
    
    __weak __typeof (self)weakSelf = self;
    [self setLayoutBlock:^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        contentView.frame = CGRectMake(0, BaseStatusViewHeight + BaseNavViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BaseStatusViewHeight - BaseNavViewHeight);
        
        title.sd_layout
        .leftEqualToView(contentView)
        .rightEqualToView(contentView)
        .topSpaceToView(contentView, 0)
        .heightIs(60);
        
        cancelBtn.sd_layout
        .leftSpaceToView(contentView, 15)
        .centerYEqualToView(title)
        .widthIs(20)
        .heightEqualToWidth();
        
        mySearchBar.sd_layout
        .leftSpaceToView(contentView, 30)
        .topSpaceToView(title, 0)
        .rightSpaceToView(contentView, 30)
        .heightIs(BaseNavViewHeight + 10);
        
        weakSelf.mainTableView.sd_layout
        .leftEqualToView(contentView)
        .topSpaceToView(mySearchBar, 0)
        .bottomSpaceToView(contentView, 0)
        .widthIs(SCREEN_WIDTH);
    }];
    
    [self setShowingAnimation:^(UIView * _Nullable dimmingView, CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewFrame, void (^ _Nonnull completion)(BOOL)) {
        contentView.frame = CGRectSetY(contentView.frame, CGRectGetHeight(containerBounds));
        dimmingView.alpha = 0;
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 1;
            contentView.frame = contentViewFrame;
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    }];
    
    [self setHidingAnimation:^(UIView * _Nullable dimmingView, CGRect containerBounds, CGFloat keyboardHeight, void (^ _Nonnull completion)(BOOL)) {
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 0.0;
            contentView.frame = CGRectSetY(contentView.frame, CGRectGetHeight(containerBounds));
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    }];
    
    UserInfoModel *model = [UserInfoModel bg_findAll:T_USERINFO][0];
    
    [self.requestManager getTeacherFansOrFollowsWithType:@"1"
                                                 aboutId:model.ub_id
                                               aboutType:@"1"
                                                userType:@"1"
                                                  offset:@"1"
                                                   limit:@"10"
                                                   token:Token
                                             requestName:GET_TEACHER_FANSORFOLLOWS];
}

-(void)cancelClick
{
    [self hideWithAnimated:YES completion:nil];
}

#pragma mark - 数据处理
-(void)handleUserDataWithData:(NSArray *)dataArray
{
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dic in dataArray) {
        UserModel *model = [[UserModel alloc] initModelWithDict:dic];
        [_userArray addObject:model];
        
        [temp addObject:dic[@"nickname"]];
    }
    
    _indexArray = [ChineseString IndexArray:_userArray];
    _letterResultArr = [ChineseString LetterSortArray:_userArray];
    
    [_mainTableView reloadData];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:GET_TEACHER_FANSORFOLLOWS]) {
        [self handleUserDataWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.letterResultArr objectAtIndex:section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = UIColorMakeWithHex(@"#F0FCF9");
    }
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
    
    NSDictionary *dic = self.letterResultArr[indexPath.section][indexPath.row];
    UserModel *model = (UserModel *)dic[@"content"];
    
    UIImageView *avatar = [UIImageView new];
    avatar.image = UIImageMake(@"avatar3.jpg");
    avatar.layer.masksToBounds = YES;
    avatar.frame = CGRectMake(10, 10, 40, 40);
    avatar.layer.cornerRadius = 20;
    [avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
    [cell.contentView addSubview:avatar];
    
    QMUILabel *name = [MyTools labelWithText:@"花想容" textColor:UIColorBlack textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    name.frame = CGRectMake(avatar.right + 10, 5, SCREEN_WIDTH - 100, 50);
    name.text = dic[@"name"];
    [cell.contentView addSubview:name];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.letterResultArr[indexPath.section][indexPath.row];
    UserModel *model = (UserModel *)dic[@"content"];
    self.selectUserBlock(model, _userArray);
    [self cancelClick];
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArray;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.indexArray[section];
}

@end

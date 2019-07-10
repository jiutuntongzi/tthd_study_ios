//
//  DynamicNoteViewController.m
//  STUDIES
//
//  Created by happyi on 2019/6/5.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicNoteViewController.h"
#import "NoteRequestManagerClass.h"
#import "MineNoteCell.h"

@interface DynamicNoteViewController ()<UITableViewDelegate, UITableViewDataSource, RequestManagerDelegate>

/** 请求类 */
@property (nonatomic, strong) NoteRequestManagerClass *requestManager;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *noteArray;
/** 列表 */
@property (nonatomic, strong) UITableView *mainTableView;
/** 加载页 */
@property (nonatomic, assign) int offset;

@end

@implementation DynamicNoteViewController

#pragma mark - lazy
-(NoteRequestManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [NoteRequestManagerClass new];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _noteArray = [NSMutableArray array];
    _offset = 1;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
    contentView.backgroundColor = UIColorWhite;
    
    UILabel *title = [MyTools labelWithText:@"我的游记" textColor:UIColorMakeWithHex(@"#999999") textFont:UIFontMake(18) textAlignment:NSTextAlignmentCenter];
    title.backgroundColor = UIColorMakeWithHex(@"#F6F5F5");
    [contentView addSubview:title];
    
    QMUIButton *cancelBtn = [QMUIButton new];
    [cancelBtn setBackgroundImage:UIImageMake(@"teacher_icon_follow__selected") forState:0];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.sectionIndexColor = UIColorMakeWithHex(@"#999999");
    [_mainTableView registerClass:[MineNoteCell class]
           forCellReuseIdentifier:NSStringFromClass([MineNoteCell class])];
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
        
        weakSelf.mainTableView.sd_layout
        .leftEqualToView(contentView)
        .topSpaceToView(title, 10)
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
    
    [self getNoteList];
}

-(void)cancelClick
{
    [self hideWithAnimated:YES completion:nil];
}

-(void)getNoteList
{
    [self.requestManager getSearchNoteWithKeyword:@""
                                             type:@"2"
                                           offset:StringWithInt(_offset)
                                            limit:@"10"
                                            token:Token
                                      requestName:GET_NOTE_SEARCH];
}

#pragma mark - 数据处理
-(void)handleNoteDataWithData:(NSArray *)dataArray
{
    if (_offset == 1) {
        [_noteArray removeAllObjects];
    }
    for (NSDictionary *dic in dataArray) {
        NoteSearchModel *model = [[NoteSearchModel alloc] initModelWithDict:dic];
        [_noteArray addObject:model];
    }
    
    [_mainTableView reloadData];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:GET_NOTE_SEARCH]) {
        [self handleNoteDataWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"提示";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没有游记，请先去发布吧";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _noteArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:_mainTableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MineNoteCell";
    MineNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.model = _noteArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedNoteBlock(_noteArray[indexPath.row]);
    [self cancelClick];
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

//
//  TeacherConditionViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/15.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "ConditionViewController.h"
#import "DimmingView.h"
@interface ConditionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation ConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    __weak __typeof (self)weakSelf = self;
    [self setContentView:_mainTableView];
    [self setLayoutBlock:^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        
        weakSelf.mainTableView.sd_layout
        .leftEqualToView(0)
        .topEqualToView(0)
        .widthIs(SCREEN_WIDTH)
        .heightIs(weakSelf.dataSourceArray.count >= 5 ? 5 * 50 : weakSelf.dataSourceArray.count * 50);
    }];
}

-(void)setDataSourceArray:(NSArray *)dataSourceArray
{
    _dataSourceArray = dataSourceArray;
    [_mainTableView reloadData];
}

-(void)setSelectedModel:(id)selectedModel
{
    _selectedModel = selectedModel;
    [_mainTableView reloadData];
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [_dataSourceArray[indexPath.row] name];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = UIFontMake(16);
    if (_dataSourceArray[indexPath.row] == _selectedModel) {
        cell.textLabel.textColor = UIColorMakeWithHex(@"#34BCB4");
    }else{
        cell.textLabel.textColor = UIColorBlack;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedTypeBlock(_dataSourceArray[indexPath.row]);
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

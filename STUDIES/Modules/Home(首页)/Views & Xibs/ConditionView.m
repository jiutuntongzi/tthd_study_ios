//
//  ConditionView.m
//  STUDIES
//
//  Created by happyi on 2019/3/20.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "ConditionView.h"

@implementation ConditionView

-(id)initWithFrame:(CGRect)frame condition:(nonnull NSString *)condition
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColorBlack colorWithAlphaComponent:0.5];
        self.condition = condition;
        [self initLayout];
    }

    return self;
}

-(void)initLayout
{
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, 0, self.width, 200);
    [self addSubview:_mainTableView];

    _mainTableView.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .heightIs(200)
    .widthIs(self.width);
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
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
    cell.textLabel.text = _dataSourceArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = UIFontMake(18);
    if ([_dataSourceArray[indexPath.row] isEqualToString:_condition]) {
        cell.textLabel.textColor = UIColorMakeWithHex(@"#34BCB4");
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _condition = _dataSourceArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(conditionViewDidSelectedIndex:)]) {
        [self.delegate conditionViewDidSelectedIndex:indexPath.row];
    }
    [self.mainTableView removeFromSuperview];
}

-(void)setDataSourceArray:(NSArray *)dataSourceArray
{
    _dataSourceArray = dataSourceArray;
    [_mainTableView reloadData];
}


@end

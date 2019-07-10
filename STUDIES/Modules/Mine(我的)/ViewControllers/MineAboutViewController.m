//
//  MineAboutViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "MineAboutViewController.h"

@interface MineAboutViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation MineAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"关于我们";
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = UIImageMake(@"avatar7.jpg");
    imageView.layer.cornerRadius = 50;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    
    QMUILabel *title = [MyTools labelWithText:@"我是研学生" textColor:UIColorMakeWithHex(@"#04BCB2") textFont:UIFontMake(18) textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:title];
    
    QMUILabel *version = [MyTools labelWithText:@"v1.0.2" textColor:UIColorMakeWithHex(@"#999999") textFont:UIFontMake(16) textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:version];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView];
    
    imageView.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight + 30)
    .widthIs(100)
    .heightEqualToWidth();
    
    title.sd_layout
    .topSpaceToView(imageView, 15)
    .centerXEqualToView(imageView)
    .widthIs(120)
    .heightIs(25);
    
    version.sd_layout
    .topSpaceToView(title, 0)
    .centerXEqualToView(title)
    .widthIs(120)
    .heightIs(25);
    
    tableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(version, 50)
    .widthIs(SCREEN_WIDTH)
    .heightIs(150);
}

#pragma mark - TableViewDelegate & TableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID
                ];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSArray *titles = @[@"去评分", @"分享给朋友", @"版本更新"];
    
    cell.textLabel.text = titles[indexPath.row];
    cell.textLabel.font = UIFontMake(15);
    cell.textLabel.textColor = UIColorMakeWithHex(@"#000000");
    
    return cell;
}

@end

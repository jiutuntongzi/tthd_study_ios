//
//  HomeMenuViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeMenuViewController.h"
#import "HomeMenuView.h"
#import "DimmingView.h"
@interface HomeMenuViewController ()

@end

@implementation HomeMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DimmingView *contentView = [[DimmingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    contentView.backgroundColor = UIColorClear;
    [self setContentView:contentView];
    
    HomeMenuView *menuView = [[HomeMenuView alloc] initWithFrame:CGRectZero];
    [contentView addSubview:menuView];
    
    [self setLayoutBlock:^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        menuView.sd_layout
        .rightSpaceToView(contentView, 15)
        .topSpaceToView(contentView, BaseNavViewHeight + BaseStatusViewHeight + 5)
        .widthIs(150)
        .heightIs(150);
    }];
    
    menuView.menuBlock = ^(ContentIndex index) {
        [self hideWithAnimated:YES completion:nil];
        if (index == Index_Submit) {
            NSLog(@"发布动态");
            self.dynamicBlock();
        }
        if (index == Index_Note) {
            NSLog(@"发布游记");
            self.noteBlock();
        }
        if (index == Index_Recruit) {
            NSLog(@"招募导师");
            self.recruitBlock();
        }        
    };
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

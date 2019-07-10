//
//  PopViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/10.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "PopViewController.h"

@interface PopViewController ()

/** 投诉理由 */
@property (nonatomic, strong) NSString *reason;

@end

@implementation PopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
    contentView.backgroundColor = UIColorWhite;
    
    QMUIButton *cancelBtn = [QMUIButton new];
    [cancelBtn setBackgroundImage:UIImageMake(@"teacher_icon_follow__selected") forState:0];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
    
    UILabel *title = [MyTools labelWithText:@"投诉" textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentCenter];
    [contentView addSubview:title];
    
//    UILabel *contentLabel = [MyTools labelWithText:@"投诉内容" textColor:UIColorBlack textFont:UIFontMake(16) textAlignment:NSTextAlignmentCenter];
//    contentLabel.backgroundColor = UIColorMakeWithHex(@"#F6F5F5");
//    [contentView addSubview:contentLabel];
    
    QMUIButton *submitBtn = [QMUIButton new];
    [submitBtn setTitle:@"提交" forState:0];
    [submitBtn setTitleColor:UIColorWhite forState:0];
    [submitBtn setBackgroundColor:UIColorMakeWithHex(@"#91CEC0")];
    submitBtn.titleLabel.font = UIFontMake(20);
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    if ([MyTools getPhoneType] == PhoneType_Screen_FULL) {
        submitBtn.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
    }
    [contentView addSubview:submitBtn];
    
    UIView *container = [UIView new];
    [contentView addSubview:container];
    
    NSArray *titles = @[@"垃圾营销", @"涉黄信息", @"有害信息", @"违法信息", @"侵犯人身权益"];
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < titles.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:0];
        [button setTitleColor:UIColorMakeWithHex(@"#666666") forState:0];
        [button setTitleColor:UIColorMakeWithHex(@"#38C0A1") forState:UIControlStateSelected];
        [button setBackgroundColor:UIColorWhite];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = UIFontMake(14);
        button.tag = i + 1000;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 5;
        button.layer.borderColor = UIColorMakeWithHex(@"#DCDCDC").CGColor;
        [container addSubview:button];
        [temp addObject:button];
        button.sd_layout.autoHeightRatio(0.4);
    }
    
    [container setupAutoMarginFlowItems:[temp copy] withPerRowItemsCount:3 itemWidth:SCREEN_WIDTH / 4 + 5  verticalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:0];
    
    CGFloat contentViewHeight = [MyTools getPhoneType] == PhoneType_Screen_FULL ? 300 : 270;
    CGFloat bottomButtonHeight = [MyTools getPhoneType] == PhoneType_Screen_FULL ? 70 : 50;
    
    [self setContentView:contentView];
    [self setLayoutBlock:^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        contentView.frame = CGRectMake(0, SCREEN_HEIGHT - contentViewHeight, SCREEN_WIDTH, contentViewHeight);
        
        cancelBtn.sd_layout
        .leftSpaceToView(contentView, 15)
        .topSpaceToView(contentView, 15)
        .widthIs(20)
        .heightEqualToWidth();
        
        title.sd_layout
        .leftEqualToView(contentView)
        .rightEqualToView(contentView)
        .centerYEqualToView(cancelBtn)
        .autoHeightRatio(0);
        
//        contentLabel.sd_layout
//        .leftEqualToView(cancelBtn)
//        .rightSpaceToView(contentView, 15)
//        .topSpaceToView(cancelBtn, 15)
//        .heightIs(60);
        
        submitBtn.sd_layout
        .leftEqualToView(contentView)
        .bottomSpaceToView(contentView, 0)
        .heightIs(bottomButtonHeight)
        .rightEqualToView(contentView);
        
        container.sd_layout
        .leftSpaceToView(contentView, 20)
        .rightSpaceToView(contentView, 20)
        .topSpaceToView(title, 35);
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
}

#pragma mark - 选择投诉理由
-(void)buttonClicked:(UIButton *)sender
{
    for (int i = 0; i < 8; i ++) {
        if (sender.tag == 1000 + i) {
            sender.selected = YES;
            sender.layer.borderWidth = 1;
            sender.layer.borderColor = UIColorMakeWithHex(@"#38C0A1").CGColor;
            self.reason = sender.titleLabel.text;
            continue;
        }
        
        UIButton *button = (UIButton *)[self.view viewWithTag:1000 + i];
        button.selected = NO;
        button.layer.borderColor = UIColorMakeWithHex(@"#DCDCDC").CGColor;
    }
}

#pragma mark - 提交
-(void)submitClick
{
    if ([self respondsToSelector:@selector(submitClick)]) {
        self.submitBlock(self.reason);
    }
    
    [self hideWithAnimated:YES completion:nil];
}

#pragma mark - 取消
-(void)cancelClick
{
    [self hideWithAnimated:YES completion:nil];
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

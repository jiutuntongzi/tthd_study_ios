//
//  TeacherDynamicCell.m
//  STUDIES
//
//  Created by happyi on 2019/3/25.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TeacherDynamicCell.h"
#import <UILabel+YBAttributeTextTapAction.h>
@implementation TeacherDynamicCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = BaseBackgroundColor;
        
        [self initLayout];
    }
    
    return self;
}

-(void)initLayout
{
    UIImageView *avatar = [UIImageView new];
    avatar.image = UIImageMake(@"avatar7.jpg");
    avatar.layer.cornerRadius = 22.5;
    avatar.layer.masksToBounds = YES;
    [self.contentView addSubview:avatar];
    
    QMUILabel *name = [MyTools labelWithText:@"花想容" textColor:UIColorBlack textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:name];
    
    QMUIButton *tag = [QMUIButton new];
    [tag setBackgroundImage:UIImageMake(@"teacher_icon_identifier_empty") forState:UIControlStateNormal];
    [self.contentView addSubview:tag];
    
    QMUILabel *time = [MyTools labelWithText:@"3分钟前" textColor:UIColorMakeWithHex(@"#999999") textFont:UIFontMake(14) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:time];
    
    QMUILabel *content = [MyTools labelWithText:@"#2019作诗大赛#云想衣裳花想容，春风拂槛露华浓，若非群玉山头见，会向瑶台月下逢 ♯链接" textColor:UIColorMakeWithHex(@"#323334") textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    content.numberOfLines = 0;
    content.attributedText = [self getAttributeWith:@[@"#2019作诗大赛#",@"♯链接"] string:content.text orginFont:15 orginColor:UIColorBlack attributeFont:15 attributeColor:UIColorMakeWithHex(@"#2CBBB4")];
    [content yb_addAttributeTapActionWithStrings:@[@"#2019作诗大赛#", @"♯链接"] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
        NSLog(@"%@", string);
    }];
    
    
    [self.contentView addSubview:content];
    
    UIView *container = [UIView new];
    [self.contentView addSubview:container];
    
    NSMutableArray *temp = [NSMutableArray new];
    NSArray *array = @[@"content6.jpg", @"content7.jpg", @"content8.jpg"];
    for (int i = 0; i < 3; i ++) {
        UIImageView *imageView = [UIImageView new];
        imageView.image = UIImageMake(array[i]);
        [container addSubview:imageView];
        imageView.sd_layout.autoHeightRatio(0.8);
        [temp addObject:imageView];
    }
    
    [container setupAutoMarginFlowItems:[temp copy] withPerRowItemsCount:3 itemWidth:SCREEN_WIDTH / 3.5
                         verticalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:0];
    
    QMUIButton *button1 = [[QMUIButton alloc] init];
    [button1 setImage:UIImageMake(@"teacher_icon_transmit") forState:UIControlStateNormal];
    [button1 setTitle:@"180" forState:UIControlStateNormal];
    [button1 setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];
    button1.imagePosition = QMUIButtonImagePositionLeft;
    button1.spacingBetweenImageAndTitle = 5;
    button1.titleLabel.font = UIFontMake(14);
    [self.contentView addSubview:button1];
    
    QMUIButton *button2 = [[QMUIButton alloc] init];
    [button2 setImage:UIImageMake(@"teacher_icon_comment") forState:UIControlStateNormal];
    [button2 setTitle:@"12w" forState:UIControlStateNormal];
    [button2 setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];
    button2.imagePosition = QMUIButtonImagePositionLeft;
    button2.spacingBetweenImageAndTitle = 5;
    button2.titleLabel.font = UIFontMake(14);
    [self.contentView addSubview:button2];
    
    QMUIButton *button3 = [[QMUIButton alloc] init];
    [button3 setImage:UIImageMake(@"teacher_icon_praise_normal") forState:UIControlStateNormal];
    [button3 setImage:UIImageMake(@"teacher_icon_praise_selected") forState:UIControlStateSelected];
    [button3 setTitle:@"12w" forState:UIControlStateNormal];
    [button3 setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];
    button3.imagePosition = QMUIButtonImagePositionLeft;
    button3.spacingBetweenImageAndTitle = 5;
    button3.titleLabel.font = UIFontMake(14);
    [self.contentView addSubview:button3];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorMakeWithHex(@"#AEAEAE");
    [self.contentView addSubview:line];
    
    avatar.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 15)
    .widthIs(45)
    .heightEqualToWidth();
    
    name.sd_layout
    .leftSpaceToView(avatar, 10)
    .topEqualToView(avatar)
    .widthIs(60)
    .autoHeightRatio(0);
    
    tag.sd_layout
    .leftSpaceToView(name, 10)
    .topEqualToView(name)
    .bottomEqualToView(name)
    .widthIs(55);
    
    time.sd_layout
    .leftEqualToView(name)
    .topSpaceToView(name, 5)
    .widthIs(150)
    .autoHeightRatio(0);
    
    content.sd_layout
    .leftEqualToView(avatar)
    .topSpaceToView(avatar, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(40);
    
    container.sd_layout
    .leftEqualToView(content)
    .topSpaceToView(content, 10)
    .rightSpaceToView(self.contentView, 15);
    
    button2.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(container, 10)
    .widthIs(60)
    .heightIs(20);
    
    button1.sd_layout
    .rightSpaceToView(button2, 80)
    .centerYEqualToView(button2)
    .widthIs(60)
    .heightIs(20);
    
    button3.sd_layout
    .leftSpaceToView(button2, 80)
    .centerYEqualToView(button2)
    .widthIs(60)
    .heightIs(20);
    
    line.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(button2, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(0.3);
    
    [self setupAutoHeightWithBottomView:line bottomMargin:10];
}


- (NSAttributedString *)getAttributeWith:(id)sender
                                  string:(NSString *)string
                               orginFont:(CGFloat)orginFont
                              orginColor:(UIColor *)orginColor
                           attributeFont:(CGFloat)attributeFont
                          attributeColor:(UIColor *)attributeColor
{
    __block  NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] initWithString:string];
    [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:orginFont] range:NSMakeRange(0, string.length)];
    [totalStr addAttribute:NSForegroundColorAttributeName value:orginColor range:NSMakeRange(0, string.length)];
    
    if ([sender isKindOfClass:[NSArray class]]) {
        
        __block NSString *oringinStr = string;
        __weak typeof(self) weakSelf = self;
        
        [sender enumerateObjectsUsingBlock:^(NSString *  _Nonnull str, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSRange range = [oringinStr rangeOfString:str];
            [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:attributeFont] range:range];
            [totalStr addAttribute:NSForegroundColorAttributeName value:attributeColor range:range];
            oringinStr = [oringinStr stringByReplacingCharactersInRange:range withString:[weakSelf getStringWithRange:range]];
        }];
        
    }else if ([sender isKindOfClass:[NSString class]]) {
        
        NSRange range = [string rangeOfString:sender];
        
        [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:attributeFont] range:range];
        [totalStr addAttribute:NSForegroundColorAttributeName value:attributeColor range:range];
    }
    return totalStr;
}

- (NSString *)getStringWithRange:(NSRange)range
{
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < range.length ; i++) {
        [string appendString:@" "];
    }
    return string;
}

@end

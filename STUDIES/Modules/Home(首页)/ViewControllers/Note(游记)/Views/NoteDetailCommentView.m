//
//  NoteDetailCommentView.m
//  STUDIES
//
//  Created by happyi on 2019/4/26.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "NoteDetailCommentView.h"

@implementation NoteDetailCommentView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    
    return self;
}

-(void)setSubViews
{
    UIView *line = [UIView new];
    line.backgroundColor = UIColorGray;
    [self addSubview:line];
    
    _favorButton = [[QMUIButton alloc] init];
    [_favorButton setImage:UIImageMake(@"teacher_icon_praise_normal") forState:UIControlStateNormal];
    [_favorButton setImage:UIImageMake(@"teacher_icon_praise_selected") forState:UIControlStateSelected];
    [_favorButton setTitle:@"12w" forState:UIControlStateNormal];
    [_favorButton setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];
    _favorButton.imagePosition = QMUIButtonImagePositionLeft;
    _favorButton.spacingBetweenImageAndTitle = 5;
    _favorButton.titleLabel.font = UIFontMake(14);
    [_favorButton addTarget:self action:@selector(favorClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_favorButton];
    
    _commentTextField = [QMUITextField new];
    _commentTextField.placeholder = @"回复楼主";
    _commentTextField.font = UIFontMake(16);
    _commentTextField.backgroundColor = UIColorMakeWithHex(@"#DDF0EF");
    _commentTextField.layer.cornerRadius = 20;
    _commentTextField.textInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self addSubview:_commentTextField];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_commentTextField addGestureRecognizer:tgr];
    
    line.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .heightIs(0.5);
    
    _favorButton.sd_layout
    .leftSpaceToView(self, 10)
    .topSpaceToView(self, 20)
    .widthIs(80)
    .heightIs(25);
    
    _commentTextField.sd_layout
    .leftSpaceToView(_favorButton, 10)
    .centerYEqualToView(_favorButton)
    .rightSpaceToView(self, 10)
    .heightIs(40);
}

-(void)setFavores:(NSString *)favores
{
    _favores = favores;
    [_favorButton setTitle:favores forState:0];
}

-(void)setIsFavored:(BOOL)isFavored
{
    _favorButton.selected = isFavored;
}

-(void)favorClick:(QMUIButton *)button
{
    button.selected = !button.selected;
    self.favorBlock();
}

-(void)tapAction
{
    self.tapTextFieldBlock();
}

@end

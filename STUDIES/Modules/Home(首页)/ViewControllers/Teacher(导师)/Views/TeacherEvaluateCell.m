//
//  TeacherEvaluateCell.m
//  STUDIES
//
//  Created by happyi on 2019/3/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TeacherEvaluateCell.h"
#import "CustomView.h"
@implementation TeacherEvaluateCell

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

-(void)prepareForReuse
{
    [super prepareForReuse];
}

-(void)initLayout
{
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = UIImageMake(@"avatar7.jpg");
    _avatarImageView.layer.cornerRadius = 25;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.backgroundColor = UIColorGreen;
    [self.contentView addSubview:_avatarImageView];
    
    _nameLabel = [MyTools labelWithText:@"花想容" textColor:UIColorBlack textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_nameLabel];
    
    _timeLabel = [MyTools labelWithText:@"3分钟前" textColor:UIColorMakeWithHex(@"#999999") textFont:UIFontMake(15) textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_timeLabel];
    
    _starView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(50, 200, 200, 50)];
    _starView.maximumValue = 5;
    _starView.minimumValue = 0;
    _starView.value = 5;
    _starView.spacing = 2;
    _starView.tintColor = [UIColor redColor];
    _starView.allowsHalfStars = YES;
    _starView.filledStarImage = UIImageMake(@"home_icon_star_fill");
    _starView.emptyStarImage = UIImageMake(@"home_icon_star_empty");
    _starView.halfStarImage = UIImageMake(@"home_icon_star_half");
    _starView.backgroundColor = UIColorClear;
    [self.contentView addSubview:_starView];
    
    _contenLabel = [MyTools labelWithText:@"#2019作诗大赛#云想衣裳花想容，春风拂槛露华浓，若非群玉山头见，会向瑶台月下逢链接" textColor:UIColorMakeWithHex(@"#323334") textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    _contenLabel.numberOfLines = 0;
    [self.contentView addSubview:_contenLabel];
    
    _containerView = [UIView new];
    [self.contentView addSubview:_containerView];
    
//    CustomView *replyView = [CustomView new];
//    replyView.backgroundColor = UIColorMakeWithHex(@"#F6F4F4");
//    replyView.layer.cornerRadius = 5;
//    [self.contentView addSubview:replyView];
//
//    QMUILabel *label = [MyTools labelWithText:@"导师回复:" textColor:UIColorMakeWithHex(@"#666666") textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
//    [replyView addSubview:label];
//
//    QMUILabel *replyTime = [MyTools labelWithText:@"2019-03-28" textColor:UIColorMakeWithHex(@"#666666") textFont:UIFontMake(15) textAlignment:NSTextAlignmentRight];
//    [replyView addSubview:replyTime];
//
//    QMUILabel *replyContent = [MyTools labelWithText:@"真真是极好的" textColor:UIColorMakeWithHex(@"#666666") textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
//    [replyView addSubview:replyContent];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorMakeWithHex(@"#AEAEAE");
    [self.contentView addSubview:line];
    
    _avatarImageView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 15)
    .widthIs(50)
    .heightEqualToWidth();
    
    _nameLabel.sd_layout
    .leftSpaceToView(_avatarImageView, 10)
    .topEqualToView(_avatarImageView)
    .heightIs(25);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _timeLabel.sd_layout
    .rightSpaceToView(self.contentView, 20)
    .centerYEqualToView(_nameLabel)
    .widthIs(150)
    .autoHeightRatio(0);
    
    _starView.sd_layout
    .topSpaceToView(_nameLabel, 5)
    .leftEqualToView(_nameLabel)
    .heightIs(20)
    .widthIs(80);
    
    _contenLabel.sd_layout
    .leftEqualToView(_avatarImageView)
    .topSpaceToView(_avatarImageView, 10)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    
    _containerView.sd_layout
    .leftEqualToView(_contenLabel)
    .topSpaceToView(_contenLabel, 10)
    .rightSpaceToView(self.contentView, 15);
    
//    replyView.sd_layout
//    .leftEqualToView(_containerView)
//    .rightEqualToView(_containerView)
//    .topSpaceToView(_containerView, 20)
//    .heightIs(80);
//
//    label.sd_layout
//    .leftSpaceToView(replyView, 20)
//    .topSpaceToView(replyView, 5)
//    .widthIs(80)
//    .autoHeightRatio(0);
//
//    replyTime.sd_layout
//    .rightSpaceToView(replyView, 20)
//    .topEqualToView(label)
//    .widthIs(100)
//    .autoHeightRatio(0);
//
//    replyContent.sd_layout
//    .leftSpaceToView(replyView, 50)
//    .topSpaceToView(label, 10)
//    .rightSpaceToView(replyView, 20)
//    .autoHeightRatio(0);
//
//    [replyView setupAutoHeightWithBottomView:replyContent bottomMargin:10];
    
    line.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(_containerView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(0.3);
    
    [self setupAutoHeightWithBottomView:line bottomMargin:0];
}

-(void)setModel:(TeacherEvaluateModel *)model
{
    _model = model;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:UIImageMake(@"common_icon_avatar")];
    _starView.value = [model.star intValue];
    _contenLabel.text = model.evaluate;
    _nameLabel.text = model.nickname;
    _timeLabel.text = [KyoDateTools prettyDateWithDateString:[MyTools getDateStringWithTimeInterval:model.createtime]];
    
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < model.images.count; i ++) {
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = UIColorBlue;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.images[i]] placeholderImage:UIImageMake(@"common_icon_placeholderImage") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self->_containerView updateLayout];
        }];
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [imageView addGestureRecognizer:tgr];
        [_containerView addSubview:imageView];
        imageView.sd_layout.autoHeightRatio(0.8);
        [temp addObject:imageView];
    }
    
    [_containerView setupAutoMarginFlowItems:[temp copy] withPerRowItemsCount:3 itemWidth:SCREEN_WIDTH / 3.5
                              verticalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:0];
    if (model.images.count == 0) {
        _containerView.sd_layout.heightIs(0);
    }
}

-(void)tapImage:(UITapGestureRecognizer *)tgr
{
    UIImageView *imageView = (UIImageView *)tgr.view;
    self.tapImageBlock(_model.images, imageView.tag);
}

@end

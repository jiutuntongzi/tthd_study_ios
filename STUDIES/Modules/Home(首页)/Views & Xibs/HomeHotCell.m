//
//  HomeHotCell.m
//  STUDIES
//
//  Created by happyi on 2019/3/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeHotCell.h"
#import "HomeRecommendItemCell.h"

@implementation HomeHotCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = BaseBackgroundColor;
        
        [self setSubViews];
    }
    
    return self;
}

-(void)setSubViews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.estimatedItemSize = CGSizeMake(100, 60);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Home_Hot_Height) collectionViewLayout:layout];
    [_collectionView registerClass:[HomeRecommendItemCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = YES;
    _collectionView.backgroundColor = BaseBackgroundColor;
    _collectionView.alwaysBounceHorizontal = YES;
    _collectionView.alwaysBounceVertical = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    [self.contentView addSubview:_collectionView];
    
    [self setupAutoHeightWithBottomView:_collectionView bottomMargin:0];
}

#pragma mark -- collectionViewDelegate & dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeRecommendItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    HomeTopicModel *model = _dataArray[indexPath.item];
    cell.titleLabel.text = [NSString stringWithFormat:@"#%@#", model.title];
//    for (UIView *view in cell.contentView.subviews) {
//        [view removeFromSuperview];
//    }
//
//    cell.backgroundColor = BaseBackgroundColor;
//
//    HomeTopicModel *model = _dataArray[indexPath.item];
//
//    UILabel *label = [MyTools labelWithText:[NSString stringWithFormat:@"#%@#", model.title] textColor:UIColorWhite textFont:UIFontMake(16) textAlignment:NSTextAlignmentCenter];
//    label.backgroundColor = UIColorGreen;
//    label.layer.cornerRadius = 20;
//    label.layer.masksToBounds = YES;
//    label.lineBreakMode = NSLineBreakByTruncatingMiddle;
//    [cell.contentView addSubview:label];
//
    if (indexPath.item == 0) {
        cell.titleLabel.backgroundColor = UIColorBlue;
    }

    if (indexPath.item == 1) {
        cell.titleLabel.backgroundColor = UIColorRed;
    }

    if (indexPath.item == 2) {
        cell.titleLabel.backgroundColor = UIColorGray;
    }

    if (indexPath.item == 3) {
        cell.titleLabel.backgroundColor = UIColorTestBlue;
    }
//
//    label.sd_layout
//    .leftSpaceToView(cell.contentView, 10)
//    .rightSpaceToView(cell.contentView, 10)
//    .topSpaceToView(cell.contentView, 15)
//    .bottomSpaceToView(cell.contentView, 15);
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTopicModel *model = _dataArray[indexPath.item];
    self.selectedTopic(model.tId);
}

@end

//
//  HomeRecommendCell.m
//  STUDIES
//
//  Created by happyi on 2019/3/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeRecommendCell.h"

@implementation HomeRecommendCell

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

#pragma mark - 子视图
-(void)setSubViews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH / 3 - 10, Home_Recommend_Height);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Home_Recommend_Height) collectionViewLayout:layout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
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
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.backgroundColor = BaseBackgroundColor;
    
    HomeTheamModel *model = _dataArray[indexPath.item];
    
    UIImageView *imageView = [UIImageView new];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
    imageView.layer.cornerRadius = 8;
    imageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:imageView];
    
    UILabel *label = [MyTools labelWithText:model.name textColor:UIColorWhite textFont:UIFontMake(15) textAlignment:NSTextAlignmentCenter];
    label.layer.cornerRadius = 8;
    label.layer.masksToBounds = YES;
    [cell.contentView addSubview:label];
    
    imageView.sd_layout
    .leftSpaceToView(cell.contentView, 10)
    .rightSpaceToView(cell.contentView, 10)
    .topSpaceToView(cell.contentView, 15)
    .bottomSpaceToView(cell.contentView, 15);
    
    label.sd_layout
    .leftEqualToView(imageView)
    .topEqualToView(imageView)
    .rightEqualToView(imageView)
    .bottomEqualToView(imageView);
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedActivity(_dataArray[indexPath.item]);
}

@end

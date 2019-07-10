//
//  LineDetailImageCell.h
//  STUDIES
//
//  Created by happyi on 2019/5/9.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineDetailImageCell : UICollectionViewCell
{
    UIImageView *_imageView;
}
@property (nonatomic, strong) NSString *imageUrl;

@end


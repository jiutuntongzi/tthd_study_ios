//
//  MineNoteCell.h
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteSearchModel.h"

@interface MineNoteCell : UITableViewCell
{
    UIImageView *_coverImageView;
    QMUILabel *_titleLabel;
    QMUILabel *_timeLabel;
    QMUIButton *_praiseButton;
    QMUIButton *_collectButton;
}

@property (nonatomic, strong) NoteSearchModel *model;

@end


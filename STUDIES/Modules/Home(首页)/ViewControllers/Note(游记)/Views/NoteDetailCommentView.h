//
//  NoteDetailCommentView.h
//  STUDIES
//
//  Created by happyi on 2019/4/26.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteDetailCommentView : UIView
{
    QMUIButton *_favorButton;
    QMUITextField *_commentTextField;
}
/** 是否点赞 */
@property(nonatomic, assign) BOOL isFavored;
/** 点赞数 */
@property(nonatomic, strong) NSString *favores;
/** 点赞的block */
@property(nonatomic, copy) void(^favorBlock)(void);
/** 点击评论 */
@property(nonatomic, copy) void(^tapTextFieldBlock)(void);
@property(nonatomic, strong) QMUITextField *commentTextField;

@end


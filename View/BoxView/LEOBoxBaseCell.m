//
//  LEOBoxBaseCell.m
//  PrivacyGuard
//
//  Created by Ternence on 15/11/12.
//  Copyright © 2015年 LEO. All rights reserved.
//

#import "LEOBoxBaseCell.h"
#import "LEOBoxBaseCellTopView.h"
#import "LEOBoxBaseCellHeader.h"
#import "LEOBoxBaseCellBottomView.h"
#import "UITool.h"

#define kBoxBaseCellIndentifier @"kBoxBaseCellIndentifier"

@interface LEOBoxBaseCell ()<LEOBoxBaseCellTopViewDelegate,LEOBoxBaseCellBottomViewDelegate>
@property (nonatomic, strong) LEOBoxBaseCellTopView *topView;
@property (nonatomic, strong) LEOBoxBaseCellBottomView *bottomView;
@property (nonatomic, strong) UIButton *cheatBtn;

@property (nonatomic, assign) NSInteger lastIndex;
@end

@implementation LEOBoxBaseCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    LEOBoxBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:kBoxBaseCellIndentifier];
    if (!cell) {
        cell = [[LEOBoxBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBoxBaseCellIndentifier];
    }
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = C5;
    }
    return self;
}

- (void)setupTopView
{
    if (!self.topView) {
        self.topView = [[LEOBoxBaseCellTopView alloc] initWithFrame:CGRectMake(Cell_Normal_LeftRightMargin, 0, SCREEN_WIDTH - 2 * Cell_Normal_LeftRightMargin, _config.topConfig.height)];
        self.topView.delegate = self;
        [self.contentView addSubview:self.topView];
    }
    self.topView.config = _config.topConfig;

}

- (void)setupBottomView
{
    if (!self.bottomView) {
        self.bottomView = [[LEOBoxBaseCellBottomView alloc] initWithFrame:CGRectMake(Cell_Normal_LeftRightMargin, Cell_Normal_TopView_H + Cell_TopView_BottomView_Margin, self.topView.bounds.size.width, _config.bottomConfig.height)];
        self.bottomView.delegate = self;
        [self.contentView addSubview:self.bottomView];
    }
    //底部区域出现动画
    CGRect rectLine = CGRectMake(Cell_Normal_LeftRightMargin, Cell_Normal_TopView_H + Cell_TopView_BottomView_Margin, self.topView.bounds.size.width, 0);
    CGRect rectFull = CGRectMake(Cell_Normal_LeftRightMargin, Cell_Normal_TopView_H + Cell_TopView_BottomView_Margin, self.topView.bounds.size.width, _config.bottomConfig.height);
    
    self.bottomView.frame = rectLine;
    self.bottomView.clipsToBounds = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = rectFull;
    }completion:^(BOOL finished) {
        self.bottomView.clipsToBounds = NO;
    }];
    self.bottomView.config = _config.bottomConfig;
}

/**
 *  用于处理点击箭头容易吊起webview问题。截取didSelectRowAtIndexPath事件。如果更改cell的宽度，会造成动画效果变质。
 */
- (void)setupCheatView
{
    self.cheatBtn = [[UIButton alloc] init];
    self.cheatBtn.backgroundColor = [UIColor clearColor];
    self.cheatBtn.frame = CGRectMake(SCREEN_WIDTH - Cell_Normal_LeftRightMargin, 0, Cell_Normal_LeftRightMargin, self.config.topConfig.height + self.config.bottomConfig.height);
    [self.cheatBtn addTarget:self action:@selector(doNothing) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cheatBtn];
}

- (void)doNothing
{
    
}

- (void)setConfig:(LEOBoxBasicCellConfig *)config
{
    _config = config;
    [self setupTopView];

    switch (_config.cellStatus) {
        case LEOBoxBaseCellStatusPreview:{
            [self setupBottomView];
            break;
        }
        case LEOBoxBaseCellStatusNormal:{

            break;
        }
        case LEOBoxBaseCellStatusEdit:{
            [self setupBottomView];
            break;
        }
        case LEOBoxBaseCellStatusNew:{
            [self setupBottomView];
            break;
        }
    }
    [self setupCheatView];
}

#pragma mark 会员卡事宜
- (void)refreshMemberEditObject:(LEOSecurityBoxDataBaseObject *)object
{
    [self.topView refreshEditObject:object];
    [self.bottomView refreshMemberEditObject:object];
}


#pragma mark 登录信息事宜
- (void)refreshAccountEditObject:(LEOSecurityBoxDataBaseObject *)object
{
    [self.topView refreshEditObject:object];
    [self.bottomView refreshAccountEditObject:object];
}

#pragma mark 银行卡事宜
- (void)refreshBankEditObject:(LEOSecurityBoxDataBaseObject *)object
{
    [self.topView refreshEditObject:object];
    [self.bottomView refreshBankEditObject:object];
}


- (void)prepareForReuse
{
    [self.topView removeFromSuperview];
    self.topView = nil;
    [self.bottomView removeFromSuperview];
    self.bottomView = nil;
    [self.cheatBtn removeFromSuperview];
    self.cheatBtn = nil;
}


#pragma mark topView delegate
- (void)topViewTitleStartEdit
{
    [self.topView titleStartEdit];
}

- (void)arrowBtnEnabled:(BOOL)enabled
{
    [self.topView arrowBtnEnabled:enabled];
}

- (void)topView:(LEOBoxBaseCellTopView *)topView open:(BOOL)open
{
    if ([self.delegate respondsToSelector:@selector(boxBaseCell:switchCellStatusWithPreviewFlag:)]) {
        [self.delegate boxBaseCell:self switchCellStatusWithPreviewFlag:open];
    }
}

#pragma mark bottomView delegate
- (void)bottomViewEnterEditMode:(LEOBoxBaseCellBottomView *)bottomView
{
    if ([self.delegate respondsToSelector:@selector(boxBaseCell:enterEditMode:)]) {
        [self.delegate boxBaseCell:self enterEditMode:self.config];
    }
}

- (void)bottomViewCreateDesktopShortcut:(LEOBoxBaseCellBottomView *)bottomView
{
    if ([self.delegate respondsToSelector:@selector(boxBaseCell:createShortcut:)]) {
        [self.delegate boxBaseCell:self createShortcut:self.config];
    }
}

- (void)bottomViewDeleteCell:(LEOBoxBaseCellBottomView *)bottomView
{
    if ([self.delegate respondsToSelector:@selector(boxBaseCell:deleteCell:)]) {
        [self.delegate boxBaseCell:self deleteCell:self.config];
    }
    
}
@end

//
//  LEOBoxBaseCell.h
//  PrivacyGuard
//
//  Created by Ternence on 15/11/12.
//  Copyright © 2015年 LEO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOBoxBasicCellConfig.h"
@class LEOBoxBaseCell;

@protocol LEOBoxBaseCellDelegate <NSObject>

- (void)boxBaseCell:(LEOBoxBaseCell *)cell switchCellStatusWithPreviewFlag:(BOOL)previewFlag;
- (void)boxBaseCell:(LEOBoxBaseCell *)cell enterEditMode:(LEOBoxBasicCellConfig *)config;
- (void)boxBaseCell:(LEOBoxBaseCell *)cell createShortcut:(LEOBoxBasicCellConfig *)config;
- (void)boxBaseCell:(LEOBoxBaseCell *)cell deleteCell:(LEOBoxBasicCellConfig *)config;

@end

@interface LEOBoxBaseCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, weak) id<LEOBoxBaseCellDelegate> delegate;
@property (nonatomic, strong) LEOBoxBasicCellConfig *config;
//登录信息部分
- (void)refreshAccountEditObject:(LEOSecurityBoxDataBaseObject *)object;

//会员卡部分
- (void)refreshMemberEditObject:(LEOSecurityBoxDataBaseObject *)object;

//银行卡部分
- (void)refreshBankEditObject:(LEOSecurityBoxDataBaseObject *)object;


- (void)topViewTitleStartEdit;
- (void)arrowBtnEnabled:(BOOL)enabled;
@end

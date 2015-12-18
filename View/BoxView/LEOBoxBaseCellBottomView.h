//
//  LEOBoxBaseCellBottomView.h
//  PrivacyGuard
//
//  Created by Ternence on 15/11/12.
//  Copyright © 2015年 LEO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOBoxBasicCellConfig.h"
#import "LEOSecurityBoxDataBaseObject.h"
#import "LEOSLoginInfo.h"
#import "LEOSMembCard.h"
#import "LEOSBankCard.h"
@class LEOBoxBaseCellBottomView;

@protocol LEOBoxBaseCellBottomViewDelegate <NSObject>
- (void)bottomViewEnterEditMode:(LEOBoxBaseCellBottomView *)bottomView;
- (void)bottomViewCreateDesktopShortcut:(LEOBoxBaseCellBottomView *)bottomView;
- (void)bottomViewDeleteCell:(LEOBoxBaseCellBottomView *)bottomView;
@end

@interface LEOBoxBaseCellBottomView : UIView
@property (nonatomic, strong) LEOBoxBasicCellBottomViewConfig *config;
@property (nonatomic, weak) id<LEOBoxBaseCellBottomViewDelegate>delegate;

- (void)refreshAccountEditObject:(LEOSecurityBoxDataBaseObject *)object;

- (void)refreshMemberEditObject:(LEOSecurityBoxDataBaseObject *)object;

- (void)refreshBankEditObject:(LEOSecurityBoxDataBaseObject *)object;


@end

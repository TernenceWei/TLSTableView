//
//  LEOBoxBaseCellTopView.h
//  PrivacyGuard
//
//  Created by Ternence on 15/11/12.
//  Copyright © 2015年 LEO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOBoxBasicCellConfig.h"
@class LEOBoxBaseCellTopView;

@protocol LEOBoxBaseCellTopViewDelegate <NSObject>
- (void)topView:(LEOBoxBaseCellTopView *)topView open:(BOOL)open;
@end

@interface LEOBoxBaseCellTopView : UIView
@property (nonatomic, strong) LEOBoxBasicCellTopViewConfig *config;
@property (nonatomic, weak) id<LEOBoxBaseCellTopViewDelegate>delegate;
- (void)refreshEditObject:(LEOSecurityBoxDataBaseObject *)object;
- (void)titleStartEdit;
- (void)arrowBtnEnabled:(BOOL)enabled;
@end

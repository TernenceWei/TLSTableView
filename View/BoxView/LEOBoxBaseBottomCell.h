//
//  LEOBoxBaseBottomCell.h
//  PrivacyGuard
//
//  Created by Ternence on 15/11/17.
//  Copyright © 2015年 LEO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOBoxBasicCellBottomViewConfig.h"
#import "LEOBoxBasicCellConfigHeader.h"
#import "LEOBoxTextField.h"
@class LEOBoxBaseBottomCell;

@interface LEOBoxBaseBottomCell : UITableViewCell
@property (nonatomic, strong) LEOBoxTextField *textField;
@property (nonatomic, strong) UILabel *titleLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView tag:(NSInteger)tag;
@property (nonatomic, assign) LEOBoxBaseCellStatus status;
@property (nonatomic, strong) LEOBoxBasicCellBottomViewItemConfig *config;

@end

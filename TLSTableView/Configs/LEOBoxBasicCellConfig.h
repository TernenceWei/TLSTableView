//
//  LEOBoxBasicCellConfig.h
//  PrivacyGuard
//
//  Created by Ternence on 15/11/16.
//  Copyright © 2015年 LEO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOSecurityBoxDataBaseObject.h"
#import "LEOBoxBasicCellConfigHeader.h"
#import "LEOBoxBasicCellBottomViewConfig.h"
#import "LEOWebInfo.h"

typedef void (^LEOBoxCellTopViewDataBlock)(NSString *content, BOOL finished);
typedef void (^LEOBoxCellTopViewIconBlock)(LEOWebInfo *webInfo);

@interface LEOBoxBasicCellTopViewConfig : NSObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, assign) NSInteger remindCount;
@property (nonatomic, assign) LEOBoxBaseCellStatus status;
@property (nonatomic, assign) LEOBoxVCType VCType;
@property (nonatomic, copy) LEOBoxCellTopViewIconBlock iconBlock;
@property (nonatomic, copy) LEOBoxCellTopViewIconBlock titleBlock;
@property (nonatomic, copy) LEOBoxCellTopViewDataBlock textChangeBlock;

+ (instancetype)configWithStatus:(LEOBoxBaseCellStatus)status object:(LEOSecurityBoxDataBaseObject *)object type:(LEOBoxVCType)type;
+ (instancetype)configWithStatus:(LEOBoxBaseCellStatus)status type:(LEOBoxVCType)type;
@end



@interface LEOBoxBasicCellConfig : NSObject
@property (nonatomic, assign) LEOBoxBaseCellStatus cellStatus;
@property (nonatomic, assign) LEOBoxVCType VCType;
@property (nonatomic, strong) LEOBoxBasicCellTopViewConfig *topConfig;
@property (nonatomic, strong) LEOBoxBasicCellBottomViewConfig *bottomConfig;
@property (nonatomic, assign) CGFloat cellHeight;

+ (instancetype)configWithStatus:(LEOBoxBaseCellStatus)status object:(LEOSecurityBoxDataBaseObject *)object type:(LEOBoxVCType)type;
+ (instancetype)configWithStatus:(LEOBoxBaseCellStatus)status type:(LEOBoxVCType)type;
@end

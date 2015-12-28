//
//  LEOBoxBasicCellConfig.m
//  PrivacyGuard
//
//  Created by Ternence on 15/11/16.
//  Copyright © 2015年 LEO. All rights reserved.
//

#import "LEOBoxBasicCellConfig.h"
#import "LEOSLoginInfo.h"
#import "LEOSMembCard.h"
#import "LEOSBankCard.h"
#import "LEOBoxBaseCellHeader.h"
#import "NSString+CheckString.h"
#import "LEOBoxBasicCellConfigHeader.h"

#define RemindCount 100

#pragma mark LEOBoxBasicCellTopViewConfig
@implementation LEOBoxBasicCellTopViewConfig
+ (instancetype)configWithStatus:(LEOBoxBaseCellStatus)status object:(LEOSecurityBoxDataBaseObject *)object type:(LEOBoxVCType)type
{
    LEOBoxBasicCellTopViewConfig *config = [[LEOBoxBasicCellTopViewConfig alloc] init];
    config.height = Cell_Normal_TopView_H;
    config.VCType = type;
    config.iconName = object.icon_url;
    if (status == LEOBoxBaseCellStatusNew && [self isBlankString:object.icon_url]) {
        config.iconName = @"box_icon_add";
    }
    config.title = object.title;
    config.subTitle = object.account;
    config.status = status;
    config.remindCount = RemindCount;
    if (type == LEOBoxVCTypeBank) {
        LEOSBankCard *bankCard = (LEOSBankCard *)object;
        if (![self isBlankString:object.web_url]) {
            config.placeHolder = [object.web_url getDomain];
        }else {
            config.placeHolder = NSLocalizedString(@"Issuing Bank", nil);
            
        }
    }else if (type == LEOBoxVCTypeAccount){
        if (![self isBlankString:object.web_url]) {
            config.placeHolder = [object.web_url getDomain];
        }else {
            config.placeHolder = NSLocalizedString(@"Name", nil);
        
        }
    }else if (type == LEOBoxVCTypeMember){
        if (![self isBlankString:object.web_url]) {
            config.placeHolder = [object.web_url getDomain];
        }else {
            config.placeHolder = NSLocalizedString(@"Merchant Name", nil);
            
        }
    }
    return config;
}

+ (instancetype)configWithStatus:(LEOBoxBaseCellStatus)status type:(LEOBoxVCType)type
{
    NSString *iconName = @"box_icon_add";
    NSString *placeHolder = @"login account";
    switch (type) {
        case LEOBoxVCTypeAccount:{
            placeHolder = NSLocalizedString(@"Name", nil);
            break;
        }
        case LEOBoxVCTypeMember:{
            placeHolder = NSLocalizedString(@"Merchant Name", nil);
            break;
        }
        case LEOBoxVCTypeBank:{
            placeHolder = NSLocalizedString(@"Issuing Bank", nil);
            break;
        }
    }
    LEOBoxBasicCellTopViewConfig *config = [[LEOBoxBasicCellTopViewConfig alloc] init];
    config.height = Cell_Normal_TopView_H;
    config.iconName = iconName;
    config.placeHolder = placeHolder;
    config.status = status;
    config.VCType = type;
    config.remindCount = RemindCount;
    return config;
}

+ (BOOL)isBlankString:(NSString *)string{
    
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end

#pragma mark LEOBoxBasicCellConfig
@implementation LEOBoxBasicCellConfig
+ (instancetype)configWithStatus:(LEOBoxBaseCellStatus)status
{
    LEOBoxBasicCellConfig *config = [[LEOBoxBasicCellConfig alloc] init];
    config.cellStatus = status;
    return config;
}

+ (instancetype)configWithStatus:(LEOBoxBaseCellStatus)status object:(LEOSecurityBoxDataBaseObject *)object type:(LEOBoxVCType)type
{
    LEOBoxBasicCellConfig *config = [LEOBoxBasicCellConfig configWithStatus:status];
    config.VCType = type;
    config.topConfig = [LEOBoxBasicCellTopViewConfig configWithStatus:status object:object type:type];
    config.bottomConfig = [LEOBoxBasicCellBottomViewConfig configWithStatus:status object:object type:type];
    if (status == LEOBoxBaseCellStatusNormal) {//加上shadowSpace是为了添加阴影效果
        config.cellHeight = config.topConfig.height + config.bottomConfig.height + shadowSpace;
    }else{
        config.cellHeight = config.topConfig.height + config.bottomConfig.height + Cell_TopView_BottomView_Margin + shadowSpace;
    }
    return config;
}

+ (instancetype)configWithStatus:(LEOBoxBaseCellStatus)status type:(LEOBoxVCType)type
{
    LEOBoxBasicCellConfig *config = [LEOBoxBasicCellConfig configWithStatus:status];
    config.topConfig = [LEOBoxBasicCellTopViewConfig configWithStatus:status type:type];
    config.bottomConfig = [LEOBoxBasicCellBottomViewConfig configWithStatus:status type:type];
    config.cellHeight = config.topConfig.height + config.bottomConfig.height + Cell_TopView_BottomView_Margin + shadowSpace;
    config.VCType = type;
    return config;
}
@end

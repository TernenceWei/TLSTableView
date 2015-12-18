//
//  LEOBoxBasicCellBottomViewConfig.m
//  PrivacyGuard
//
//  Created by Ternence on 15/11/17.
//  Copyright © 2015年 LEO. All rights reserved.
//

#import "LEOBoxBasicCellBottomViewConfig.h"
#import "LEOSLoginInfo.h"
#import "LEOSBankCard.h"
#import "LEOBoxBaseCellHeader.h"

#pragma mark LEOBoxBasicCellBottomViewItemConfig
@implementation LEOBoxBasicCellBottomViewItemConfig
+ (instancetype)configWithType:(LEOBoxCellItemType)itemType title:(NSString *)title placeHolder:(NSString *)placeHolder content:(NSString *)content height:(CGFloat)height type:(LEOBoxVCType)type
{
    LEOBoxBasicCellBottomViewItemConfig *itemConfig = [[LEOBoxBasicCellBottomViewItemConfig alloc] init];
    itemConfig.itemType = itemType;
    itemConfig.VCType = type;
    itemConfig.title = title;
    itemConfig.placeHolder = placeHolder;
    itemConfig.content = content;
    itemConfig.height = height;
    itemConfig.tag = KDefaultTag;
    return itemConfig;
}

+ (instancetype)configWithType:(LEOBoxCellItemType)itemType height:(CGFloat)height type:(LEOBoxVCType)type
{
    LEOBoxBasicCellBottomViewItemConfig *itemConfig = [[LEOBoxBasicCellBottomViewItemConfig alloc] init];
    itemConfig.itemType = itemType;
    itemConfig.VCType = type;
    itemConfig.height = height;
    return itemConfig;
}

+ (instancetype)configWithType:(LEOBoxCellItemType)itemType height:(CGFloat)height content:(NSString *)content type:(LEOBoxVCType)type
{
    LEOBoxBasicCellBottomViewItemConfig *itemConfig = [[LEOBoxBasicCellBottomViewItemConfig alloc] init];
    itemConfig.itemType = itemType;
    itemConfig.VCType = type;
    itemConfig.height = height;
    itemConfig.content = content;
    return itemConfig;
}

@end

#pragma mark LEOBoxBasicCellBottomViewConfig
@implementation LEOBoxBasicCellBottomViewConfig
+ (instancetype)configWithStatus:(LEOBoxBaseCellStatus)status object:(LEOSecurityBoxDataBaseObject *)object type:(LEOBoxVCType)type
{
    LEOBoxBasicCellBottomViewConfig *config = [[LEOBoxBasicCellBottomViewConfig alloc] init];
    config.status = status;
    config.VCType = type;
    NSMutableArray *tempArray = [NSMutableArray array];
    switch (status) {
        case LEOBoxBaseCellStatusNormal:{
            config.height = 0;
            break;
        }
        case LEOBoxBaseCellStatusPreview:{
            switch (object.infoType) {
                case infoType_loginInfo:{
                    
                    if (![self isBlankString:object.account]) {//账号
                        LEOBoxBasicCellBottomViewItemConfig *itemConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeAccountNum title:NSLocalizedString(@"Account", nil) placeHolder:nil content:object.account height:Cell_Preview_BottomView_Cell_H type:type];
                        [tempArray addObject:itemConfig];
                        config.height += itemConfig.height;
                    }
                    if (![self isBlankString:object.password]) {//密码
                        LEOBoxBasicCellBottomViewItemConfig *itemConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypePassword title:NSLocalizedString(@"Mian Passcode", nil) placeHolder:nil content:object.password height:Cell_Preview_BottomView_Cell_H type:type];
                        [tempArray addObject:itemConfig];
                        config.height += itemConfig.height;
                    }
                    if (![self isBlankString:object.web_url]) {//网址
                        LEOBoxBasicCellBottomViewItemConfig *itemConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeWebsite title:NSLocalizedString(@"Website", nil) placeHolder:nil content:object.web_url height:Cell_Preview_BottomView_Cell_H type:type];
                        [tempArray addObject:itemConfig];
                        config.height += itemConfig.height;
                    }
                    //footer
                    LEOBoxBasicCellBottomViewItemConfig *itemConfig = [[LEOBoxBasicCellBottomViewItemConfig alloc] init];
                    itemConfig.itemType = LEOBoxCellItemTypeFooter;
                    itemConfig.VCType = type;
                    itemConfig.height = Cell_Preview_BottomView_Cell_H;
                    [tempArray addObject:itemConfig];
                    
                    config.height += itemConfig.height;;
                    config.itemConfigs = [NSArray arrayWithArray:[tempArray copy]];
                    break;
                }
                case infoType_membCard:{
                    LEOSMembCard *cardObject = (LEOSMembCard *)object;
                    if (![self isBlankString:cardObject.account]) {//卡号
                        LEOBoxBasicCellBottomViewItemConfig *itemConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeMemberCardNumber title:NSLocalizedString(@"Card No.", nil) placeHolder:nil content:cardObject.account height:Cell_Preview_BottomView_Cell_H type:type];
                        [tempArray addObject:itemConfig];
                        config.height += itemConfig.height;
                    }
                    if (![self isBlankString:cardObject.memCardPhone]) {//商家电话
                        LEOBoxBasicCellBottomViewItemConfig *itemConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypePhoneNumber title:NSLocalizedString(@"Merchant Tel. No.", nil) placeHolder:nil content:cardObject.memCardPhone height:Cell_Preview_BottomView_Cell_H type:type];
                        [tempArray addObject:itemConfig];
                        config.height += itemConfig.height;
                    }
                    if (![self isBlankString:cardObject.web_url]) {//网址
                        LEOBoxBasicCellBottomViewItemConfig *itemConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeWebsite title:NSLocalizedString(@"Website", nil) placeHolder:nil content:cardObject.web_url height:Cell_Preview_BottomView_Cell_H type:type];
                        [tempArray addObject:itemConfig];
                        config.height += itemConfig.height;
                    }
                    if (![self isBlankString:cardObject.comment]) {//备注
                        LEOBoxBasicCellBottomViewItemConfig *itemConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeComment title:NSLocalizedString(@"Notes", nil) placeHolder:nil content:cardObject.comment height:Cell_Preview_BottomView_Cell_H type:type];
                        [tempArray addObject:itemConfig];
                        config.height += itemConfig.height;
                    }

                    //footer
                    LEOBoxBasicCellBottomViewItemConfig *footerConfig = [[LEOBoxBasicCellBottomViewItemConfig alloc] init];
                    footerConfig.itemType = LEOBoxCellItemTypeFooter;
                    footerConfig.VCType = type;
                    footerConfig.height = Cell_Preview_BottomView_Cell_H;
                    [tempArray addObject:footerConfig];
                    config.height += footerConfig.height;
                    
                    config.itemConfigs = [NSArray arrayWithArray:[tempArray copy]];
                    break;
                }
                case infoType_bankCard:{
                    LEOSBankCard *cardObject = (LEOSBankCard *)object;
                    if (![self isBlankString:cardObject.account]) {//卡号
                        LEOBoxBasicCellBottomViewItemConfig *itemConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeBankCardNumber title:NSLocalizedString(@"Card No.", nil) placeHolder:nil content:cardObject.account height:Cell_Preview_BottomView_Cell_H type:type];
                        [tempArray addObject:itemConfig];
                    }
                    if (![self isBlankString:cardObject.bankCardVVC]) {//验证码
                        LEOBoxBasicCellBottomViewItemConfig *itemConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeBankVVC title:NSLocalizedString(@"Verification No.", nil) placeHolder:nil content:cardObject.bankCardVVC height:Cell_Preview_BottomView_Cell_H type:type];
                        [tempArray addObject:itemConfig];
                    }

                    
                    if (![self isBlankString:cardObject.web_url]) {//网址
                        LEOBoxBasicCellBottomViewItemConfig *itemConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeWebsite title:NSLocalizedString(@"Website", nil) placeHolder:nil content:cardObject.web_url height:Cell_Preview_BottomView_Cell_H type:type];
                        [tempArray addObject:itemConfig];
                    }
                    if (![self isBlankString:cardObject.comment]) {//备注
                        LEOBoxBasicCellBottomViewItemConfig *itemConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeComment title:NSLocalizedString(@"Notes", nil) placeHolder:nil content:cardObject.comment height:Cell_Preview_BottomView_Cell_H type:type];
                        [tempArray addObject:itemConfig];
                    }
                    
                    //footer
                    LEOBoxBasicCellBottomViewItemConfig *footerConfig = [[LEOBoxBasicCellBottomViewItemConfig alloc] init];
                    footerConfig.itemType = LEOBoxCellItemTypeFooter;
                    footerConfig.VCType = type;
                    footerConfig.height = Cell_Preview_BottomView_Cell_H;
                    [tempArray addObject:footerConfig];
                    
                    config.height = Cell_Preview_BottomView_Cell_H * tempArray.count;
                    config.itemConfigs = [NSArray arrayWithArray:[tempArray copy]];
                    break;
                }
                default:
                    break;
                    
            }
            break;
        }
        case LEOBoxBaseCellStatusEdit:{
            switch (object.infoType) {
                case infoType_loginInfo:{
                    
                    //账号
                    LEOBoxBasicCellBottomViewItemConfig *accountConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeAccountNum title:NSLocalizedString(@"Account", nil) placeHolder:NSLocalizedString(@"Enter User Name or Email", nil) content:object.account height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:accountConfig];
                    
                    //密码
                    LEOBoxBasicCellBottomViewItemConfig *passwordConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypePassword title:NSLocalizedString(@"Mian Passcode", nil) placeHolder:NSLocalizedString(@"Create Passcode", nil) content:object.password height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:passwordConfig];

                    
                    //网址
                    LEOBoxBasicCellBottomViewItemConfig *webConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeWebsite title:NSLocalizedString(@"Website", nil) placeHolder:NSLocalizedString(@"Enter Website", nil) content:object.web_url height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:webConfig];
                    
                    //footer
                    LEOBoxBasicCellBottomViewItemConfig *itemConfig = [[LEOBoxBasicCellBottomViewItemConfig alloc] init];
                    itemConfig.itemType = LEOBoxCellItemTypeFooter;
                    itemConfig.VCType = type;
                    itemConfig.height = Cell_Preview_BottomView_Cell_H;
                    [tempArray addObject:itemConfig];
                    
                    config.height = Cell_Preview_BottomView_Cell_H * tempArray.count;
                    config.itemConfigs = [NSArray arrayWithArray:[tempArray copy]];
                    break;
                }
                case infoType_membCard:{
                    LEOSMembCard *cardObject = (LEOSMembCard *)object;
                    //卡号
                    LEOBoxBasicCellBottomViewItemConfig *numConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeMemberCardNumber title:NSLocalizedString(@"Card No.", nil) placeHolder:NSLocalizedString(@"Enter Card No.", nil) content:cardObject.account height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:numConfig];
                    config.height += numConfig.height;
                    
                    //商家电话
                    LEOBoxBasicCellBottomViewItemConfig *phoneConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypePhoneNumber title:NSLocalizedString(@"Merchant Tel. No.", nil) placeHolder:NSLocalizedString(@"Enter Tel. No.", nil) content:cardObject.memCardPhone height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:phoneConfig];
                    config.height += phoneConfig.height;
                    
                    //网址
                    LEOBoxBasicCellBottomViewItemConfig *webConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeWebsite title:NSLocalizedString(@"Website", nil) placeHolder:NSLocalizedString(@"Enter Website", nil) content:cardObject.web_url height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:webConfig];
                    config.height += webConfig.height;
                    
                    //备注
                    LEOBoxBasicCellBottomViewItemConfig *commentConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeComment title:NSLocalizedString(@"Notes", nil) placeHolder:NSLocalizedString(@"Enter Your Remarks", nil) content:cardObject.comment height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:commentConfig];
                    config.height += commentConfig.height;
                    
                    //footer
                    LEOBoxBasicCellBottomViewItemConfig *footerConfig = [[LEOBoxBasicCellBottomViewItemConfig alloc] init];
                    footerConfig.itemType = LEOBoxCellItemTypeFooter;
                    footerConfig.VCType = type;
                    footerConfig.height = Cell_Preview_BottomView_Cell_H;
                    [tempArray addObject:footerConfig];
                    config.height += footerConfig.height;
                    
                    config.itemConfigs = [NSArray arrayWithArray:[tempArray copy]];
                    break;
                }
                case infoType_bankCard:{
                    LEOSBankCard *cardObject = (LEOSBankCard *)object;
                    //卡号
                    LEOBoxBasicCellBottomViewItemConfig *numConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeBankCardNumber title:NSLocalizedString(@"Card No.", nil) placeHolder:NSLocalizedString(@"Enter Card No.", nil) content:cardObject.account height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:numConfig];
                    
                    //验证码
                    LEOBoxBasicCellBottomViewItemConfig *verCodeConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeBankVVC title:NSLocalizedString(@"Verification No.", nil) placeHolder:NSLocalizedString(@"Enter Verification No.", nil) content:cardObject.bankCardVVC height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:verCodeConfig];
                    
                    //网址
                    LEOBoxBasicCellBottomViewItemConfig *webConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeWebsite title:NSLocalizedString(@"Website", nil) placeHolder:NSLocalizedString(@"Enter Website", nil) content:cardObject.web_url height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:webConfig];
                    
                    //备注
                    LEOBoxBasicCellBottomViewItemConfig *commentConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeComment title:NSLocalizedString(@"Notes", nil) placeHolder:NSLocalizedString(@"Enter Your Remarks", nil) content:cardObject.comment height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:commentConfig];
                    
                    //footer
                    LEOBoxBasicCellBottomViewItemConfig *footerConfig = [[LEOBoxBasicCellBottomViewItemConfig alloc] init];
                    footerConfig.itemType = LEOBoxCellItemTypeFooter;
                    footerConfig.VCType = type;
                    footerConfig.height = Cell_Preview_BottomView_Cell_H;
                    [tempArray addObject:footerConfig];
                    
                    config.height = Cell_Preview_BottomView_Cell_H * tempArray.count;
                    config.itemConfigs = [NSArray arrayWithArray:[tempArray copy]];
                    break;
                }
                default:
                    break;
                    
            }
            break;
        }
        case LEOBoxBaseCellStatusNew:{
            switch (object.infoType) {
                case infoType_loginInfo:{
                    //账号
                    LEOBoxBasicCellBottomViewItemConfig *accountConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeAccountNum title:NSLocalizedString(@"Account", nil) placeHolder:NSLocalizedString(@"Enter User Name or Email", nil) content:object.account height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:accountConfig];
                    
                    //密码
                    LEOBoxBasicCellBottomViewItemConfig *passwordConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypePassword title:NSLocalizedString(@"Mian Passcode", nil) placeHolder:NSLocalizedString(@"Create Passcode", nil) content:object.password height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:passwordConfig];

                    //网址
                    LEOBoxBasicCellBottomViewItemConfig *webConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeWebsite title:NSLocalizedString(@"Website", nil) placeHolder:NSLocalizedString(@"Enter Website", nil) content:object.web_url height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:webConfig];
                    
                    config.height = Cell_Preview_BottomView_Cell_H * tempArray.count;
                    config.itemConfigs = [NSArray arrayWithArray:[tempArray copy]];

                    break;
                }
                case infoType_membCard:{
                    LEOSMembCard *cardObject = (LEOSMembCard *)object;
                    //卡号
                    LEOBoxBasicCellBottomViewItemConfig *numConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeMemberCardNumber title:NSLocalizedString(@"Card No.", nil) placeHolder:NSLocalizedString(@"Enter Card No.", nil) content:cardObject.account height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:numConfig];
                    config.height += numConfig.height;
                    
                    //商家电话
                    LEOBoxBasicCellBottomViewItemConfig *phoneConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypePhoneNumber title:NSLocalizedString(@"Merchant Tel. No.", nil) placeHolder:NSLocalizedString(@"Enter Tel. No.", nil) content:cardObject.memCardPhone height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:phoneConfig];
                    config.height += phoneConfig.height;
                    
                    //网址
                    LEOBoxBasicCellBottomViewItemConfig *webConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeWebsite title:NSLocalizedString(@"Website", nil) placeHolder:NSLocalizedString(@"Enter Website", nil) content:cardObject.web_url height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:webConfig];
                    config.height += webConfig.height;
                    
                    //备注
                    LEOBoxBasicCellBottomViewItemConfig *commentConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeComment title:NSLocalizedString(@"Notes", nil) placeHolder:NSLocalizedString(@"Enter Your Remarks", nil) content:cardObject.comment height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:commentConfig];
                    config.height += commentConfig.height;
                    
                    config.itemConfigs = [NSArray arrayWithArray:[tempArray copy]];

                    break;
                }
                case infoType_bankCard:{
                    LEOSBankCard *cardObject = (LEOSBankCard *)object;
                    //卡号
                    LEOBoxBasicCellBottomViewItemConfig *numConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeBankCardNumber title:NSLocalizedString(@"Card No.", nil) placeHolder:NSLocalizedString(@"Enter Card No.", nil) content:cardObject.account height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:numConfig];
                    
                    //验证码
                    LEOBoxBasicCellBottomViewItemConfig *verCodeConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeBankVVC title:NSLocalizedString(@"Verification No.", nil) placeHolder:NSLocalizedString(@"Enter Verification No.", nil) content:cardObject.bankCardVVC height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:verCodeConfig];

                    
                    //网址
                    LEOBoxBasicCellBottomViewItemConfig *webConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeWebsite title:NSLocalizedString(@"Website", nil) placeHolder:NSLocalizedString(@"Enter Website", nil) content:cardObject.web_url height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:webConfig];
                    
                    //备注
                    LEOBoxBasicCellBottomViewItemConfig *commentConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeComment title:NSLocalizedString(@"Notes", nil) placeHolder:NSLocalizedString(@"Enter Your Remarks", nil) content:cardObject.comment height:Cell_Preview_BottomView_Cell_H type:type];
                    [tempArray addObject:commentConfig];
                    
                    config.height = Cell_Preview_BottomView_Cell_H * tempArray.count;
                    config.itemConfigs = [NSArray arrayWithArray:[tempArray copy]];
                    break;
                }
                default:{
                    
                    break;
                }
            }
            break;
        }
        default:{
            
            break;
        }
    }
    return config;
}

+ (instancetype)configWithStatus:(LEOBoxBaseCellStatus)status type:(LEOBoxVCType)type
{
    LEOBoxBasicCellBottomViewConfig *config = [[LEOBoxBasicCellBottomViewConfig alloc] init];
    config.status = status;
    config.VCType = type;
    NSMutableArray *tempArray = [NSMutableArray array];
    if (status == LEOBoxBaseCellStatusNew) {
        switch (type) {
            case LEOBoxVCTypeAccount:{
                //账号
                LEOBoxBasicCellBottomViewItemConfig *titleConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeAccountNum title:NSLocalizedString(@"Account", nil) placeHolder:NSLocalizedString(@"Enter User Name or Email", nil) content:nil height:Cell_Preview_BottomView_Cell_H type:type];
                [tempArray addObject:titleConfig];
                
                //密码
                LEOBoxBasicCellBottomViewItemConfig *passwordConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypePassword title:NSLocalizedString(@"Mian Passcode", nil) placeHolder:NSLocalizedString(@"Create Passcode", nil) content:nil height:Cell_Preview_BottomView_Cell_H type:type];
                [tempArray addObject:passwordConfig];
                
                
                //网址
                LEOBoxBasicCellBottomViewItemConfig *webConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeWebsite title:NSLocalizedString(@"Website", nil) placeHolder:NSLocalizedString(@"Enter Website", nil) content:nil height:Cell_Preview_BottomView_Cell_H type:type];
                [tempArray addObject:webConfig];
                
                config.height = Cell_Preview_BottomView_Cell_H * tempArray.count;
                config.itemConfigs = [NSArray arrayWithArray:[tempArray copy]];
                break;
            }
            case LEOBoxVCTypeMember:{
                //卡号
                LEOBoxBasicCellBottomViewItemConfig *numConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeMemberCardNumber title:NSLocalizedString(@"Card No.", nil) placeHolder:NSLocalizedString(@"Enter Card No.", nil) content:nil height:Cell_Preview_BottomView_Cell_H type:type];
                [tempArray addObject:numConfig];
                
                //商家电话
                LEOBoxBasicCellBottomViewItemConfig *phoneConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypePhoneNumber title:NSLocalizedString(@"Merchant Tel. No.", nil) placeHolder:NSLocalizedString(@"Enter Tel. No.", nil) content:nil height:Cell_Preview_BottomView_Cell_H type:type];
                [tempArray addObject:phoneConfig];
                
                //网址
                LEOBoxBasicCellBottomViewItemConfig *webConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeWebsite title:NSLocalizedString(@"Website", nil) placeHolder:NSLocalizedString(@"Enter Website", nil) content:nil height:Cell_Preview_BottomView_Cell_H type:type];
                [tempArray addObject:webConfig];
                
                //备注
                LEOBoxBasicCellBottomViewItemConfig *commentConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeComment title:NSLocalizedString(@"Notes", nil) placeHolder:NSLocalizedString(@"Enter Your Remarks", nil) content:nil height:Cell_Preview_BottomView_Cell_H type:type];
                [tempArray addObject:commentConfig];
                
                config.height = Cell_Preview_BottomView_Cell_H * tempArray.count;
                config.itemConfigs = [NSArray arrayWithArray:[tempArray copy]];
                break;
            }
            case LEOBoxVCTypeBank:{
                //卡号
                LEOBoxBasicCellBottomViewItemConfig *numConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeBankCardNumber title:NSLocalizedString(@"Card No.", nil) placeHolder:NSLocalizedString(@"Enter Card No.", nil) content:nil height:Cell_Preview_BottomView_Cell_H type:type];
                [tempArray addObject:numConfig];
                
                //验证码
                LEOBoxBasicCellBottomViewItemConfig *verCodeConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeBankVVC title:NSLocalizedString(@"Verification No.", nil) placeHolder:NSLocalizedString(@"Enter Verification No.", nil) content:nil height:Cell_Preview_BottomView_Cell_H type:type];
                [tempArray addObject:verCodeConfig];
                
                //网址
                LEOBoxBasicCellBottomViewItemConfig *webConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeWebsite title:NSLocalizedString(@"Website", nil) placeHolder:NSLocalizedString(@"Enter Website", nil) content:nil height:Cell_Preview_BottomView_Cell_H type:type];
                [tempArray addObject:webConfig];
                
                //备注
                LEOBoxBasicCellBottomViewItemConfig *commentConfig = [LEOBoxBasicCellBottomViewItemConfig configWithType:LEOBoxCellItemTypeComment title:NSLocalizedString(@"Notes", nil) placeHolder:NSLocalizedString(@"Enter Your Remarks", nil) content:nil height:Cell_Preview_BottomView_Cell_H type:type];
                [tempArray addObject:commentConfig];
                
                config.height = Cell_Preview_BottomView_Cell_H * tempArray.count;
                config.itemConfigs = [NSArray arrayWithArray:[tempArray copy]];
                break;
            }
        }
        
    }
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



//
//  LEOBoxBasicCellBottomViewConfig.h
//  PrivacyGuard
//
//  Created by Ternence on 15/11/17.
//  Copyright © 2015年 LEO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOBoxBasicCellConfigHeader.h"
#import "LEOSecurityBoxDataBaseObject.h"
#import "LEOSMembCard.h"

@interface LEOBoxBasicCellBottomViewItemConfig : NSObject
/**处理点击事件*/
typedef void (^LEOBoxCellItemClickBlock)();
/**处理编辑操作的数据传递*/
typedef void (^LEOBoxCellItemDataBlock)(NSString *content);
/**处理输入框被键盘遮挡的问题*/
typedef void (^LEOBoxCellItemKeboardBlock)(CGRect frame);

typedef NS_ENUM(NSInteger, LEOBoxCellItemType) {
    LEOBoxCellItemTypeNormal = 1,           // 普通类型
    LEOBoxCellItemTypeWebsite,              // 网址
    LEOBoxCellItemTypeComment,              // 评论
    LEOBoxCellItemTypeFooter,               // 底部操作区
    
    LEOBoxCellItemTypeBankVVC,              // 银行卡验证码
    LEOBoxCellItemTypeBankCardNumber,       // 银行卡号输入
    
    LEOBoxCellItemTypeMemberCardNumber,     // 会员卡号输入
    LEOBoxCellItemTypePhoneNumber,          // 会员卡商家电话
    
    LEOBoxCellItemTypeAccountNum,           // 登录信息卡号
    LEOBoxCellItemTypePassword,             // 登录信息密码
    
};

@property (nonatomic, assign) LEOBoxCellItemType itemType;
@property (nonatomic, assign) LEOBoxVCType VCType;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) LEOBoxCellItemClickBlock clickBlock;
@property (nonatomic, copy) LEOBoxCellItemDataBlock dataBlock;
@property (nonatomic, copy) LEOBoxCellItemKeboardBlock keboardBlock;

+ (instancetype)configWithType:(LEOBoxCellItemType)itemType title:(NSString *)title placeHolder:(NSString *)placeHolder content:(NSString *)content height:(CGFloat)height type:(LEOBoxVCType)type;
+ (instancetype)configWithType:(LEOBoxCellItemType)itemType height:(CGFloat)height type:(LEOBoxVCType)type;
+ (instancetype)configWithType:(LEOBoxCellItemType)itemType height:(CGFloat)height content:(NSString *)content type:(LEOBoxVCType)type;
@end


@interface LEOBoxBasicCellBottomViewConfig : NSObject
@property (nonatomic, assign) LEOBoxBaseCellStatus status;
@property (nonatomic, assign) LEOBoxVCType VCType;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSArray *itemConfigs;

+ (instancetype)configWithStatus:(LEOBoxBaseCellStatus)status object:(LEOSecurityBoxDataBaseObject *)object type:(LEOBoxVCType)type;
+ (instancetype)configWithStatus:(LEOBoxBaseCellStatus)status type:(LEOBoxVCType)type;

@end



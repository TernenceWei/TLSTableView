//
//  LEOSBankCard.h
//  PrivacyGuard
//
//  Created by guohao on 16/11/15.
//  Copyright © 2015 LEO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOSecurityBoxDataBaseObject.h"

typedef enum {
    BCTdefault = 0,
    BCTCreditCard,
    BCTDebitCard
}BankCardType;


@class AlertObj;

@interface LEOSBankCard : LEOSecurityBoxDataBaseObject<NSCopying>

/* super class
@property (nonatomic)        InfoType  infoType;
@property (nonatomic,strong) NSString* icon_url;
@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSString* account;
@property (nonatomic,strong) NSString* password;
@property (nonatomic,strong) NSString* web_url;
@property (nonatomic,strong) NSString* comment;
@property (nonatomic,strong) NSString* extension;
*/


/*!
@abstract 银行卡类型BCT：credit-信用卡，deposit-储蓄卡
*/
@property (nonatomic)        BankCardType bankCardType;
/*!
 @abstract 有效日期
 */
@property (nonatomic,strong) NSString*    bankCardExpire;
@property (nonatomic,strong) NSString*    bankCardVVC;
/*!
 @abstract 还款日（几号）
 */
@property (nonatomic,assign) NSInteger    bankCardPayDay;

/*!
 @abstract 还款提醒
 */
@property (nonatomic,strong) AlertObj*    bankCardAlert;

/*!
 @abstract repeat表示重复月数，1表示仅一次,2表示每月一次
 */
- (void)addAlertWithDay:(NSInteger)day
                   Hour:(NSInteger)hour
                    Min:(NSInteger)min
                 Repeat:(NSInteger)repeat;




@end

@interface AlertObj : NSObject<NSCopying>
@property (nonatomic,assign) NSInteger monthDay;
@property (nonatomic,assign) NSInteger hour;
@property (nonatomic,assign) NSInteger minitue;
/*!
 @abstract 提醒周期<月>，1表示仅一次
 */
@property (nonatomic,assign) NSInteger repeat;
- (instancetype)initWithD:(NSInteger)d
                        H:(NSInteger)h
                        M:(NSInteger)m
                        R:(NSInteger)r;
- (NSString*)getString;
@end


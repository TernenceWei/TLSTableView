//
//  LEOSBankCard.m
//  PrivacyGuard
//
//  Created by guohao on 16/11/15.
//  Copyright © 2015 LEO. All rights reserved.
//

#import "LEOSBankCard.h"


 NSString* Expire = @"bankCardExpire";
 NSString* CType  = @"bankCardType";
 NSString* VVC    = @"bankCardVVC";
 NSString* PayDay = @"bankCardPayDay";
 NSString* Alert = @"bankCardAlert";

@implementation AlertObj
- (instancetype)initWithD:(NSInteger)d H:(NSInteger)h M:(NSInteger)m R:(NSInteger)r{self = [super init]; self.monthDay = d%32;self.hour = h%24; self.minitue = m%60; self.repeat = r; return self;}
- (NSString*)getString{return [NSString stringWithFormat:@"%ld_%ld_%ld_%ld",self.monthDay,self.hour,self.minitue,self.repeat];}
- (id)copyWithZone:(NSZone *)zone
{
    AlertObj *object = [AlertObj allocWithZone:zone];
    object.repeat = _repeat;
    object.monthDay = _monthDay;
    object.hour = _hour;
    object.minitue = _minitue;
    return object;
}
@end

@implementation LEOSBankCard
- (id)copyWithZone:(NSZone *)zone
{
    LEOSBankCard *card = [super copyWithZone:zone];
    card.bankCardAlert = [_bankCardAlert copy];
    card.bankCardExpire = [_bankCardExpire copy];
    card.bankCardPayDay = _bankCardPayDay;
    card.bankCardType = _bankCardType;
    card.bankCardVVC = [_bankCardVVC copy];
    return card;
}

- (NSString*)extension{
    NSMutableDictionary* mdic = [NSMutableDictionary new];
    [mdic setValue:@(self.bankCardType)                  forKey:CType];
    [mdic setValue:CheckCardStrNull(self.bankCardExpire) forKey:Expire];
    [mdic setValue:CheckCardStrNull(self.bankCardVVC)    forKey:VVC];
    [mdic setValue:@(self.bankCardPayDay)                forKey:PayDay];
    if (self.bankCardAlert) {
        [mdic setValue:[self.bankCardAlert getString]  forKey:Alert];
    }else{
        [mdic setValue:@""  forKey:Alert];
    }
    return [self getJsonFromDic:mdic];
}

- (void)setExtension:(NSString *)extension{
    NSDictionary* dict = [self getDictFromString:extension];
    if (dict) {
        self.bankCardExpire = [[dict allKeys] containsObject:Expire]?dict[Expire]:@"";
        self.bankCardType   = [[dict allKeys] containsObject:CType]?[dict[CType] intValue]:BCTdefault;
        self.bankCardVVC    = [[dict allKeys] containsObject:VVC]?dict[VVC]:@"";
        self.bankCardPayDay = [[dict allKeys] containsObject:PayDay]?[dict[PayDay] integerValue]:0;
        self.bankCardAlert = [[AlertObj alloc] initWithD:0 H:0 M:0 R:0];
        NSString* alertstr = [[dict allKeys] containsObject:Alert]?dict[Alert]:nil;
        if (alertstr) {
            NSArray* array = [alertstr componentsSeparatedByString:@"_"];
            if (array.count == 4) {
                self.bankCardAlert = [[AlertObj alloc] initWithD:[array[0] integerValue] H:[array[1] integerValue] M:[array[2] integerValue] R:[array[3] integerValue]];
            }
        }

    }
}


- (void)addAlertWithDay:(NSInteger)day
                   Hour:(NSInteger)hour
                    Min:(NSInteger)min
                 Repeat:(NSInteger)repeat{
    self.bankCardAlert = [[AlertObj alloc] initWithD:day
                                                   H:hour
                                                   M:min
                                                   R:repeat];
}

- (BOOL)isBlank
{
    if ([super isBlank] && [self isBlankString:self.bankCardExpire] && [self isBlankString:self.bankCardVVC] && self.bankCardPayDay == 0 && self.bankCardType == BCTdefault && self.bankCardAlert == nil) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)hasNotEdit:(LEOSecurityBoxDataBaseObject *)object
{
    LEOSBankCard *bankObject = (LEOSBankCard *)object;
    if ([super hasNotEdit:object] && [self.bankCardExpire isEqualToString:bankObject.bankCardExpire] && [self.bankCardVVC isEqualToString:bankObject.bankCardVVC] && self.bankCardType == bankObject.bankCardType && self.bankCardPayDay == bankObject.bankCardPayDay && [self.bankCardAlert isEqual:bankObject.bankCardAlert]) {
        return YES;
    }else{
        return NO;
    }
}

@end

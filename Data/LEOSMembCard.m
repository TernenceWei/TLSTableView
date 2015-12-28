//
//  LEOSMembCard.m
//  PrivacyGuard
//
//  Created by guohao on 16/11/15.
//  Copyright © 2015 LEO. All rights reserved.
//

#import "LEOSMembCard.h"

NSString* codeType = @"memCardCodeType";
NSString* phone = @"memCardPhone";
@implementation LEOSMembCard

- (NSString*)extension{
    NSMutableDictionary* mdic = [NSMutableDictionary new];
    [mdic setValue:@(self.memCardCodeType)                  forKey:codeType];
    [mdic setValue:CheckCardStrNull(self.memCardPhone)      forKey:phone];
    return [self getJsonFromDic:mdic];
}

- (void)setExtension:(NSString *)extension{
    NSDictionary* dict = [self getDictFromString:extension];
    if (dict) {
        self.memCardCodeType = [dict.allKeys containsObject:codeType]?[dict[codeType] intValue]:MCTdefault;
        self.memCardPhone    = [dict.allKeys containsObject:phone]?dict[phone]:@"";
    }
    
}

- (id)copyWithZone:(NSZone *)zone
{
    LEOSMembCard *object = [super copyWithZone:zone];
    object.memCardPhone = [_memCardPhone copy];
    object.memCardCodeType = _memCardCodeType;
    return object;
}

- (BOOL)isBlank
{
    if ([super isBlank] && [self isBlankString:self.memCardPhone] && self.memCardCodeType == MCTdefault) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)hasNotEdit:(LEOSecurityBoxDataBaseObject *)object
{
    LEOSMembCard *memberObject = (LEOSMembCard *)object;
    if ([super hasNotEdit:object] && [self.memCardPhone isEqualToString:memberObject.memCardPhone] && self.memCardCodeType == memberObject.memCardCodeType) {
        return YES;
    }else{
        return NO;
    }
}

@end

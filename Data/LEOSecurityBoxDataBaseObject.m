//
//  LEOSecurityBoxDataBaseObject.m
//  PrivacyGuard
//
//  Created by guohao on 12/11/15.
//  Copyright © 2015 LEO. All rights reserved.
//

#import "LEOSecurityBoxDataBaseObject.h"

@implementation LEOSecurityBoxDataBaseObject
- (UIImage*)getIconImage{
    if (self.icon_url) {
        UIImage* image = [UIImage imageWithContentsOfFile:self.icon_url];
        return image;
    }
    return nil;
}

-(NSString*)getJsonFromDic:(id)object
{
    NSString *jsonString = @"";
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSDictionary*)getDictFromString:(NSString*)jsStr{
    NSError *error = nil;
    NSData* jsonData = [jsStr dataUsingEncoding:NSASCIIStringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

- (NSDictionary*)getWebInfoDic{
    NSMutableDictionary *mdic = [NSMutableDictionary new];
    [mdic setValue:self.account forKey:@"username"];
    [mdic setValue:self.password forKey:@"password"];
    [mdic setValue:@(self.uid)forKey:@"accountID"];
    if (self.web_url) {
        [mdic setValue:self.web_url forKey:@"cardUrl"];
    }
    [mdic setValue:@(self.infoType) forKey:@"cardType"];
    return mdic;
}

- (id)copyWithZone:(NSZone *)zone
{
    LEOSecurityBoxDataBaseObject *object = [[self class] allocWithZone:zone];
    object.icon_url = [_icon_url copy];
    object.title = [_title copy];
    object.account = [_account copy];
    object.password = [_password copy];
    object.web_url = [_web_url copy];
    object.uid = _uid;
    object.infoType = _infoType;
    
    return object;
}

- (BOOL)isBlankString:(NSString *)string{
    
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


- (BOOL)isBlank
{
    if ([self isBlankString:self.title] && [self isBlankString:self.account] && [self isBlankString:self.password] && [self isBlankString:self.icon_url] && [self isBlankString:self.web_url]) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)hasNotEdit:(LEOSecurityBoxDataBaseObject *)object
{
    if ([self.icon_url isEqual:object.icon_url]) {
        return YES;
    }
    if ([self.icon_url isEqualToString:object.icon_url] && [self.title isEqualToString:object.title] && [self.account isEqualToString:object.account] && [self.password isEqualToString:object.password] && [self.web_url isEqualToString:object.web_url]) {
        return YES;
    }else{
        return NO;
    }
}

@end

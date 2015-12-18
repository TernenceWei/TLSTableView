//
//  LEOSLoginInfo.m
//  PrivacyGuard
//
//  Created by guohao on 16/11/15.
//  Copyright © 2015 LEO. All rights reserved.
//

#import "LEOSLoginInfo.h"

@implementation LEOSLoginInfo

- (NSString*)extension{
    NSMutableDictionary* mdic = [NSMutableDictionary new];
    [mdic setValue:self.domain                  forKey:@"domain"];
    return [self getJsonFromDic:mdic];
}

- (void)setExtension:(NSString *)extension{
    NSDictionary* dict = [self getDictFromString:extension];
    if (dict) {
        self.domain = [[dict allKeys] containsObject:@"domain"]?dict[@"domain"]:@"";
    }
}


@end

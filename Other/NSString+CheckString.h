//
//  NSString+CheckString.h
//  PrivacyGuard
//
//  Created by zhangweikai on 15/6/19.
//  Copyright (c) 2015年 LEO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (emailValidation)
- (BOOL)isValidEmail;
- (NSString *)urlencode;
- (NSString *)httpUrlCheck;
- (BOOL)isBlankString;
- (BOOL)isWebEquarWithString:(NSString*)str;
- (NSString*)getDomain;
@end

//
//  NSString+CheckString.m
//  PrivacyGuard
//
//  Created by zhangweikai on 15/6/19.
//  Copyright (c) 2015年 LEO. All rights reserved.
//

#import "NSString+CheckString.h"

@implementation NSString (emailValidation)
-(BOOL)isValidEmail
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (NSString*)httpUrlCheck{
    NSString* result = self;
    if (![result hasPrefix:@"http://"] && ![self hasPrefix:@"https://"]) {
        result = [NSString stringWithFormat:@"http://%@",result];
    }
    return result;
}

- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (BOOL)isBlankString{
    
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (NSString*)getDomain{
    return [self getDomainFromURL:self];
}

- (BOOL)containSubString:(NSString*)subString{
    if ([self rangeOfString:subString].location != NSNotFound) {
        return YES;
    }
    return NO;
}



- (NSString*)getDomainFromURL:(NSString*)strUrl{
    
    NSString* originStr = [strUrl copy];
    if (![strUrl hasPrefix:@"http://"]&&![strUrl hasPrefix:@"https://"]) {
        strUrl = [NSString stringWithFormat:@"http://%@",strUrl];
    }
    
    NSString* host = [[NSURL URLWithString:strUrl] host];
    if (host && ![host isEqualToString:@""]) {
        strUrl = host;
    }else{
        return originStr;
    }
    

    
    if ([strUrl hasPrefix:@"www."]) {
        strUrl = [strUrl stringByReplacingOccurrencesOfString:@"www." withString:@""];
    }
    
    if ([strUrl hasPrefix:@"m."] && strUrl.length > 2) {
        strUrl = [strUrl substringFromIndex:2];
    }
    
    NSArray* array = [strUrl componentsSeparatedByString:@"."];
    if (array.count < 2) {
        return originStr;
    }
    NSArray* orgs = @[@"ac",@"com",@"edu",@"gov",@"mil",@"arpa",@"net",@"org",@"biz",@"info",@"pro"];
    
    for (NSString* org in orgs) {
        for (int i = 0; i < array.count; i++) {
            NSString* segment = array[i];
            if ([segment isEqualToString:org]) {
                if (i - 1 >= 0) {
                    return array[i-1];
                }
            }
        }
    }
    
    NSArray* countries = @[@"im",@"hr",@"gw",@"in",@"ke",@"la",@"io",@"ht",@"gy",@"lb",@"kg",@"hu",@"lc",@"iq",@"kh",@"jm",@"ir",@"ki",@"is",@"ma",@"jo",@"it",@"jp",@"mc",@"km",@"md",@"li",@"kn",@"me",@"na",@"mf",@"lk",@"kp",@"mg",@"nc",@"mh",@"kr",@"ne",@"nf",@"mk",@"ng",@"ml",@"mm",@"lr",@"ni",@"kw",@"mn",@"ls",@"pa",@"mo",@"lt",@"ky",@"mp",@"lu",@"nl",@"kz",@"mq",@"lv",@"mr",@"pe",@"ms",@"qa",@"no",@"pf",@"mt",@"ly",@"np",@"pg",@"mu",@"ph",@"mv",@"om",@"nr",@"mw",@"mx",@"pk",@"my",@"nu",@"pl",@"mz",@"pm",@"pn",@"re",@"sa",@"sb",@"nz",@"sc",@"sd",@"pr",@"se",@"ps",@"pt",@"sg",@"tc",@"sh",@"td",@"si",@"pw",@"sj",@"ua",@"ro",@"tf",@"sk",@"py",@"tg",@"sl",@"th",@"sm",@"sn",@"rs",@"tj",@"va",@"so",@"tk",@"ug",@"ru",@"tl",@"vc",@"tm",@"sr",@"rw",@"tn",@"ve",@"ss",@"to",@"st",@"vg",@"sv",@"tr",@"vi",@"sx",@"wf",@"tt",@"sy",@"sz",@"tv",@"tw",@"vn",@"us",@"tz",@"ye",@"za",@"uy",@"vu",@"uz",@"ws",@"zm",@"ad",@"yt",@"ae",@"ba",@"af",@"bb",@"ag",@"bd",@"ai",@"be",@"ca",@"bf",@"bg",@"zw",@"al",@"cc",@"bh",@"am",@"cd",@"bi",@"an",@"bj",@"ao",@"cf",@"cg",@"bl",@"aq",@"ch",@"bm",@"ar",@"ci",@"bn",@"de",@"as",@"bo",@"at",@"ck",@"au",@"cl",@"ec",@"bq",@"cm",@"br",@"aw",@"cn",@"ee",@"bs",@"dj",@"ax",@"co",@"bt",@"dk",@"eg",@"az",@"eh",@"bv",@"dm",@"cr",@"bw",@"ga",@"do",@"by",@"gb",@"cu",@"bz",@"cv",@"gd",@"fi",@"cw",@"ge",@"fj",@"cx",@"gf",@"fk",@"cy",@"gg",@"cz",@"gh",@"fm",@"er",@"gi",@"es",@"fo",@"et",@"gl",@"dz",@"gm",@"id",@"fr",@"gn",@"ie",@"hk",@"gp",@"gq",@"gr",@"hn",@"je",@"gs",@"gt",@"gu",@"il",@"eu"];
    
    for (NSString* country in countries) {
        for (int i = 0; i < array.count; i++) {
            NSString* segment = array[i];
            if ([segment isEqualToString:country]) {
                if (i - 1 >= 0) {
                    return array[i-1];
                }
            }
        }
    }
    return originStr;
}

- (BOOL)isWebEquarWithString:(NSString*)str{
    if (str == nil || [str isEqualToString:@""]) {
        return NO;
    }
    NSString* selfstr = self;
    if (![selfstr hasPrefix:@"http://"]&&![selfstr hasPrefix:@"https://"]) {
        selfstr = [NSString stringWithFormat:@"http://%@",selfstr];
    }
    
    if (![str hasPrefix:@"http://"]&&![str hasPrefix:@"https://"]) {
        str = [NSString stringWithFormat:@"http://%@",str];
    }
    
    NSURL* selfURL = [NSURL URLWithString:selfstr];
    NSURL* tagURL = [NSURL URLWithString:str];
    
    NSString* host1 = [selfURL host];
    NSString* host2 = [tagURL host];
    
    
    host1 = [self getDomainFromURL:host1];
    host2 = [self getDomainFromURL:host2];
    
    
    
    
    return [host1  isEqualToString: host2];
}
@end

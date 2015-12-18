//
//  DataManager.m
//  PrivacyGuard
//
//  Created by guohao on 16/11/15.
//  Copyright © 2015 LEO. All rights reserved.
//

#import "DataManager.h"
#import "LEOSDataManager.h"
#import "LEOSMembCard.h"
#import "LEOFileUtil.h"
#import "NSString+CheckString.h"
#import "LEOSecurityBoxDataBaseObject.h"

static DataManager* sharedInstance;

@implementation DataManager


+(instancetype)sharedInstance{
    if (sharedInstance == nil) {
        sharedInstance = [[DataManager alloc] init];
    }
    return sharedInstance;
}

#pragma mark - security data (SData)
- (NSArray*)getSDataByType:(InfoType)type{
    return nil;
}

- (void)querySDataByType:(InfoType)type resultBlock:(void (^)(NSArray* array,BOOL result))block{
    [[LEOSDataManager sharedInstance] querySDataByType:type resultBlock:block];
}

- (void)queryAllSDataWithResultBlock:(void (^)(NSArray* array,BOOL result))block{
    [[LEOSDataManager sharedInstance] queryAllSDataWithResultBlock:block];
}

- (void)queryURLSDataWithResultBlock:(void (^)(NSArray* array,BOOL result))block{
    [[LEOSDataManager sharedInstance] queryAllURLSDataWithResultBlock:block];
}

- (void)addSData:(LEOSecurityBoxDataBaseObject*)card resultBlock:(void (^)(BOOL success, LEOSecurityBoxDataBaseObject *obj))block{
    [[LEOSDataManager sharedInstance] addSDataWithObj:card resultBlock:block];
}

- (void)updateSData:(LEOSecurityBoxDataBaseObject*)card
        resultBlock:(void (^)(BOOL success))block{
    [[LEOSDataManager sharedInstance] updateSDataWithObj:card resultBlock:block];
}

- (void)deleteSDataByID:(NSInteger)uid
            resultBlock:(void (^)(BOOL success))block{
    [[LEOSDataManager sharedInstance] deleteSDataByID:uid resultBlock:block];
}

#pragma mark - web account

- (void)getWebInfoArrayFromDB:(void(^)(NSArray* webInfoArray))block{
    [[LEOSDataManager sharedInstance] queryAllURLSDataWithResultBlock:^(NSArray *array, BOOL result) {
        if (block) {
            block(array);
        }
    }];
}

- (NSArray*)getDefualtIconArrayWithType:(InfoType)type{
    NSString* key  = @"";
    switch (type) {
        case infoType_loginInfo:
            key = @"webinfo";
            break;
        case infoType_bankCard:
            key = @"bankinfo";
            break;
        case infoType_membCard:
            key = @"memcardinfo";
            break;
        default:
            break;
    }
    NSMutableArray* marray = [NSMutableArray new];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"IconRes" ofType:@"plist"];
    NSDictionary* infodic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray* subarray = infodic[key];
    for (NSDictionary* dic in subarray) {
        LEOWebInfo* webinfo = [LEOWebInfo new];
        webinfo.webUrl = dic[@"webURL"];
        webinfo.iconUrl = [self getPathFromResource:dic[@"icon"]];
        webinfo.domain = dic[@"domain"];
        webinfo.type = type;
        [marray addObject:webinfo];
    }
    return marray;
}

- (NSArray*)orderWebinfoByName:(NSArray*)array{
    NSComparator cmptr = ^(LEOWebInfo* obj1, LEOWebInfo*  obj2){
        
        NSString* str1 = [self getDisplayNameFromWebinfo:obj1];
        NSString* str2 = [self getDisplayNameFromWebinfo:obj2];
        NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
        NSWidthInsensitiveSearch|NSForcedOrderingSearch;
        NSRange range = NSMakeRange(0,str1.length);
        return [str1 compare:str2 options:comparisonOptions range:range];
    };
    
    return [array sortedArrayUsingComparator:cmptr];
}

- (NSArray*)getCategoryIconArray{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"IconRes" ofType:@"plist"];
    NSDictionary* infodic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray* marray = [NSMutableArray new];
    NSDictionary* subdic = infodic[@"categoryInfo"];
    for (NSString* key in subdic.allKeys) {
        NSDictionary* dic = subdic[key];
        LEOWebInfo* webinfo = [LEOWebInfo new];
        webinfo.webUrl = dic[@"webURL"];
        webinfo.iconUrl = [self getPathFromResource:dic[@"icon"]];
        webinfo.domain = key;
        [marray addObject:webinfo];
    }
    
    subdic = infodic[@"memcardinfo"];
    for (NSString* key in subdic.allKeys) {
        NSDictionary* dic = subdic[key];
        LEOWebInfo* webinfo = [LEOWebInfo new];
        webinfo.webUrl = dic[@"webURL"];
        webinfo.iconUrl = [self getPathFromResource:dic[@"icon"]];
        webinfo.domain = key;
        [marray addObject:webinfo];
    }
 
    return marray;
}


- (NSString*)getPathFromResource:(NSString*)res{
    NSArray* array = [res componentsSeparatedByString:@"."];
    if (array.count == 2) {
        NSString* resourceName = array[0];
        NSString* type = array[1];
        return [[NSBundle mainBundle] pathForResource:resourceName ofType:type];
    }else {
        return res;
    }
    return nil;
}


- (NSString*)getDisplayNameFromWebinfo:(LEOWebInfo*)info{
    NSString* strKey = [NSString stringWithFormat:@"Card %@",info.domain];
    NSString* text;
    if (info.type == infoType_bankCard || info.type == infoType_membCard) {
        text = NSLocalizedString(strKey, nil);
    }else{
        if ([info.webUrl isEqualToString:@"mail.qq.com"]) {
            return @"QQ Mail";
        }else if ([info.webUrl isEqualToString:@"mail.yahoo.com"]){
            return @"Yahoo Mail";
        }else if ([info.webUrl isEqualToString:@"plus.google.com"]){
            return @"Google+";
        }
        text = [info.webUrl getDomain];
        if ([text isEqualToString:@"getpocket"]) {
            text = @"pocket";
        }
    }
    return text;
}


@end

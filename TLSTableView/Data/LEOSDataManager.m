//
//  LEOSDataManager.m
//  PrivacyGuard
//
//  Created by guohao on 16/11/15.
//  Copyright © 2015 LEO. All rights reserved.
//

#import "LEOSDataManager.h"
#import "NSString+CheckString.h"
#import "LEOSecurityBoxDataBaseObject.h"
#import "LEOFileUtil.h"
#import "FMDB.h"

#import "LEOSBankCard.h"
#import "LEOSMembCard.h"
#import "LEOSLoginInfo.h"

#define kSDataDBName @"sdataDB.sqlite3"
#define kSDataTableName @"sdata_table"

#define sdata_uid       @"uid"
#define sdata_type      @"info_type"
#define sdata_icon      @"icon_url"
#define sdata_title     @"title"
#define sdata_account   @"account"
#define sdata_password  @"password"
#define sdata_url       @"web_url"
#define sdata_comment   @"comment"
#define sdata_extension @"extension"

// DBVersion v1.7 = 0
// DBVersion v2.0 = 1
#define kDBVersion 1

static LEOSDataManager* sharedInstance;


@interface LEOSDataManager ()
@property (nonatomic,strong) NSString* sdataTableCreate;
@property (nonatomic,strong) NSDictionary* itemDict;
@property (strong, nonatomic) FMDatabaseQueue *mQueue;
@end

@implementation LEOSDataManager
+(instancetype)sharedInstance{
    if (sharedInstance == nil) {
        sharedInstance = [[LEOSDataManager alloc] init];
    }
    return sharedInstance;
}

- (FMDatabaseQueue *)mQueue{
    if (_mQueue == nil) {
        NSString *path = [[LEOFileUtil getDocumentPath] stringByAppendingPathComponent:@"boxdb.sqlite3"];
        NSString *databasePath = path;// [LEOFileUtil genDatabasePathWithName:kSDataDBName];
        _mQueue = [FMDatabaseQueue databaseQueueWithPath: databasePath];
      
    }
    return _mQueue;
}


- (instancetype)init{
    self = [super init];
    [self createTableIfNeeded];
    return self;
}

- (NSDictionary*)itemDict{
    if (_itemDict == nil) {
        NSMutableDictionary* mdic = [NSMutableDictionary new];
        [mdic setValue:@"INTEGER"   forKey:sdata_type];
        [mdic setValue:@"TEXT"      forKey:sdata_icon];
        [mdic setValue:@"TEXT"      forKey:sdata_title];
        [mdic setValue:@"TEXT"      forKey:sdata_account];
        [mdic setValue:@"TEXT"      forKey:sdata_password];
        [mdic setValue:@"TEXT"      forKey:sdata_url];
        [mdic setValue:@"TEXT"      forKey:sdata_comment];
        [mdic setValue:@"TEXT"      forKey:sdata_extension];
        _itemDict = [NSDictionary dictionaryWithDictionary:mdic];
    }
    return _itemDict;
}

- (NSString*)sdataTableCreate{
    NSString* str = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT",kSDataTableName,sdata_uid];
    for (NSString* key in self.itemDict.allKeys) {
        NSString* type = self.itemDict[key];
        str = [str stringByAppendingString:[NSString stringWithFormat:@",'%@' %@",key,type]];
    }
    str = [str stringByAppendingString:@")"];
    return str;
}



- (void)createTableIfNeeded{
    [self.mQueue inDatabase:^(FMDatabase *db) {
        BOOL ret = [db executeUpdate:self.sdataTableCreate];
        if (ret) {
            NSLog(@"execute create sql done");
        } else {
            NSLog(@"failded execute create sql");
        }
    }];
    
}



#pragma mark - add
- (NSString*)sdataTableAddWithObj:(LEOSecurityBoxDataBaseObject*)dataObj{
    
    NSMutableDictionary* mdic = [self getDicFromObj:dataObj];
    
    NSString* keyStr = @"";
    NSString* values = @"";
    for (NSString* key in mdic.allKeys) {
        keyStr = [keyStr stringByAppendingString:key];
        id cvalue = mdic[key];
        NSString* strValue = @"";
        if ([cvalue isKindOfClass:[NSString class]]) {
            
    
            strValue = [NSString stringWithFormat:@"'%@'",cvalue];
        }else if([cvalue isKindOfClass:[NSNumber class]]){
            strValue = [cvalue stringValue];
        }else if([cvalue isKindOfClass:[NSNull class]]){
            strValue = @"''";
        }
        values = [values stringByAppendingString:strValue];
        
        NSString* endStr = @"";
        if (![key isEqualToString:mdic.allKeys.lastObject]) {
            endStr = @", ";
        }else{
            endStr = @"";
        }
        
        keyStr = [keyStr stringByAppendingString:endStr];
        values = [values stringByAppendingString:endStr];
    }
    
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO '%@'( %@ ) VALUES ( %@ )",kSDataTableName,keyStr,values];
    
    return sql;
}
- (void)addSDataWithObj:(LEOSecurityBoxDataBaseObject*)dataObj
            resultBlock:(void (^)(BOOL result,LEOSecurityBoxDataBaseObject* addedObj))block{
    BOOL isMain = [NSThread currentThread].isMainThread;
    [self.mQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [self sdataTableAddWithObj:dataObj];

        
        BOOL ret = [db executeUpdate:sql];
        if (ret) {
            HHLog(@"add card done");
            dataObj.uid = db.lastInsertRowId;
        } else {
            HHLog(@"failded to add card");
            dataObj.uid = -1;
        }
        dispatch_queue_t queue;
        if (isMain) {
            queue = dispatch_get_main_queue();
        }else{
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        }
        dispatch_async(queue, ^{
            if (block) {
                block(ret,dataObj);
            }
        });
    }];
}

- (void)addSDataWithArray:(NSArray*)array resultBlock:(void (^)(BOOL result))block{
    
    BOOL isMain = [NSThread currentThread].isMainThread;
    
    [self.mQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        BOOL isRollBack = NO;
        @try {
            for (int i = 0; i < array.count; i++) {
                
                LEOSecurityBoxDataBaseObject* dataObj = array[i];
                NSString *sql = [self sdataTableAddWithObj:dataObj];
                BOOL a = [db executeUpdate:sql];
                if (!a) {
                    NSLog(@"insertFail");
                }
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        }
        @finally {
            dispatch_queue_t queue;
            if (isMain) {
                queue = dispatch_get_main_queue();
            }else{
                queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            }
            
            if (!isRollBack) {
                BOOL ret = [db commit];
                dispatch_async(queue, ^{
                    if (block) {
                        block(ret);
                    }
                });
            }else{
                dispatch_async(queue, ^{
                    if (block) {
                        block(NO);
                    }
                });
            }
        }
        
        
        
        
    }];
}


#pragma mark - update
- (NSString*)sdataTableUpdateWithObj:(LEOSecurityBoxDataBaseObject*)dataObj{
    NSMutableDictionary* mdic = [self getDicFromObj:dataObj];
    
    NSString* keyValueStr = @"";
    
    for (NSString* key in mdic.allKeys) {
        
        id cvalue = mdic[key];
        if ([cvalue isKindOfClass:[NSString class]]){
            
            keyValueStr = [keyValueStr stringByAppendingString:[NSString stringWithFormat:@"'%@'='%@'",key,cvalue]];
        }else if([cvalue isKindOfClass:[NSNumber class]]){
            keyValueStr = [keyValueStr stringByAppendingString:[NSString stringWithFormat:@"'%@'='%ld'",key,[cvalue integerValue]]];
        }
        
        if (![key isEqualToString:mdic.allKeys.lastObject]) {
            keyValueStr = [keyValueStr stringByAppendingString:@", "];
        }
        
    }
    
    NSString* uidstr = [NSString stringWithFormat:@"uid = %ld",dataObj.uid];
    
    NSString* sql = [NSString stringWithFormat:@"UPDATE '%@' SET %@ WHERE %@",kSDataTableName,keyValueStr,uidstr];
    
    return sql;
}

- (void)updateSDataWithObj:(LEOSecurityBoxDataBaseObject*)dataObj
               resultBlock:(void (^)(BOOL success))block{
    
    BOOL isMain = [NSThread currentThread].isMainThread;
    
    [self.mQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [self sdataTableUpdateWithObj:dataObj];
        
        BOOL ret = [db executeUpdate:sql];
        
        
        if (ret) {
            HHLog(@"add card done");
        } else {
            HHLog(@"failded to add card");
        }
        
        dispatch_queue_t queue;
        if (isMain) {
            queue = dispatch_get_main_queue();
        }else{
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        }
        dispatch_async(queue, ^{
            if (block) {
                block(ret);
            }
        });
        
        
    }];
}


#pragma mark -query

- (NSDictionary*)decryptDic:(NSDictionary*)dict{
    NSMutableDictionary* mdic = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    for(NSString* key in mdic.allKeys){
        id value = mdic[key];
        if ([value isKindOfClass:[NSString class]]) {
            [mdic setValue:mdic[key] forKey:key];
        }
    }
    return mdic;
}



- (void)queryAllSDataWithResultBlock:(void (^)(NSArray*,BOOL))block{
    BOOL isMain = [NSThread currentThread].isMainThread;
    [self.mQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM '%@'",kSDataTableName];
        FMResultSet *rs = [db executeQuery:sql];
        NSMutableArray *resultArray = [NSMutableArray new];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary];
            // 解密
            NSDictionary *endic = [self decryptDic:dic];
            // 转对象
            LEOSecurityBoxDataBaseObject* obj = [self getObjFromDict:endic];
            [resultArray addObject:obj];
        }
        resultArray = [[self orderArrayByUID:resultArray] mutableCopy];
        dispatch_queue_t queue;
        if (isMain) {
            queue = dispatch_get_main_queue();
        }else{
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        }
        dispatch_async(queue, ^{
            if (block) {
                block(resultArray, YES);
            }
        });
        
        
    }];
}

- (void)queryAllURLSDataWithResultBlock:(void (^)(NSArray* array, BOOL result))block{
    
    BOOL isMain = [[NSThread currentThread] isMainThread];
    
    [self.mQueue inDatabase:^(FMDatabase *db) {
        NSString *space = @"''";
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE %@<>%@",kSDataTableName, sdata_url,space];
        FMResultSet *rs = [db executeQuery:sql];
        NSMutableArray *resultArray = [NSMutableArray new];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary];
            // 解密
            NSDictionary *endic = [self decryptDic:dic];
            // 转对象
            LEOSecurityBoxDataBaseObject* obj = [self getObjFromDict:endic];
            [resultArray addObject:obj];
        }
        resultArray = [[self orderArrayByUID:resultArray] mutableCopy];
        dispatch_queue_t queue;
        if (isMain) {
            queue = dispatch_get_main_queue();
        }else{
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        }
        dispatch_async(queue, ^{
            if (block) {
                block(resultArray, YES);
            }
        });
        
        
    }];
}

- (void)querySDataByType:(InfoType)type
             resultBlock:(void (^)(NSArray*,BOOL))block{
    BOOL isMain = [NSThread currentThread].isMainThread;
    [self.mQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE %@='%ld'",kSDataTableName, sdata_type,(NSInteger)type];
        FMResultSet *rs = [db executeQuery:sql];
        NSMutableArray *resultArray = [NSMutableArray new];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary];
            NSDictionary *endic = [self decryptDic:dic];
            [resultArray addObject:[self getObjFromDict:endic]];
        }
        resultArray = [[self orderArrayByUID:resultArray] mutableCopy];
        dispatch_queue_t queue;
        if (isMain) {
            queue = dispatch_get_main_queue();
        }else{
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        }
        dispatch_async(queue, ^{
            if (block) {
                block(resultArray, YES);
            }
        });
        
    }];
}



- (NSArray*)orderArrayByUID:(NSArray*)array{
    NSComparator cmptr = ^(LEOSecurityBoxDataBaseObject* obj1, LEOSecurityBoxDataBaseObject*  obj2){
        if (obj1.uid > obj2.uid) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if (obj1.uid < obj2.uid) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    return [array sortedArrayUsingComparator:cmptr];
}

- (void)deleteSDataByID:(NSInteger)uid
            resultBlock:(void (^)(BOOL success))block{
    BOOL isMain = [NSThread currentThread].isMainThread;
    [self.mQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE %@=%ld",kSDataTableName, sdata_uid,uid];
        
        BOOL ret = [db executeUpdate:sql];
        dispatch_queue_t queue;
        if (isMain) {
            queue = dispatch_get_main_queue();
        }else{
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        }
        dispatch_async(queue, ^{
            if (block) {
                block(ret);
            }
        });
    }];
}

- (void)getCurrentDBVersion:(void (^)(int version))block{
    [self.mQueue inDatabase:^(FMDatabase *db) {
        if (block) {
            block(db.userVersion);
        }
    }];
}


- (void)setCurrentDBVersion:(int)version{
    [self.mQueue inDatabase:^(FMDatabase *db) {
        [db setUserVersion:version];
    }];
}

#pragma mark - obj & dict
- (NSMutableDictionary*)getDicFromObj:(LEOSecurityBoxDataBaseObject*)dataObj{
    NSMutableDictionary* mdic = [NSMutableDictionary new];
    [mdic setValue:@(dataObj.infoType) forKey:sdata_type];
    NSString* iconUrl = dataObj.icon_url;
    if (iconUrl != nil && ![iconUrl isEqualToString:@""]) {
        iconUrl = [self removeDocumentPrefix:iconUrl];
    }
    [mdic setValue:CheckCardStrNull(iconUrl)             forKey:sdata_icon];
    [mdic setValue:CheckCardStrNull(dataObj.title)       forKey:sdata_title];
    [mdic setValue:CheckCardStrNull(dataObj.account)     forKey:sdata_account];
    [mdic setValue:CheckCardStrNull(dataObj.password)    forKey:sdata_password];
    [mdic setValue:CheckCardStrNull(dataObj.web_url)     forKey:sdata_url];
    [mdic setValue:CheckCardStrNull(dataObj.comment)     forKey:sdata_comment];
    [mdic setValue:CheckCardStrNull(dataObj.extension)   forKey:sdata_extension];
    return mdic;
}

- (LEOSecurityBoxDataBaseObject*)getObjFromDict:(NSDictionary*)dict{
    
    InfoType itype = (InfoType)[dict.allKeys containsObject:sdata_type]?[dict[sdata_type] intValue]:0;
    
    LEOSecurityBoxDataBaseObject* sdataObj;
    
    switch (itype) {
        case infoType_bankCard:
            sdataObj = [LEOSBankCard new];
            break;
        case infoType_loginInfo:
            sdataObj = [LEOSLoginInfo new];
            break;
        case infoType_membCard:
            sdataObj = [LEOSMembCard new];
            break;
        default:
            sdataObj = [LEOSecurityBoxDataBaseObject new];
            break;
    }
    sdataObj.infoType = itype;
    sdataObj.uid   = [dict.allKeys containsObject:sdata_uid]?[dict[sdata_uid] integerValue]:0;
    sdataObj.title = [dict.allKeys containsObject:sdata_title]?dict[sdata_title]:@"";
    NSString* iconUrl = [dict.allKeys containsObject:sdata_icon]?dict[sdata_icon]:@"";
    sdataObj.icon_url = [self addDocumentPrefix:iconUrl];
    sdataObj.account   = [dict.allKeys containsObject:sdata_account]?dict[sdata_account]:@"";
    sdataObj.password  = [dict.allKeys containsObject:sdata_password]?dict[sdata_password]:@"";
    sdataObj.web_url   = [dict.allKeys containsObject:sdata_url]?dict[sdata_url]:@"";
    sdataObj.comment   = [dict.allKeys containsObject:sdata_comment]?dict[sdata_comment]:@"";
    sdataObj.extension = [dict.allKeys containsObject:sdata_extension]?dict[sdata_extension]:@"";
    
    return sdataObj;
}

- (NSString*)addDocumentPrefix:(NSString*)str{
    if ([str isBlankString]) {
        return str;
    }
    NSString* docPrefix = [[NSBundle mainBundle] bundlePath];
    
    if ([str hasPrefix:docPrefix]) {
        return str;
    }else{
        return [docPrefix stringByAppendingPathComponent:str];
    }
    return nil;
}

- (NSString*)removeDocumentPrefix:(NSString*)str{
    if ([str isBlankString]) {
        return str;
    }
    NSString* docPrefix = [[NSBundle mainBundle] bundlePath];
    
    if ([str hasPrefix:docPrefix]) {
        return [str stringByReplacingOccurrencesOfString:[docPrefix stringByAppendingString:@"/"] withString:@""];
    }else{
        return str;
    }
    return nil;
}

@end

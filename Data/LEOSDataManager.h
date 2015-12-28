//
//  LEOSDataManager.h
//  PrivacyGuard
//
//  Created by guohao on 16/11/15.
//  Copyright © 2015 LEO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOSecurityBoxDataBaseObject.h"

@class FMDatabase;
@interface LEOSDataManager : NSObject

+(instancetype)sharedInstance;
- (void)addSDataWithObj:(LEOSecurityBoxDataBaseObject*)dataObj
           resultBlock:(void (^)(BOOL result,LEOSecurityBoxDataBaseObject* addedObj))block;

- (void)addSDataWithArray:(NSArray*)array
              resultBlock:(void (^)(BOOL result))block;

- (void)updateSDataWithObj:(LEOSecurityBoxDataBaseObject*)dataObj
               resultBlock:(void (^)(BOOL result))block;

- (void)queryAllSDataWithResultBlock:(void (^)(NSArray* array, BOOL result))block;

/*!
 * abstract 查询URL不为空的结果
 */
- (void)queryAllURLSDataWithResultBlock:(void (^)(NSArray* array, BOOL result))block;

- (void)querySDataByType:(InfoType)type
             resultBlock:(void (^)(NSArray* array, BOOL result))block;

- (void)deleteSDataByID:(NSInteger)uid
            resultBlock:(void (^)(BOOL success))block;


// DBUpgrade

- (void)getCurrentDBVersion:(void (^)(int version))block;
- (void)setCurrentDBVersion:(int)version;



- (NSString*)removeDocumentPrefix:(NSString*)str;
- (NSString*)addDocumentPrefix:(NSString*)str;
@end

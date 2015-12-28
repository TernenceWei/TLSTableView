//
//  DataManager.h
//  PrivacyGuard
//
//  Created by guohao on 16/11/15.
//  Copyright © 2015 LEO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOSecurityBoxDataBaseObject.h"
#import "LEOWebInfo.h"

@interface DataManager : NSObject

+(instancetype)sharedInstance;

#pragma mark - security data (SData)
- (void)querySDataByType:(InfoType)type
             resultBlock:(void (^)(NSArray* array,BOOL result))block;

- (void)queryAllSDataWithResultBlock:(void (^)(NSArray* array,BOOL result))block;
/*!
 * abstract 查询URL不为空的结果
 */
- (void)queryURLSDataWithResultBlock:(void (^)(NSArray* array,BOOL result))block;
- (void)addSData:(LEOSecurityBoxDataBaseObject*)card
     resultBlock:(void (^)(BOOL success, LEOSecurityBoxDataBaseObject *obj))block;

- (void)updateSData:(LEOSecurityBoxDataBaseObject*)card
        resultBlock:(void (^)(BOOL success))block;

- (void)deleteSDataByID:(NSInteger)uid
            resultBlock:(void (^)(BOOL success))block;

#pragma mark - web account
- (void)getWebInfoArrayFromDB:(void(^)(NSArray* webInfoArray))block;
- (NSArray*)getDefualtIconArrayWithType:(InfoType)type;
- (NSString*)getDisplayNameFromWebinfo:(LEOWebInfo*)webinfo;


@end

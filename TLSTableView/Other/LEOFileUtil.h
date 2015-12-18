//
//  LEOFileUtil.h
//  PrivacyGuard
//
//  Created by apple on 15/6/8.
//  Copyright (c) 2015年 LEO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LEOFileUtil : NSObject
+ (void)prepareFolders;
+ (NSString*)getDocumentPath;
+ (NSString*)genFullScreenPathWithName:(NSString*)name;
+ (NSString*)genThumbPathWithName:(NSString*)thumbName;
+ (NSString*)genRawPathWithName:(NSString*)picName;
+ (NSString*)genMetaPathWithName:(NSString*)picName;
+ (NSString*)genDatabasePathWithName:(NSString*)databaseName;
+ (NSData*)getThumbDataWithName:(NSString*)thumbName;


+ (void)removeAssetFilesWithName:(NSString*)assetName;
+ (uint64_t)getFreeDiskspacePrivate;
+ (NSString *)getCurrentDeviceModel;
@end


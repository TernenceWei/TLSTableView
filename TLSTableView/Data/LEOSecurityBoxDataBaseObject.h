//
//  LEOSecurityBoxDataBaseObject.h
//  PrivacyGuard
//
//  Created by guohao on 12/11/15.
//  Copyright © 2015 LEO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define CheckCardStrNull(x) x?x:@""

typedef enum {
    infoType_default = 0,
    infoType_loginInfo,
    infoType_membCard,
    infoType_bankCard
}InfoType;

@interface LEOSecurityBoxDataBaseObject : NSObject<NSCopying>
@property (nonatomic)        NSInteger uid;
@property (nonatomic)        InfoType  infoType;
@property (nonatomic,strong) NSString* icon_url;
@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSString* account;
@property (nonatomic,strong) NSString* password;
@property (nonatomic,strong) NSString* web_url;
/*!
 @abstract 备注
 */
@property (nonatomic,strong) NSString* comment;
@property (nonatomic,strong) NSString* extension;

- (UIImage*)getIconImage;
- (NSString*)getJsonFromDic:(id)object;
- (NSDictionary*)getDictFromString:(NSString*)jsStrl;
- (NSDictionary*)getWebInfoDic;
- (BOOL)isBlankString:(NSString *)string;
- (BOOL)isBlank;
- (BOOL)hasNotEdit:(LEOSecurityBoxDataBaseObject *)object;
@end

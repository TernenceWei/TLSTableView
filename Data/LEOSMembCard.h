//
//  LEOSMembCard.h
//  PrivacyGuard
//
//  Created by guohao on 16/11/15.
//  Copyright © 2015 LEO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOSecurityBoxDataBaseObject.h"

typedef enum {
    MCTdefault = 0,
    MCTQRCode,
    MCTBarCode
}MemCodeType;

@interface LEOSMembCard : LEOSecurityBoxDataBaseObject<NSCopying>

/* super class
 @property (nonatomic)        InfoType  infoType;
 @property (nonatomic,strong) NSString* icon_url;
 @property (nonatomic,strong) NSString* title;
 @property (nonatomic,strong) NSString* account;
 @property (nonatomic,strong) NSString* password;
 @property (nonatomic,strong) NSString* web_url;
 @property (nonatomic,strong) NSString* comment;
 @property (nonatomic,strong) NSString* extension;
 */

@property (nonatomic,strong) NSString* memCardPhone;
/*!
 @abstract 条码类型(MCT) QRCode&BarCode
 */
@property (nonatomic,assign) MemCodeType memCardCodeType;

@end

//
//  LEOSLoginInfo.h
//  PrivacyGuard
//
//  Created by guohao on 16/11/15.
//  Copyright © 2015 LEO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOSecurityBoxDataBaseObject.h"
@interface LEOSLoginInfo : LEOSecurityBoxDataBaseObject

// super class
//@property (nonatomic)        InfoType  infoType;
//@property (nonatomic,strong) NSString* icon_url;
//@property (nonatomic,strong) NSString* title;
//@property (nonatomic,strong) NSString* account;
//@property (nonatomic,strong) NSString* password;
//@property (nonatomic,strong) NSString* web_url;
//@property (nonatomic,strong) NSString* comment;
//@property (nonatomic,strong) NSString* extension;

@property (nonatomic,strong) NSString* domain;

@end

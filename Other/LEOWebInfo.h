//
//  LEOWebInfo.h
//  PrivacyGuard
//
//  Created by guohao on 16/11/15.
//  Copyright © 2015 LEO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOSecurityBoxDataBaseObject.h"

@interface LEOWebInfo : NSObject
@property (nonatomic) InfoType type;
@property (nonatomic,strong) NSString* iconUrl;
@property (nonatomic,strong) NSString* domain;
@property (nonatomic,strong) NSString* webUrl;
@end

 

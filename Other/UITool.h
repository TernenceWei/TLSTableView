//
//  UITool.h
//  PrivacyGuard
//
//  Created by apple on 15/5/29.
//  Copyright (c) 2015年 LEO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TLSUIStandardHeader.h"

@interface UITool : NSObject
+ (CGSize)sizeWithString:(NSString *)title font:(UIFont *)font;
+ (CGSize)sizeWithString:(NSString *)title font:(UIFont *)font constrainedToSize:(CGSize)size;
+ (UIViewController*)getTopViewController;
+ (void)showPhotoAuthDialog;
+ (NSString*)getDisplayDateString:(NSString*)dateStr;
+ (UIToolbar*)generateAlbumToolbar;
+ (void)addCornnerWithView:(UIView*)contentView
              cornnerImage:(UIImage*)cornerImg;
+ (void)showAlertWithMsg:(NSString*)msg;
+ (BOOL)isBlankString:(NSString *)string;
+ (NSString*)getPreferredLanguage;
+ (NSString *)getTimeNow;
@end

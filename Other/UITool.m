//
//  UITool.m
//  PrivacyGuard
//
//  Created by apple on 15/5/29.
//  Copyright (c) 2015年 LEO. All rights reserved.
//

#import "UITool.h"

@implementation UITool
+ (NSString *)getTimeNow
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    NSString* timeNow = [formatter stringFromDate:[NSDate date]];
    return timeNow;
}

+ (CGSize)sizeWithString:(NSString*)title font:(UIFont*)font
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    return [title sizeWithAttributes:attrs];
}

+ (CGSize)sizeWithString:(NSString *)title font:(UIFont *)font constrainedToSize:(CGSize)size
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    return [title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (UIViewController*)getTopViewController{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}

+ (void)showPhotoAuthDialog{
//    LEOBaseAlertView *alert = [[LEOBaseAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
//                                                              message:NSLocalizedString(@"Check settings/privacy/photos and enable access to make sure properly adding photos.", nil)
//                                                             delegate:nil
//                                                    cancelButtonTitle:NSLocalizedString(@"ok_for_auth", nil)
//                                                    otherButtonTitles:nil, nil];
//    [alert show];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Authority Please allow us to access your photos in\"Settings\"->\"Privacy\"->\"Photos\"", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"private camera not authorized i know", nil) otherButtonTitles:nil, nil];
    alertView.delegate = self;
    [alertView show];
}

+ (UIToolbar*)generateAlbumToolbar{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    if ([[UIToolbar class] respondsToSelector:@selector(appearance)]) {
        [toolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [toolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsLandscapePhone];
    }
    toolbar.barStyle = UIBarStyleBlackTranslucent; //UIBarStyleBlackTranslucent;
    toolbar.barTintColor = [C1 colorWithAlphaComponent:0.9f];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    return toolbar;
}

/*
 format: year, month, day, weekNumber, weekOfYear
 */
+ (NSString*)getDisplayDateString:(NSString*)dateStr{
    NSArray *dateArray = [dateStr componentsSeparatedByString:@":"];
    NSString *year = dateArray[0];
    NSString *month = dateArray[1];
    NSString *day = dateArray[2];
    NSString *weekNumber = dateArray[3];
    NSString *weakOfYear = dateArray[4];
    
    /* today */
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSString *curYear = [NSString stringWithFormat:@"%ld", [comps year]];
    NSString *curMonth = [NSString stringWithFormat:@"%ld", [comps month]];
    NSString *curDay = [NSString stringWithFormat:@"%ld", [comps day]];
    NSString *curWeekNumber = [NSString stringWithFormat:@"%ld", [comps weekday]];
    NSString *curWeekOfYear = [NSString stringWithFormat:@"%ld", [comps weekOfYear]];
    
    BOOL isHanS = NO;
//    if ([[self getPreferredLanguage] isEqualToString:@"zh-Hans"] || [[self getPreferredLanguage] isEqualToString:@"zh-Hant"]) {
//        isHanS = YES;
//    } else {
//        isHanS = NO;
//    }
    
    if ([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"zh-Han"].location != NSNotFound) {
        isHanS = YES;
    }else{
        isHanS = NO;
    }
    
    if (![year isEqualToString:curYear]) {
        if (isHanS) {
            return [NSString stringWithFormat:@"%@年%@月%@日", year, month, day];
        } else {
            return [NSString stringWithFormat:@"%@ %@, %@", [self convertMonth:[month intValue]], day, year];
        }
    } else {
        if (![month isEqualToString:curMonth]) {
            if (isHanS) {
                return [NSString stringWithFormat:@"%@月%@日", month, day];
            } else {
                return [NSString stringWithFormat:@"%@ %@", [self convertMonth:[month intValue]], day];
            }
        } else {
            if ([weakOfYear isEqualToString:curWeekOfYear]) {
                if ([curWeekNumber intValue]-[weekNumber intValue] == 1) {
//                    return isHanS?@"昨天":@"Yesterday";
                      return  NSLocalizedString(@"privacy album yesterday", nil);
                } else if([curWeekNumber intValue] == [weekNumber intValue]){
//                    return isHanS?@"今天":@"Today";
                      return  NSLocalizedString(@"privacy album today", nil);
                } else {
                    // 1:Sunday  - 7:Saturday
                    return [self convertWeakDay:[weekNumber intValue]];
                }
            } else {
                if (isHanS) {
                    return [NSString stringWithFormat:@"%@月%@日", month, day];
                } else {
                    return [NSString stringWithFormat:@"%@ %@", [self convertMonth:[month intValue]], day];
                }
            }
        }
    }
    
    return nil;
}

/* Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday, */
+ (NSString*)convertWeakDay:(int)weekday{
    switch (weekday) {
            
        case 1:
        {
            return NSLocalizedString(@"device monitor charge - date weekDay - Sunday", nil);
        }
        case 2:
        {
            return NSLocalizedString(@"device monitor charge - date weekDay - Monday", nil);
        }
        case 3:
        {
            return NSLocalizedString(@"device monitor charge - date weekDay - Tuesday", nil);
        }
        case 4:
        {
            return NSLocalizedString(@"device monitor charge - date weekDay - Wednesday", nil);
        }
        case 5:
        {
            return NSLocalizedString(@"device monitor charge - date weekDay - Thursday", nil);
        }
        case 6:
        {
            return NSLocalizedString(@"device monitor charge - date weekDay - Friday", nil);
        }
        case 7:
        {
            return NSLocalizedString(@"device monitor charge - date weekDay - Saturday", nil);
        }
            
        default:
            break;
    }
    return NSLocalizedString(@"device monitor charge - date weekDay - Sunday", nil);
}

/*
 一月 Jan. January	二月 Feb. February	三月 Mar. March	四月 Apr. April
 五月 May. May	六月 June. June	七月 July. July	八月 Aug. Aguest
 九月 Sept. September	十月 Oct. October	十一月 Nov. November	十二月 Dec. December
 */
+ (NSString*)convertMonth:(int)month{
    switch (month) { 
        case 1:
        {
            return NSLocalizedString(@"device monitor month - January", nil);
        }
        case 2:
        {
            return NSLocalizedString(@"device monitor month - February", nil);
        }
        case 3:
        {
            return NSLocalizedString(@"device monitor month - March", nil);
        }
        case 4:
        {
            return NSLocalizedString(@"device monitor month - April", nil);
        }
        case 5:
        {
            return NSLocalizedString(@"device monitor month - May", nil);
        }
        case 6:
        {
            return NSLocalizedString(@"device monitor month - June", nil);
        }
        case 7:
        {
            return NSLocalizedString(@"device monitor month - July", nil);
        }
        case 8:
        {
            return NSLocalizedString(@"device monitor month - August", nil);
        }
        case 9:
        {
            return NSLocalizedString(@"device monitor month - September", nil);
        }
        case 10:
        {
            return NSLocalizedString(@"device monitor month - October", nil);
        }
        case 11:
        {
            return NSLocalizedString(@"device monitor month - November", nil);
        }
        case 12:
        {
            return NSLocalizedString(@"device monitor month - December", nil);
        }
        default:
            break;
    }
    return NSLocalizedString(@"device monitor month - January", nil);
}

+ (NSString*)getPreferredLanguage
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    return preferredLang;
}

+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

#pragma mark - UIView
+ (void)addCornnerWithView:(UIView*)contentView
              cornnerImage:(UIImage*)cornerImg{
    float delta = cornerImg.size.width/2;
    CGPoint pt_lt = CGPointMake(delta, delta);
    CGPoint pt_rt = CGPointMake(contentView.frame.size.width - delta, delta);
    CGPoint pt_lb = CGPointMake(delta, contentView.frame.size.height - delta -1);
    CGPoint pt_rb = CGPointMake(contentView.frame.size.width - delta, contentView.frame.size.height - delta-1);
    NSArray* ptarray = @[[NSValue valueWithCGPoint:pt_lt],
                         [NSValue valueWithCGPoint:pt_rt],
                         [NSValue valueWithCGPoint:pt_rb],
                         [NSValue valueWithCGPoint:pt_lb]];
    
    
    for (int i = 0; i < ptarray.count; i++) {
        UIImageView* imagv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cornerImg.size.width, cornerImg.size.height)];
        imagv.image = cornerImg;
        CGPoint pt = [ptarray[i] CGPointValue];
        imagv.center = pt;
        imagv.transform = CGAffineTransformMakeRotation(i * 90 *M_PI / 180.0);
        [contentView addSubview:imagv];
    }
    
}


#pragma mark - alertv

+ (void)showAlertWithMsg:(NSString*)msg{
    UIAlertView* alertv = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];
    [alertv show];
}
@end

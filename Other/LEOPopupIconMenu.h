//
//  LEOPopupIconMenu.h
//  PrivacyGuard
//
//  Created by guohao on 20/11/15.
//  Copyright © 2015 LEO. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LEOWebInfo;
@interface LEOPopupIconMenu : UIView


- (instancetype)initWithSize:(CGSize)size
                       Array:(NSArray*)items;

- (void)setSelectBlock:(void(^)(LEOWebInfo* webinfo))block;
- (void)showMenuInView:(UIView*)view;
@end

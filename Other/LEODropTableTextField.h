//
//  LEODropTableTextField.h
//  DropList
//
//  Created by guohao on 18/11/15.
//  Copyright © 2015 guohao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LEOWebInfo;
@interface LEODropTableTextField : UITextField
- (instancetype)initWithFrame:(CGRect)frame
                    DataArray:(NSArray*)array;
- (void)setSelectBlock:(void(^)(LEOWebInfo* webinfo))block;
- (void)setTextChangeBlock:(void(^)(NSString* content, BOOL finished))block;
@end

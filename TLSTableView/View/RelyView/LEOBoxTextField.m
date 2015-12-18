//
//  LEOBoxTextField.m
//  PrivacyGuard
//
//  Created by Ternence on 15/11/17.
//  Copyright © 2015年 LEO. All rights reserved.
//

#import "LEOBoxTextField.h"

@implementation LEOBoxTextField
- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.borderStyle = UITextBorderStyleNone;
        self.returnKeyType = UIReturnKeyDone;
        self.keyboardType = UIKeyboardTypeDefault;
    }
    return self;
}

- (void)setEditEnabled:(BOOL)editEnabled
{
    _editEnabled = editEnabled;
    if (_editEnabled) {
        self.userInteractionEnabled = YES;
    }else{
        self.userInteractionEnabled = NO;
    }
}

@end

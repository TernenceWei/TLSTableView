//
//  LEODropListTableViewCell.m
//  PrivacyGuard
//
//  Created by guohao on 23/11/15.
//  Copyright © 2015 LEO. All rights reserved.
//

#import "LEODropListTableViewCell.h"
#import "UITool.h"

@implementation LEODropListTableViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.imageView.layer.cornerRadius = 3;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.borderColor = C3.CGColor;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.frame = CGRectMake(10, 10, 28, 28);
    CGRect rect = self.textLabel.frame;
    rect.origin.x = 48;
    self.textLabel.frame = rect;
    self.textLabel.font = T4;
    self.textLabel.textColor = C1;
    UIEdgeInsets edget = self.separatorInset;
    edget.left = 48;
    self.separatorInset = edget;
    self.textLabel.text = [self.textLabel.text capitalizedString];
}

@end

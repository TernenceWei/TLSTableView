//
//  LEOBaseNavigationController.m
//  PrivacyGuard
//
//  Created by Ternence on 15/11/11.
//  Copyright © 2015年 LEO. All rights reserved.
//

#import "LEOBaseNavigationController.h"
#import "UITool.h"

@interface LEOBaseNavigationController ()

@end

@implementation LEOBaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setupNavigationBar
{
    self.navigationController.navigationBar.hidden = YES;
    
    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.navigationBar.barTintColor = C5;
    [self.view addSubview:self.navigationBar];
    
    self.titleItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"device monitor Bettery Percentage", nil)];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: C4, NSFontAttributeName: T1};
    self.titleItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"navigationBar_leftBack_blue"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(backButtonAction)];
    self.navigationBar.items = @[self.titleItem];
    
}

- (void)setupNavigationBarWithOutBackBtn
{
    self.navigationController.navigationBar.hidden = YES;
    
    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.navigationBar.barTintColor = C5;
    [self.view addSubview:self.navigationBar];
    
    UIView *dividerLine = [[UIView alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    dividerLine.backgroundColor = C5;
    [self.navigationBar addSubview:dividerLine];
    
    self.titleItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"device monitor Bettery Percentage", nil)];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: C4, NSFontAttributeName: T1};
    self.navigationBar.items = @[self.titleItem];
    
}

- (void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

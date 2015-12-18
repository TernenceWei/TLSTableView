//
//  TLSTabBarViewController.m
//  TLSTableView
//
//  Created by Ternence on 15/12/18.
//  Copyright © 2015年 Leomaster. All rights reserved.
//

#import "TLSTabBarViewController.h"
#import "LEOBoxViewController.h"

@interface TLSTabBarViewController ()

@end

@implementation TLSTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    LEOBoxViewController *boxVC1 = [[LEOBoxViewController alloc] init];
    boxVC1.boxVCType = LEOBoxVCTypeAccount;
    boxVC1.title = NSLocalizedString(@"登录信息", nil);
    boxVC1.tabBarItem.image = [[UIImage imageNamed:@"tab_account_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    boxVC1.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_account_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:boxVC1];
    
    LEOBoxViewController *boxVC2 = [[LEOBoxViewController alloc] init];
    boxVC2.boxVCType = LEOBoxVCTypeMember;
    boxVC2.title = NSLocalizedString(@"会员卡", nil);
    boxVC2.tabBarItem.image = [[UIImage imageNamed:@"tab_vip_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    boxVC2.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_vip_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:boxVC2];
    
    LEOBoxViewController *boxVC3 = [[LEOBoxViewController alloc] init];
    boxVC3.boxVCType = LEOBoxVCTypeBank;
    boxVC3.title = NSLocalizedString(@"银行卡", nil);
    boxVC3.tabBarItem.image = [[UIImage imageNamed:@"tab_bank_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    boxVC3.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_bank_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:boxVC3];
    
    self.viewControllers = [NSArray arrayWithObjects:nav1, nav2,nav3, nil];
    
    self.hidesBottomBarWhenPushed = YES;
    
}


@end

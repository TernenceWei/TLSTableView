//
//  LEOBaseNavigationController.h
//  PrivacyGuard
//
//  Created by Ternence on 15/11/11.
//  Copyright © 2015年 LEO. All rights reserved.
//
/**
 *  关于导航栏
 1.如需自定义导航栏，控制器继承自LEOBaseNavigationController，该控制器继承自LEOBaseViewController,主要处理导航栏事宜,如不需要请继承自LEOBaseViewController。父类控制器不会主动调用setupNavigationBar方法。子类重载setupNavigationBar方法，调用super方法后，默认会有一个白色的左边有返回按钮的导航栏。鉴于Tabbar的rootviewcontroller没有返回按钮，特提供setupNavigationBarWithOutBackBtn方法，请按需选择。
 2.如需更改导航栏颜色，请在子类方法中添加代码self.navigationBar.barTintColor = [UIColor greenColor];相应的title颜色如需更改，添加代码self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor greenColor]};
 3.如需添加导航栏底部的一根线，添加代码
 UIView *dividerLine = [[UIView alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
 dividerLine.backgroundColor = HHColorWithAlpha(0, 0, 0, 0.2);
 [self.navigationBar addSubview:dividerLine];
 4.如果想要添加导航栏右边的按钮，添加代码
 self.titleItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Information-Icon"] style:UIBarButtonItemStyleBordered target:self                                                                     action:@selector(vidgetGuideBtnDidClicked)];相应的点击事件自行处理
 5.如果想要在返回按钮的点击事件中处理一些事物，重载backButtonAction方法，最后调用super方法
 6.如果要动态改变左右按钮的图片或文字或点击事件，示例如下：
 self.titleItem.leftBarButtonItem.image = [UIImage imageNamed:@"Information-Icon"];
 self.titleItem.leftBarButtonItem.title = @"fuck";
 self.titleItem.leftBarButtonItem.action = @selector(backButtonAction);
 7.如果遇到图片被自动渲染成其他颜色，请尝试如下修改
 UIImage *image = [UIImage imageNamed:@"Information-Icon"];
 self.titleItem.leftBarButtonItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
 8.Controller内部的view frame从64开始，因为导航栏属于控制器。
 9.如需更改title文字，请添加代码
 self.titleItem.title = NSLocalizedString(@"device monitor Bettery Percentage", nil);
 或self.titleItem.titleView;

 */


#import <UIKit/UIKit.h>

@interface LEOBaseNavigationController : UIViewController

@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UINavigationItem *titleItem;

- (void)setupNavigationBar;
- (void)setupNavigationBarWithOutBackBtn;
- (void)backButtonAction;
@end

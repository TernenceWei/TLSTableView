//
//  LEOBoxViewController.m
//  PrivacyGuard
//
//  Created by Ternence on 15/11/11.
//  Copyright © 2015年 LEO. All rights reserved.
//

#import "LEOBoxViewController.h"
#import "LEOBoxBaseCell.h"
#import "UITableView+Wave.h"
#import "LEOBoxBasicCellConfig.h"
#import "LEOBoxBaseCellHeader.h"
#import "LEOSLoginInfo.h"
#import "LEOSMembCard.h"
#import "LEOSBankCard.h"
#import "LEOSDataManager.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "NSString+CheckString.h"
#import "UITool.h"

#define KCancelAlertTag 10
#define KDeleteAlertTag 11
#define KNoticeAlertTag 12
#define KWebNoticeAlertTag 13
#define KDisappearAlertTag 14
#define KUpgradeUserAlertTag 113

@interface LEOBoxViewController ()<UITableViewDataSource,UITableViewDelegate,LEOBoxBaseCellDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UITabBarControllerDelegate>
@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UINavigationItem *titleItem;

@property (nonatomic, strong) UITableView *tableView;
/**配置文件*/
@property (nonatomic, strong) NSMutableArray *cellConfigs;
/**数据源*/
@property (nonatomic, strong) NSMutableArray *dataArray;
/**当前处于编辑或新建的数据*/
@property (nonatomic, strong) LEOSLoginInfo *saveObject;
@property (nonatomic, strong) LEOSMembCard *saveMemObject;
@property (nonatomic, strong) LEOSBankCard *saveBankObject;
/**放弃编辑恢复到原数据*/
@property (nonatomic, strong) LEOSecurityBoxDataBaseObject *normalObject;
/**用于在不同方法中传递变量*/
@property (nonatomic, strong) NSIndexPath *previewIndexPath;
@property (nonatomic, strong) NSIndexPath *editIndexPath;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property (nonatomic, strong) NSIndexPath *deleteIndexPath;
@property (nonatomic, strong) NSIndexPath *noticeIndexPath;
/**当前所处状态*/
@property (nonatomic, assign) LEOBoxBaseCellStatus currentStatus;

@property (nonatomic, assign) CGFloat oldOffsetY;
@end

@implementation LEOBoxViewController
#pragma mark 懒加载
- (NSMutableArray *)cellConfigs
{
    if (!_cellConfigs) {
        _cellConfigs = [NSMutableArray array];
    }
    return _cellConfigs;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //出现动画
    if (self.currentStatus == LEOBoxBaseCellStatusNormal) {
        [self.tableView reloadDataAnimateWithWave:LeftToRightWaveAnimation];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupSubViews];
    [self loadData];
    [self addWaveAnimationNotification];

    
}

#pragma mark 界面初始化
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

    NSString *title = NSLocalizedString(@"登录信息", nil);
    switch (self.boxVCType) {
        case LEOBoxVCTypeAccount:
            title = NSLocalizedString(@"登录信息", nil);
            break;
        case LEOBoxVCTypeMember:
            title = NSLocalizedString(@"会员卡", nil);
            break;
        case LEOBoxVCTypeBank:
            title = NSLocalizedString(@"银行卡", nil);
            break;
    }
    self.titleItem.title = title;
    self.titleItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"box_navBar_add_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addANewItem)];
    //去掉底部的一条黑线
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
 
}

- (void)setupSubViews
{
    self.view.backgroundColor = C5;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = C5;
    [self.view addSubview:self.tableView];

}

- (void)loadData
{
    InfoType type = infoType_loginInfo;
    switch (self.boxVCType) {
        case LEOBoxVCTypeAccount:{
            type = infoType_loginInfo;
            break;
        }
        case LEOBoxVCTypeMember:{
            type = infoType_membCard;
            break;
        }
        case LEOBoxVCTypeBank:{
            type = infoType_bankCard;
            break;
        }
    }
    self.currentStatus = LEOBoxBaseCellStatusNormal;
    [[LEOSDataManager sharedInstance] querySDataByType:type resultBlock:^(NSArray *array, BOOL result) {
        if (array.count) {
            //防止重复添加
            if (self.dataArray.count) {
                [self.dataArray removeAllObjects];
            }
            if (self.cellConfigs.count) {
                [self.cellConfigs removeAllObjects];
            }
            self.dataArray = [array mutableCopy];
            //生成对应的配置文件
            for (LEOSecurityBoxDataBaseObject *object in self.dataArray) {
                LEOBoxBasicCellConfig *config = [LEOBoxBasicCellConfig configWithStatus:LEOBoxBaseCellStatusNormal object:object type:self.boxVCType];
                [self.cellConfigs addObject:config];
            }
            [self.tableView reloadDataAnimateWithWave:LeftToRightWaveAnimation];
        }
    }];

}

- (void)addWaveAnimationNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waveAnimationBegin:) name:KBoxWaveAnimationBeginNotification object:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waveAnimationEnd:) name:KBoxWaveAnimationEndNotification object:self.tableView];
    
    //点击空白区域收起键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark navigationBar
- (void)navigationBarEnterEditMode
{
    self.titleItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"box_navBar_cancel_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit)];
    self.titleItem.rightBarButtonItem.image = [[UIImage imageNamed:@"box_navBar_finish_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.titleItem.rightBarButtonItem.action = @selector(saveEdit);
}

- (void)navigationBarbackToNormalState
{
    self.titleItem.leftBarButtonItem.image = [[UIImage imageNamed:@"navigationBar_leftBack_blue"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.titleItem.leftBarButtonItem.action = @selector(backButtonAction);
    self.titleItem.rightBarButtonItem.image = [[UIImage imageNamed:@"box_navBar_add_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.titleItem.rightBarButtonItem.action = @selector(addANewItem);
}

#pragma mark 新建条目，取消，保存
/**
 *  新建一个条目
 */
- (void)addANewItem
{
    
    if (self.currentStatus == LEOBoxBaseCellStatusPreview) {
        [self cellChangeToStatus:LEOBoxBaseCellStatusNormal withIndexPath:self.previewIndexPath];
        self.currentStatus = LEOBoxBaseCellStatusNormal;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.previewIndexPath.section] withRowAnimation:UITableViewRowAnimationBottom];
    }
    self.currentStatus = LEOBoxBaseCellStatusNew;
    
    switch (self.boxVCType) {
        case LEOBoxVCTypeAccount:{
            self.saveObject = [[LEOSLoginInfo alloc] init];
            self.saveObject.infoType = infoType_loginInfo;
            
            break;
        }
        case LEOBoxVCTypeMember:{
            self.saveMemObject = [[LEOSMembCard alloc] init];
            self.saveMemObject.infoType = infoType_membCard;

            break;
        }
        case LEOBoxVCTypeBank:{
            self.saveBankObject = [[LEOSBankCard alloc] init];
            self.saveBankObject.infoType = infoType_bankCard;

            break;
        }
    }
    
    LEOBoxBasicCellConfig *config = [LEOBoxBasicCellConfig configWithStatus:LEOBoxBaseCellStatusNew type:self.boxVCType];
    [self.cellConfigs insertObject:config atIndex:0];
    
    [self.tableView beginUpdates];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    [self currentItemScrollToTop:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    LEOBoxBaseCell *cell = [self.tableView cellForRowAtIndexPath:firstIndex];
    [self navigationBarEnterEditMode];

    [cell topViewTitleStartEdit];
 
}

/**
 *  放弃编辑
 */
- (void)cancelEdit
{
    [self.view endEditing:YES];

    if(iOS9){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"放弃编辑？", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"放弃", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self cancelSaveEditItems];
            
        }];
        [alertController addAction:cancel];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"继续", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"放弃编辑？", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"放弃", nil) otherButtonTitles:NSLocalizedString(@"继续", nil), nil];
        alert.tag = KCancelAlertTag;
        [alert show];
    }
}

- (void)cancelSaveEditItems{
    [self.view endEditing:YES];
    if (self.currentStatus == LEOBoxBaseCellStatusEdit) {
        [self.dataArray replaceObjectAtIndex:self.editIndexPath.section withObject:self.normalObject];
        [self cellChangeToStatus:LEOBoxBaseCellStatusPreview withIndexPath:self.editIndexPath];
        
        self.currentStatus = LEOBoxBaseCellStatusPreview;
        self.previewIndexPath = self.editIndexPath;
        [self.tableView reloadData];
        [self currentItemScrollToTop:self.previewIndexPath];
    }else if (self.currentStatus == LEOBoxBaseCellStatusNew) {
        [self.cellConfigs removeObjectAtIndex:0];
        self.currentStatus = LEOBoxBaseCellStatusNormal;
        [self.tableView reloadData];
    }
    [self navigationBarbackToNormalState];

}


/**
 *  保存当前的编辑
 */
- (void)saveEdit
{
    //获取当前焦点，收起键盘
    [self requestFirstResponder];
    
    LEOSecurityBoxDataBaseObject *object;
    NSString *toastMessage = NSLocalizedString(@"Mian Card Please enter card number", nil);
    if (self.boxVCType == LEOBoxVCTypeAccount) {
        object = self.saveObject;
        toastMessage = NSLocalizedString(@"Mian Account Please enter card number", nil);
    }else if (self.boxVCType == LEOBoxVCTypeMember) {
        object = self.saveMemObject;
    }else if (self.boxVCType == LEOBoxVCTypeBank) {
        object = self.saveBankObject;
    }
    if ([self isBlankString:object.account]) {
        
        return;
    }
    if ([self isBlankString:object.title]) {
        if (![self isBlankString:object.web_url]) {
            object.title = [object.web_url getDomain];
        }
    }
    if (self.currentStatus == LEOBoxBaseCellStatusEdit) {
        
        [self.dataArray replaceObjectAtIndex:self.editIndexPath.section withObject:object];
        [self cellChangeToStatus:LEOBoxBaseCellStatusPreview withIndexPath:self.editIndexPath];
        [[LEOSDataManager sharedInstance] updateSDataWithObj:object resultBlock:^(BOOL result) {
            if (result) {

            }
        }];
        self.currentStatus = LEOBoxBaseCellStatusPreview;
        self.previewIndexPath = self.editIndexPath;
        [self.tableView reloadData];
        [self currentItemScrollToTop:self.editIndexPath];
    }else if (self.currentStatus == LEOBoxBaseCellStatusNew){

        [self.dataArray insertObject:object atIndex:0];
        [self cellChangeToStatus:LEOBoxBaseCellStatusPreview withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [[DataManager sharedInstance] addSData:object
                                   resultBlock:^(BOOL result, LEOSecurityBoxDataBaseObject *addedObj) {
        
            if (result) {
                [self.dataArray replaceObjectAtIndex:0 withObject:addedObj];
            }
        }];
        
        self.currentStatus = LEOBoxBaseCellStatusPreview;
        self.previewIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadData];
        [self currentItemScrollToTop:[NSIndexPath indexPathForRow:0 inSection:0]];
    }

    [self navigationBarbackToNormalState];

}

#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag == KCancelAlertTag && buttonIndex == 0) {
        [self cancelSaveEditItems];
        
    }
    if (alertView.tag == KDeleteAlertTag && buttonIndex == 1) {
       
        LEOSecurityBoxDataBaseObject *object = self.dataArray[self.deleteIndexPath.section];
        [self.dataArray removeObjectAtIndex:self.deleteIndexPath.section];
        [self.cellConfigs removeObjectAtIndex:self.deleteIndexPath.section];

        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.deleteIndexPath.section] withRowAnimation:UITableViewRowAnimationRight];
        self.currentStatus = LEOBoxBaseCellStatusNormal;
        [self navigationBarbackToNormalState];
        [[LEOSDataManager sharedInstance] deleteSDataByID:object.uid resultBlock:^(BOOL success) {
            if (success) {

            }
        }];

    }
    if (alertView.tag == KNoticeAlertTag) {
        if (buttonIndex == 0) {
            if (self.currentStatus == LEOBoxBaseCellStatusEdit) {
                
                [self cellChangeToStatus:LEOBoxBaseCellStatusNormal withIndexPath:self.editIndexPath];
                self.currentStatus = LEOBoxBaseCellStatusNormal;
                [self cellChangeToStatus:LEOBoxBaseCellStatusPreview withIndexPath:self.noticeIndexPath];
                self.currentStatus = LEOBoxBaseCellStatusPreview;
                self.previewIndexPath = self.noticeIndexPath;
                
                self.lastIndexPath = self.noticeIndexPath;
  
                [self.tableView reloadData];
                [self currentItemScrollToTop:self.noticeIndexPath];
                
            }else if (self.currentStatus == LEOBoxBaseCellStatusNew){

                [self.cellConfigs removeObjectAtIndex:0];
                self.currentStatus = LEOBoxBaseCellStatusNormal;
                NSInteger section = self.noticeIndexPath.section - 1;
                if (section < 0) {
                    section = 0;
                }
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                [self cellChangeToStatus:LEOBoxBaseCellStatusPreview withIndexPath:indexPath];
                self.currentStatus = LEOBoxBaseCellStatusPreview;
                self.previewIndexPath = indexPath;
                self.lastIndexPath = indexPath;
 
                [self.tableView reloadData];
                [self currentItemScrollToTop:indexPath];

            }
            
            [self navigationBarbackToNormalState];
        }else{//取消后箭头要回转
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.noticeIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
    }
    
}


#pragma mark tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellConfigs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LEOBoxBaseCell *cell = [LEOBoxBaseCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.config = self.cellConfigs[indexPath.section];
    [self handelBlockWithConfig:cell.config];
    return cell;
}

#pragma mark tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LEOBoxBasicCellConfig *config = self.cellConfigs[indexPath.section];
    return config.cellHeight;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    tempView.backgroundColor = C5;
    return tempView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    tempView.backgroundColor = C5;
    return tempView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.cellConfigs.count - 1) {
        return 0.1;
    }else{
        return Cell_Cell_Margin - 1;
    }
}

#pragma mark 处理点击事件
- (void)topViewTitleAndIconChange:(LEOWebInfo *)webInfo
{
    if (self.boxVCType == LEOBoxVCTypeAccount) {
        _saveObject.icon_url = webInfo.iconUrl;
        _saveObject.title = [[DataManager sharedInstance] getDisplayNameFromWebinfo:webInfo];;
        _saveObject.web_url = webInfo.webUrl;
        _saveObject.domain = webInfo.domain;
        
    }else if (self.boxVCType == LEOBoxVCTypeMember) {
        _saveMemObject.icon_url = webInfo.iconUrl;
        _saveMemObject.title = [[DataManager sharedInstance] getDisplayNameFromWebinfo:webInfo];;
        _saveMemObject.web_url = webInfo.webUrl;
        
    }else if (self.boxVCType == LEOBoxVCTypeBank) {
        _saveBankObject.icon_url = webInfo.iconUrl;
        _saveBankObject.title = [[DataManager sharedInstance] getDisplayNameFromWebinfo:webInfo];;
        _saveBankObject.web_url = webInfo.webUrl;
        
    }
}

- (void)handelBlockWithConfig:(LEOBoxBasicCellConfig *)config
{
    LEOBoxBasicCellTopViewConfig *topConfig = config.topConfig;
    topConfig.iconBlock = ^(LEOWebInfo *webInfo){

        [self topViewTitleAndIconChange:webInfo];
        LEOBoxBaseCell *cell;
        if (self.currentStatus == LEOBoxBaseCellStatusNew) {
            cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [self refreshConfigWithIndex:0];

        }else if (self.currentStatus == LEOBoxBaseCellStatusEdit) {
            cell = [self.tableView cellForRowAtIndexPath:self.editIndexPath];
 
        }
        if (self.boxVCType == LEOBoxVCTypeAccount) {
            
            [cell refreshAccountEditObject:_saveObject];
        }else if (self.boxVCType == LEOBoxVCTypeMember) {
            
            [cell refreshMemberEditObject:_saveMemObject];
        }else if (self.boxVCType == LEOBoxVCTypeBank) {
            
            [cell refreshBankEditObject:_saveBankObject];
        }
        
    };
    topConfig.titleBlock = ^(LEOWebInfo *webInfo){

        [self topViewTitleAndIconChange:webInfo];
        LEOBoxBaseCell *cell;
        if (self.currentStatus == LEOBoxBaseCellStatusNew) {
            cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [self refreshConfigWithIndex:0];
            
        }else if (self.currentStatus == LEOBoxBaseCellStatusEdit) {
            cell = [self.tableView cellForRowAtIndexPath:self.editIndexPath];
        }
        
        if (self.boxVCType == LEOBoxVCTypeAccount) {
            
            [cell refreshAccountEditObject:_saveObject];
        }else if (self.boxVCType == LEOBoxVCTypeMember) {
            
            [cell refreshMemberEditObject:_saveMemObject];
        }else if (self.boxVCType == LEOBoxVCTypeBank) {
            
            [cell refreshBankEditObject:_saveBankObject];
        }
        
    };
    topConfig.textChangeBlock = ^(NSString *content, BOOL finished){
        if (self.boxVCType == LEOBoxVCTypeAccount) {
            _saveObject.title = content;
        }else if (self.boxVCType == LEOBoxVCTypeMember) {
            _saveMemObject.title = content;
        }else if (self.boxVCType == LEOBoxVCTypeBank) {
            _saveBankObject.title = content;
        }
    };
    
    NSArray *itemConfigs = config.bottomConfig.itemConfigs;
    for (LEOBoxBasicCellBottomViewItemConfig *config  in itemConfigs) {
        switch (config.itemType) {
            case LEOBoxCellItemTypeNormal:{
                
                break;
            }
            case LEOBoxCellItemTypeComment:{
                config.keboardBlock = ^(CGRect frame){
                    
                    [self scrollCurrentCellToVisiableToFill:frame additionalY:0];
                };
                config.dataBlock = ^(NSString *content){

                    if (self.boxVCType == LEOBoxVCTypeAccount) {
                        _saveObject.comment = content;
                    }else if (self.boxVCType == LEOBoxVCTypeMember) {
                        _saveMemObject.comment = content;
                    }else if (self.boxVCType == LEOBoxVCTypeBank) {
                        _saveBankObject.comment = content;
                    }
                };
                break;
            }
            case LEOBoxCellItemTypeWebsite:{
                
                config.keboardBlock = ^(CGRect frame){
                    [self scrollCurrentCellToVisiableToFill:frame additionalY:0];
                };

                config.dataBlock = ^(NSString *content){
                    if (self.boxVCType == LEOBoxVCTypeAccount) {
                        _saveObject.web_url = content;
                    }else if (self.boxVCType == LEOBoxVCTypeMember) {
                        _saveMemObject.web_url = content;
                    }else if (self.boxVCType == LEOBoxVCTypeBank) {
                        _saveBankObject.web_url = content;
                    }
                };
                break;
            }
                //银行卡
            case LEOBoxCellItemTypeBankCardNumber:{

                config.keboardBlock = ^(CGRect frame){
                    
                    [self scrollCurrentCellToVisiableToFill:frame additionalY:0];
                };

                config.dataBlock = ^(NSString *content){
                    _saveBankObject.account = content;
                };
                break;
            }
                
            case LEOBoxCellItemTypeBankVVC:{
                config.keboardBlock = ^(CGRect frame){
                    
                    [self scrollCurrentCellToVisiableToFill:frame additionalY:0];
                };
                config.dataBlock = ^(NSString *content){
                    _saveBankObject.bankCardVVC = content;
                };
                break;
            }
                //会员卡
            case LEOBoxCellItemTypeMemberCardNumber:{
                config.clickBlock = ^(){
                };
                config.keboardBlock = ^(CGRect frame){
                    
                    [self scrollCurrentCellToVisiableToFill:frame additionalY:53];
                };
                config.dataBlock = ^(NSString *content){
                    _saveMemObject.account = content;
                    
                    
                };
                break;
            }
                
            case LEOBoxCellItemTypePhoneNumber:{
                config.keboardBlock = ^(CGRect frame){
                    
                    [self scrollCurrentCellToVisiableToFill:frame additionalY:0];
                };
                config.dataBlock = ^(NSString *content){
                    _saveMemObject.memCardPhone = content;
                    
                };
                break;
            }
                //登录信息
            case LEOBoxCellItemTypeAccountNum:{
                config.keboardBlock = ^(CGRect frame){
                    
                    [self scrollCurrentCellToVisiableToFill:frame additionalY:0];
                };
                config.dataBlock = ^(NSString *content){
                    _saveObject.account = content;
                    
                };
                break;
            }
            case LEOBoxCellItemTypePassword:{
                config.keboardBlock = ^(CGRect frame){
                    
                    [self scrollCurrentCellToVisiableToFill:frame additionalY:0];
                };
                config.dataBlock = ^(NSString *content){
                    _saveObject.password = content;
                };
                break;
            }
            default:
                break;
                
        }
    }
}

#pragma mark scrollview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.oldOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat newOffsetY = scrollView.contentOffset.y;
    if (self.oldOffsetY > newOffsetY) {
        [self.view endEditing:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat newOffsetY = scrollView.contentOffset.y;
    if (self.oldOffsetY > newOffsetY) {
        [self.view endEditing:YES];
    }
}

#pragma mark LeoBoxBaseCell delegate
/**
 *  预览或收回
 */
- (void)boxBaseCell:(LEOBoxBaseCell *)cell switchCellStatusWithPreviewFlag:(BOOL)previewFlag
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!self.titleItem.rightBarButtonItem.enabled) {
        return;
    }
    
    if (previewFlag) {//展开
        //当前处于编辑或新建状态时，提醒用户放弃编辑
        if (self.currentStatus == LEOBoxBaseCellStatusNew || self.currentStatus == LEOBoxBaseCellStatusEdit) {

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"放弃编辑", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"放弃", nil) otherButtonTitles:NSLocalizedString(@"继续", nil), nil];
            alert.tag = KNoticeAlertTag;
            [alert show];
            self.noticeIndexPath = indexPath;
        }else{
            //当前已有item处于预览状态时，收回该item
            if (self.lastIndexPath) {
                [self cellChangeToStatus:LEOBoxBaseCellStatusNormal withIndexPath:self.lastIndexPath];
                self.lastIndexPath = nil;
            }
            [self cellChangeToStatus:LEOBoxBaseCellStatusPreview withIndexPath:indexPath];
            self.lastIndexPath = indexPath;
            self.currentStatus = LEOBoxBaseCellStatusPreview;
            self.previewIndexPath = indexPath;
            [self.tableView reloadData];
            [self currentItemScrollToTop:self.previewIndexPath];
        }
    }else{//收回
        [self cellChangeToStatus:LEOBoxBaseCellStatusNormal withIndexPath:indexPath];
        self.currentStatus = LEOBoxBaseCellStatusNormal;
        [self.tableView reloadData];
    }
    
}

/**
 *  编辑
 */
- (void)boxBaseCell:(LEOBoxBaseCell *)cell enterEditMode:(LEOBoxBasicCellConfig *)config
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.editIndexPath = indexPath;
    [self cellChangeToStatus:LEOBoxBaseCellStatusEdit withIndexPath:indexPath];

    self.currentStatus = LEOBoxBaseCellStatusEdit;
    if (self.boxVCType == LEOBoxVCTypeAccount) {
        self.saveObject = self.dataArray[indexPath.section];
        self.normalObject = [self.saveObject copy];
        
    }else if (self.boxVCType == LEOBoxVCTypeMember) {
        
        self.saveMemObject = self.dataArray[indexPath.section];
        LEOSMembCard *cardOjet = (LEOSMembCard *)self.saveMemObject;
        self.normalObject = [cardOjet copy];
    }else if (self.boxVCType == LEOBoxVCTypeBank) {
        
        self.saveBankObject = self.dataArray[indexPath.section];
        LEOSBankCard *cardOjet = (LEOSBankCard *)self.saveBankObject;
        self.normalObject = [cardOjet copy];
    }

    [self.tableView reloadData];
    [self currentItemScrollToTop:self.editIndexPath];
    [self navigationBarEnterEditMode];

}

/**
 *  创建桌面快捷方式
 */
- (void)boxBaseCell:(LEOBoxBaseCell *)cell createShortcut:(LEOBoxBasicCellConfig *)config
{

}

/**
 *  删除一个条目
 */
- (void)boxBaseCell:(LEOBoxBaseCell *)cell deleteCell:(LEOBoxBasicCellConfig *)config
{
    self.deleteIndexPath = [self.tableView indexPathForCell:cell];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Can't recover after deleting, delete?", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Delete", nil), nil];
    alert.tag = KDeleteAlertTag;
    [alert show];
}

#pragma mark keyboard
/**
 *  处理键盘挡住输入框问题
 *  @param additionalY 处理会员卡的输入框
 */
- (void)scrollCurrentCellToVisiableToFill:(CGRect)cellFrame additionalY:(CGFloat)additionalY
{
    LEOBoxBaseCell *currentCell = [self.tableView cellForRowAtIndexPath:self.editIndexPath];
    if (self.currentStatus == LEOBoxBaseCellStatusNew) {
        currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    CGFloat convertCellY = CGRectGetMaxY([currentCell convertRect:cellFrame toView:self.tableView]) + Cell_Normal_TopView_H + Cell_Preview_BottomView_Cell_H + 64 + ConvertByHeight(10);
    CGFloat offsetY = self.tableView.contentOffset.y;
    CGPoint offset = self.tableView.contentOffset;
    if (convertCellY - offsetY > SCREEN_HEIGHT - (216 + additionalY)) {
        offset.y += ((convertCellY - offsetY) - (SCREEN_HEIGHT - (216 + additionalY)));
        [self.tableView setContentOffset:offset animated:YES];
    }
}

- (void)closeKeyboard{
    [self.view endEditing:YES];
}

- (void)requestFirstResponder
{
    //获取当前焦点，收起键盘
    UITextField *textField = [[UITextField alloc] init];
    [self.view addSubview:textField];
    [textField becomeFirstResponder];
    [textField resignFirstResponder];
}

#pragma mark business logic
/**
 *  动画执行期间不可新建条目
 */
- (void)waveAnimationBegin:(NSNotification*)noti
{
    if (noti.object == self.tableView && self.currentStatus == LEOBoxBaseCellStatusNormal) {
        self.titleItem.rightBarButtonItem.image = [[UIImage imageNamed:@"box_navBar_add_disable"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.titleItem.rightBarButtonItem.enabled = NO;
        //动画执行期间不可点击下拉按钮
        NSArray *cells = [self.tableView visibleCells];
        for (LEOBoxBaseCell *cell in cells) {
            [cell arrowBtnEnabled:NO];
        }
        
    }
}

- (void)waveAnimationEnd:(NSNotification*)noti
{
    if (noti.object == self.tableView && self.currentStatus == LEOBoxBaseCellStatusNormal) {
        self.titleItem.rightBarButtonItem.image = [[UIImage imageNamed:@"box_navBar_add_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.titleItem.rightBarButtonItem.action = @selector(addANewItem);
        self.titleItem.rightBarButtonItem.enabled = YES;
        NSArray *cells = [self.tableView visibleCells];
        for (LEOBoxBaseCell *cell in cells) {
            [cell arrowBtnEnabled:YES];
        }
    }
    
}

/**
 *  刷新配置文件，以解决滚动过程中cell复用问题
 */
- (void)refreshConfigWithIndex:(NSUInteger)index
{
    LEOBoxBasicCellConfig *config = self.cellConfigs[index];
    if (self.boxVCType == LEOBoxVCTypeAccount) {
       config = [LEOBoxBasicCellConfig configWithStatus:LEOBoxBaseCellStatusNew object:_saveObject type:LEOBoxVCTypeAccount];
    }else if (self.boxVCType == LEOBoxVCTypeMember) {
        config = [LEOBoxBasicCellConfig configWithStatus:LEOBoxBaseCellStatusNew object:_saveMemObject type:LEOBoxVCTypeMember];
    }else if (self.boxVCType == LEOBoxVCTypeBank) {
        config = [LEOBoxBasicCellConfig configWithStatus:LEOBoxBaseCellStatusNew object:_saveBankObject type:LEOBoxVCTypeBank];
    }
    [self.cellConfigs replaceObjectAtIndex:index withObject:config];
}

/**
 *  切换状态，更改配置文件
 */
- (void)cellChangeToStatus:(LEOBoxBaseCellStatus)status withIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section <= self.dataArray.count - 1) {
        LEOBoxBasicCellConfig *config = [LEOBoxBasicCellConfig configWithStatus:status object:self.dataArray[indexPath.section] type:self.boxVCType];
        [self.cellConfigs replaceObjectAtIndex:indexPath.section withObject:config];
    }
}

- (void)setCurrentStatus:(LEOBoxBaseCellStatus)currentStatus
{
    _currentStatus = currentStatus;
    if (_currentStatus == LEOBoxBaseCellStatusNormal || _currentStatus == LEOBoxBaseCellStatusPreview) {
        [self.view endEditing:YES];
        self.tableView.tableFooterView = nil;

    }else if (_currentStatus == LEOBoxBaseCellStatusNew || _currentStatus == LEOBoxBaseCellStatusEdit){

        /**用于滚动tableview，以方便用户输入*/
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = C5;
        footerView.frame = CGRectMake(0, 0, Cell_BottomView_Cell_W, 400);
        self.tableView.tableFooterView = footerView;
        
        
    }
}

/**
 *  当前处于编辑，新建，预览的条目滚动到页面顶端
 */
- (void)currentItemScrollToTop:(NSIndexPath *)indexPath
{
    LEOBoxBaseCell *currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self.tableView setContentOffset:CGPointMake(0, currentCell.frame.origin.y) animated:YES];
}

/**
 *  为空判断
 */
- (BOOL)isBlankString:(NSString *)string{

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


- (void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
@end

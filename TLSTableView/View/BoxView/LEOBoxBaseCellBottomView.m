//
//  LEOBoxBaseCellBottomView.m
//  PrivacyGuard
//
//  Created by Ternence on 15/11/12.
//  Copyright © 2015年 LEO. All rights reserved.
//

#import "LEOBoxBaseCellBottomView.h"
#import "LEOBoxBaseBottomCell.h"
#import "LEOBoxBasicCellBottomViewConfig.h"
#import "LEOBoxBaseCellHeader.h"
#import "UITool.h"

@interface LEOBoxBaseCellBottomView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LEOBoxBaseCellBottomView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
        
        self.layer.shadowColor = HHColor(0xd0, 0xd8, 0xea).CGColor;
        self.layer.shadowOpacity = 0.36;
        self.layer.shadowOffset = CGSizeMake(4, 4);
        self.layer.shadowRadius = 4;
    }
    return self;
}

#pragma mark 登录信息
- (void)refreshAccountEditObject:(LEOSecurityBoxDataBaseObject *)object
{
    LEOBoxBaseBottomCell *cell6 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell6.textField.text = object.web_url;
}


#pragma mark 银行卡
- (void)refreshBankEditObject:(LEOSecurityBoxDataBaseObject *)object
{
    LEOSBankCard *bankObject = (LEOSBankCard *)object;

    LEOBoxBaseBottomCell *cell0 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell0.textField.text = bankObject.account;
    
    LEOBoxBaseBottomCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell1.textField.text = bankObject.bankCardVVC;

    LEOBoxBaseBottomCell *cell4 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell4.textField.text = bankObject.web_url;
    
    LEOBoxBaseBottomCell *cell5 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell5.textField.text = bankObject.comment;
    
}

- (void)refreshMemberEditObject:(LEOSecurityBoxDataBaseObject *)object
{
    LEOBoxBaseBottomCell *cell0 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell0.textField.text = object.account;
    
    LEOBoxBaseBottomCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell2.textField.text = object.web_url;
    
    LEOSMembCard *card = (LEOSMembCard *)object;
    if (![self isBlankString:card.memCardPhone]) {
        LEOBoxBaseBottomCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell1.textField.text = card.memCardPhone;
    }
    if (![self isBlankString:card.comment]) {
        LEOBoxBaseBottomCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell3.textField.text = card.comment;
    }
}

- (void)setConfig:(LEOBoxBasicCellBottomViewConfig *)config
{
    _config = config;
    [self.tableView reloadData];
}

#pragma mark tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.config.status == LEOBoxBaseCellStatusPreview) {
        return self.config.itemConfigs.count - 1;
    }else if (self.config.status == LEOBoxBaseCellStatusEdit) {
        return self.config.itemConfigs.count - 1;
    }else if (self.config.status == LEOBoxBaseCellStatusNew) {
        return self.config.itemConfigs.count;
    }
    return 5;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LEOBoxBaseBottomCell *cell = [LEOBoxBaseBottomCell cellWithTableView:tableView tag:indexPath.row];
    cell.status = self.config.status;
    cell.config = self.config.itemConfigs[indexPath.row];
    return cell;
}

#pragma mark tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LEOBoxBasicCellBottomViewItemConfig *config = self.config.itemConfigs[indexPath.row];
    return config.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LEOBoxBasicCellBottomViewItemConfig *config = [self.config.itemConfigs lastObject];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = C6;
    if (self.config.status == LEOBoxBaseCellStatusPreview) {
        UIButton *editBtn = [[UIButton alloc] init];
        [editBtn setImage:[UIImage imageNamed:@"box_toolBar_edit_normal"] forState:UIControlStateNormal];
        [editBtn setImage:[UIImage imageNamed:@"box_toolBar_edit_press"] forState:UIControlStateHighlighted];
        [editBtn addTarget:self action:@selector(editBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:editBtn];
        
        UIButton *shortcutBtn = [[UIButton alloc] init];
        [shortcutBtn setImage:[UIImage imageNamed:@"box_toolBar_shortcut_normal"] forState:UIControlStateNormal];
        [shortcutBtn setImage:[UIImage imageNamed:@"box_toolBar_shortcut_press"] forState:UIControlStateHighlighted];
        [shortcutBtn addTarget:self action:@selector(shortcutBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:shortcutBtn];
        
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setImage:[UIImage imageNamed:@"box_toolBar_delete_normal"] forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"box_toolBar_delete_press"] forState:UIControlStateHighlighted];
        [deleteBtn addTarget:self action:@selector(deleteBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:deleteBtn];
        
        if (belowIOS8) {//编辑，删除按钮
            shortcutBtn.hidden = YES;
            CGFloat width = self.bounds.size.width / 2;
            editBtn.frame = CGRectMake(0, 0, width, config.height);
            deleteBtn.frame = CGRectMake(width, 0, width, config.height);
        }else{//编辑，快捷方式，删除按钮
            shortcutBtn.hidden = NO;
            CGFloat width = self.bounds.size.width / 3;
            editBtn.frame = CGRectMake(0, 0, width, config.height);
            shortcutBtn.frame = CGRectMake(width, 0, width, config.height);
            deleteBtn.frame = CGRectMake(width * 2, 0, width, config.height);
        }
        
    }else if (self.config.status == LEOBoxBaseCellStatusEdit) {
        //删除按钮
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setImage:[UIImage imageNamed:@"box_toolBar_delete_normal"] forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"box_toolBar_delete_press"] forState:UIControlStateHighlighted];
        [deleteBtn addTarget:self action:@selector(deleteBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.frame = CGRectMake(0, 0, self.bounds.size.width, config.height);
        [view addSubview:deleteBtn];
        
        
    }else if (self.config.status == LEOBoxBaseCellStatusNew) {
        //没有footer
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    LEOBoxBasicCellBottomViewItemConfig *config = [self.config.itemConfigs lastObject];
    if (self.config.status == LEOBoxBaseCellStatusPreview) {
        return config.height;
    }else if (self.config.status == LEOBoxBaseCellStatusEdit) {
        return config.height;
    }else if (self.config.status == LEOBoxBaseCellStatusNew) {
        return 0;
    }
    return 0;
}

#pragma mark footer点击事件
- (void)editBtnDidClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(bottomViewEnterEditMode:)]) {
        [self.delegate bottomViewEnterEditMode:self];
    }
}

- (void)shortcutBtnDidClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(bottomViewCreateDesktopShortcut:)]) {
        [self.delegate bottomViewCreateDesktopShortcut:self];
    }
}

- (void)deleteBtnDidClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(bottomViewDeleteCell:)]) {
        [self.delegate bottomViewDeleteCell:self];
    }
}

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


- (void)dealloc
{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

@end

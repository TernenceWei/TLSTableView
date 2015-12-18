//
//  LEOPopupIconMenu.m
//  PrivacyGuard
//
//  Created by guohao on 20/11/15.
//  Copyright © 2015 LEO. All rights reserved.
//

#import "LEOPopupIconMenu.h"
#import "LEOWebInfo.h"
#import "LEODropListTableViewCell.h"
#import "DataManager.h"
#import "UITool.h"
NSString* PopupMenuCellID = @"dropListCell";

@interface LEOPopupIconMenu ()<UITableViewDataSource,UITableViewDelegate>{
    CGRect fullSizeRect;
}
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSArray* dataArray;
@property (nonatomic,strong) UIView* maskView;

@property (nonatomic,copy) void (^onSelectBlock)(LEOWebInfo* webinfo);
@end

@implementation LEOPopupIconMenu

- (instancetype)initWithSize:(CGSize)size
                       Array:(NSArray*)items{
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    fullSizeRect = self.bounds;
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.tableView registerClass:[LEODropListTableViewCell class] forCellReuseIdentifier:PopupMenuCellID];
//    self.clipsToBounds = YES;
    [self addSubview:self.tableView];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    self.layer.shadowColor = C7.CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 2.5;
    self.dataArray = [NSArray arrayWithArray:items];
    self.maskView = [[UIView alloc] initWithFrame:CGRectZero];
    self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenu)]];
    return self;
}


- (void)setSelectBlock:(void(^)(LEOWebInfo* webinfo))block{
    self.onSelectBlock = block;
}



- (UIView*)getFinalView:(UIView*)view{
    UIView* tagView = view;
    
    while (tagView.superview) {
        tagView = tagView.superview;
    }
    
    return tagView;
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LEODropListTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:PopupMenuCellID];
    
    NSInteger n = indexPath.row;
    
    LEOWebInfo* info = self.dataArray[n];
    cell.textLabel.text = [[DataManager sharedInstance] getDisplayNameFromWebinfo:info];
    UIImage* icon = [UIImage imageWithContentsOfFile:info.iconUrl];
    cell.imageView.image = icon;
    CGRect rect = cell.imageView.frame;
    rect.size = CGSizeMake(27, 27);
    cell.imageView.frame = rect;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LEOWebInfo* info = self.dataArray[indexPath.row];
    [self endEditing:YES];
    if (self.onSelectBlock) {
        self.onSelectBlock(info);
    }
    [self hideMenu];
}


- (void)showMenuInView:(UIView*)view{
    
    UIView* finalView = [self getFinalView:view];
    self.maskView.frame = finalView.bounds;
    [finalView addSubview:self.maskView];
    __block CGRect rect  = [view.superview convertRect:view.frame toView:finalView];
    [finalView addSubview:self];
    
    CGRect frame = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height+ 5,0,0);
    self.frame = frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        rect = CGRectMake(frame.origin.x, frame.origin.y, fullSizeRect.size.width, fullSizeRect.size.height);
        self.frame = rect;
    }completion:^(BOOL finished) {
        
    }];
}

- (void)hideMenu{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.frame;
        rect.size = CGSizeZero;
        self.frame = rect;
    }completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end

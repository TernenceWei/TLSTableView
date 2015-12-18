//
//  LEODropTableTextField.m
//  DropList
//
//  Created by guohao on 18/11/15.
//  Copyright © 2015 guohao. All rights reserved.
//

#import "LEODropTableTextField.h"
#import "DataManager.h"
#import "LEODropListTableViewCell.h"
#import "UITool.h"
NSString* cellID = @"dropListCell";

@interface LEODropTableTextField()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    CGRect dropTableFrame;
}
@property (nonatomic,strong) NSArray* all_dataArray;
@property (nonatomic,strong) NSArray* display_Array;

@property (nonatomic,strong) UITableView* dropTableView;
@property (nonatomic,strong) UIView* dropContainerView;
@property (nonatomic,strong) UITapGestureRecognizer* tapGesture;
@property (nonatomic,strong) UIView* maskView;
@property (nonatomic,copy) void (^onSelectBlock)(LEOWebInfo* webinfo);
@property (nonatomic, copy) void (^onTextChangeBlock)(NSString* content, BOOL finished);
@end

const CGFloat dropHeight = 220;

@implementation LEODropTableTextField

- (instancetype)initWithFrame:(CGRect)frame
                    DataArray:(NSArray*)array{
    self = [super initWithFrame:frame];
    
    self.all_dataArray = [NSArray  arrayWithArray:array];
    if (iOS7) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextFieldBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextFeildEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
    }else{
        self.delegate = self;
    }
    
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1)];
    bottomView.backgroundColor = C7;
    bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:bottomView];
    dropTableFrame = CGRectMake(0,self.bounds.size.height + 5, self.bounds.size.width, 0);
    self.dropContainerView = [[UIView alloc] initWithFrame:dropTableFrame];
  
    self.dropTableView = [[UITableView alloc] initWithFrame:self.dropContainerView.bounds];
    [self.dropTableView registerClass:[LEODropListTableViewCell class] forCellReuseIdentifier:cellID];
    self.dropTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.dropTableView.delegate = self;
    self.dropTableView.dataSource = self;
    [self.dropTableView setSeparatorColor:C7];
    [self.dropContainerView addSubview:self.dropTableView];
    self.display_Array = [NSArray arrayWithArray:self.all_dataArray];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextChange:) name:UITextFieldTextDidChangeNotification object:self];
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    self.tapGesture.delegate = self;
    self.maskView = [[UIView alloc] initWithFrame:CGRectZero];
    self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
    return self;
}



- (UIView*)getFinalSuperView:(UIView*)originView{
    UIView* view = originView;
    while (view.superview) {
        view = view.superview;
    }
    return view;
}


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    dropTableFrame = CGRectMake(0,self.bounds.size.height + 5, self.bounds.size.width, 0);
}



#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.display_Array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    LEODropListTableViewCell* cell = [self.dropTableView dequeueReusableCellWithIdentifier:cellID];
    
    NSInteger n = indexPath.row;
    
    LEOWebInfo* info = self.display_Array[n];
   
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
    LEOWebInfo* info = self.display_Array[indexPath.row];
    NSString* text = [[DataManager sharedInstance] getDisplayNameFromWebinfo:info];
    self.text = text;
    [self endEditing:YES];
    if (self.onSelectBlock) {
        self.onSelectBlock(info);
    }
}

- (void)onTap{
    [self resignFirstResponder];
    [self endEdit];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.dropTableView])
        return NO;
    
    return YES;
}

- (void)endEdit{
    [self.maskView removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect =  self.dropContainerView.frame;
        rect.size.height = 0;
        self.dropContainerView.frame = rect;
    }completion:^(BOOL finished) {
        [self.dropContainerView removeFromSuperview];
    }];

}

- (void)startEdit{
    
    [self.dropContainerView removeFromSuperview];
    UIView* finalView = [self getFinalSuperView:self];
    self.maskView.frame = finalView.bounds;
    [finalView addSubview:self.maskView];
    
    [finalView addSubview:self.dropContainerView];
    self.dropContainerView.userInteractionEnabled = YES;
    self.dropTableView.userInteractionEnabled = YES;
    CGRect rect = dropTableFrame;
    CGRect tagRect = [finalView convertRect:rect fromView:self];
    self.dropContainerView.frame = tagRect;
    
    [self resizeDropTable];
}

- (void)resizeDropTable{
    CGFloat height = 0;
    if (self.display_Array.count) {
        height = self.display_Array.count>5? dropHeight:self.display_Array.count*44;
    }else{
        height = 0;
    }
   
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.dropContainerView.frame;
        rect.size.height = height;
        self.dropContainerView.frame = rect;
        self.dropContainerView.layer.shadowColor = C7.CGColor;
        self.dropContainerView.layer.shadowOffset = CGSizeMake(0,0);
        self.dropContainerView.layer.shadowOpacity = 1;
        self.dropContainerView.layer.shadowRadius = 2.5;
    }];
}

#pragma mark - iOS 7
- (void)onTextFieldBeginEditing:(NSNotification*)notify{
    UITextField* textf = notify.object;
    [self textFieldDidBeginEditing:textf];
}

- (void)onTextFeildEndEditing:(NSNotification*)notify{
    UITextField* textf = notify.object;
    [self textFieldDidEndEditing:textf];
}

#pragma mark - textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.onTextChangeBlock) {
        self.onTextChangeBlock(textField.text, NO);
    }
    
    [self startEdit];
    
};



- (void)textFieldDidEndEditing:(UITextField *)textField{
    UIView* finalView = [self getFinalSuperView:self];
    [finalView removeGestureRecognizer: self.tapGesture];

    if (self.onTextChangeBlock) {
        self.onTextChangeBlock(textField.text, YES);
    }
    
    [self endEdit];
}

- (void)setText:(NSString *)text{
    [super setText:text];
}

- (void)onTextChange:(NSNotification*)notify{

    if (self.onTextChangeBlock) {
        self.onTextChangeBlock(self.text, NO);
    }
    UITextField* textfiled = notify.object;
    NSString* str = textfiled.text;
    if ([self isStringBlank:str]) {
        self.display_Array = [NSArray arrayWithArray:self.all_dataArray];
    }else{
        self.display_Array = [NSArray arrayWithArray:[self searchWithKey:str]];
    }
    [self resizeDropTable];
    [self.dropTableView reloadData];
}



- (NSArray*)searchWithKey:(NSString*)key{
    NSMutableArray* marray = [NSMutableArray new];
    for (LEOWebInfo* info in self.all_dataArray) {
        NSString* str = [[DataManager sharedInstance] getDisplayNameFromWebinfo:info];
        if ([[str lowercaseString] rangeOfString:[key lowercaseString]].location != NSNotFound) {
            [marray addObject:info];
        }
       
    }
    return marray;
}

#pragma mark - 
- (BOOL)isStringBlank:(NSString*)str{
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [str stringByTrimmingCharactersInSet:charSet];
    return [trimmedString isEqualToString:@""];
}

- (void)setSelectBlock:(void(^)(LEOWebInfo* webinfo))block{
    self.onSelectBlock = block;
}

- (void)setTextChangeBlock:(void (^)(NSString *, BOOL))block
{
    self.onTextChangeBlock = block;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

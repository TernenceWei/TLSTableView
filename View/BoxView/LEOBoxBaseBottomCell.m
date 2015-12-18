//
//  LEOBoxBaseBottomCell.m
//  PrivacyGuard
//
//  Created by Ternence on 15/11/17.
//  Copyright © 2015年 LEO. All rights reserved.
//

#import "LEOBoxBaseBottomCell.h"
#import "LEOBoxTextField.h"
#import "LEOBoxBaseCellHeader.h"
#import "TLSUIStandardHeader.h"
#import "UITool.h"

#define kBoxBaseBottomCellIndentifier @"kBoxBaseBottomCellIndentifier"
@interface LEOBoxBaseBottomCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *dividerLine;
@end

@implementation LEOBoxBaseBottomCell
+ (instancetype)cellWithTableView:(UITableView *)tableView tag:(NSInteger)tag
{
    LEOBoxBaseBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:kBoxBaseBottomCellIndentifier];
    if (!cell) {
        cell = [[LEOBoxBaseBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBoxBaseBottomCellIndentifier];
    }
    cell.tag = tag;
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.dividerLine.frame = CGRectMake(Cell_Preview_BottomView_Cell_Item_leftRightMargin, Cell_Preview_BottomView_Cell_H - 0.5, Cell_BottomView_Cell_W - Cell_Preview_BottomView_Cell_Item_leftRightMargin, 0.5);
        [self addSubview:self.dividerLine];

    }
    return self;
}

- (void)prepareForReuse
{
    self.titleLabel = nil;
    self.textField = nil;
}

- (UIView *)dividerLine
{
    if (!_dividerLine) {
        _dividerLine = [[UIView alloc] init];
        _dividerLine.backgroundColor = C7;
    }
    return _dividerLine;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = C8;
        _titleLabel.font = T4;
    }
    return _titleLabel;
}

- (LEOBoxTextField *)textField
{
    if (!_textField) {
        _textField = [[LEOBoxTextField alloc] init];
        _textField.font = T5;
        _textField.textColor = C10;
        _textField.delegate = self; 
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:)name:UITextFieldTextDidChangeNotification object:_textField];
    }
    return _textField;
}

- (void)setStatus:(LEOBoxBaseCellStatus)status
{
    _status = status;
    switch (_status) {
        case LEOBoxBaseCellStatusPreview:{
            self.textField.editEnabled = NO;
            break;
        }
        case LEOBoxBaseCellStatusEdit:{
            self.textField.editEnabled = YES;
            break;
        }
        case LEOBoxBaseCellStatusNew:{
            self.textField.editEnabled = YES;
            break;
        }
        default:
            break;
    }
    
}

- (void)setConfig:(LEOBoxBasicCellBottomViewItemConfig *)config
{
    _config = config;
    [self setupTitleAndSubTitle];
    [self addTargetWithAction:@selector(beginToEdit)];
    switch (_config.itemType) {
        case LEOBoxCellItemTypeWebsite:{

            self.textField.keyboardType = UIKeyboardTypeURL;

            break;
        }
            /**银行卡*/
        case LEOBoxCellItemTypeBankCardNumber:{
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        }
        case LEOBoxCellItemTypeBankVVC:{
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            
            break;
        }
            /**会员卡*/
        case LEOBoxCellItemTypePhoneNumber:{
            if (self.status == LEOBoxBaseCellStatusPreview) {
                self.textField.textColor = C1;
            }
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            if (self.status == LEOBoxBaseCellStatusPreview) {
                [self addTargetWithAction:@selector(giveACall)];
            }
            
            break;
        }
        case LEOBoxCellItemTypeComment:{
           
            if (self.status == LEOBoxBaseCellStatusNew && self.config.VCType == LEOBoxVCTypeBank) {
                self.dividerLine.hidden = YES;
            }else{
                self.dividerLine.hidden = NO;
            }
            break;
        }
        default:
            break;
        
    }
    
}

- (void)addTargetWithAction:(SEL)action
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    [self addGestureRecognizer:tapGesture];
    
}

- (void)beginToEdit
{
    [self.textField becomeFirstResponder];
}

#pragma mark textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.config.dataBlock) {
        self.config.dataBlock(self.textField.text);
    }

    if (self.config.keboardBlock) {
        self.config.keboardBlock(self.frame);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.config.dataBlock) {
        self.config.dataBlock(self.textField.text);
    }

}

- (void)textFieldTextDidChange:(NSNotification *)noti
{
    if (self.config.dataBlock) {
        self.config.dataBlock(self.textField.text);
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}

- (void)setupTitle
{
    self.titleLabel.text = self.config.content;
    self.titleLabel.textColor = C1;
    [self addSubview:self.titleLabel];
    
    CGSize titleSize = [UITool sizeWithString:self.titleLabel.text font:self.titleLabel.font];
    self.titleLabel.frame = CGRectMake(Cell_Preview_BottomView_Cell_Item_leftRightMargin, (Cell_Preview_BottomView_Cell_H - titleSize.height) / 2, Cell_BottomView_Cell_W, titleSize.height);
}

- (void)setupTitleAndSubTitle
{
    self.titleLabel.text = _config.title;
    self.textField.placeholder = _config.placeHolder;
    CGSize subTitleSize;
    if (_status == LEOBoxBaseCellStatusPreview || _status == LEOBoxBaseCellStatusEdit) {
        if (_config.content) {
            self.textField.text = _config.content;
            subTitleSize = [UITool sizeWithString:self.textField.text font:self.textField.font];
        }else{
            self.textField.placeholder = _config.placeHolder;
            subTitleSize = [UITool sizeWithString:self.textField.placeholder font:self.textField.font];
        }
    }else if (_status == LEOBoxBaseCellStatusNew) {
        self.textField.text = _config.content;
        self.textField.placeholder = _config.placeHolder;
        subTitleSize = [UITool sizeWithString:self.textField.placeholder font:self.textField.font];
    }
    CGSize titleSize = [UITool sizeWithString:self.titleLabel.text font:self.titleLabel.font];
    CGFloat beginY = (Cell_Preview_BottomView_Cell_H - titleSize.height - subTitleSize.height - Cell_Preview_BottomView_Cell_Item_Title_SubTitle_Margin) / 2;
    self.titleLabel.frame = CGRectMake(Cell_Preview_BottomView_Cell_Item_leftRightMargin, beginY, titleSize.width, titleSize.height);
    self.textField.frame = CGRectMake(Cell_Preview_BottomView_Cell_Item_leftRightMargin, CGRectGetMaxY(self.titleLabel.frame) + Cell_Preview_BottomView_Cell_Item_Title_SubTitle_Margin, Cell_BottomView_Cell_W - Cell_Preview_BottomView_Cell_Item_leftRightMargin * 2, subTitleSize.height);
    [self addSubview:self.titleLabel];
    [self addSubview:self.textField];
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

@end

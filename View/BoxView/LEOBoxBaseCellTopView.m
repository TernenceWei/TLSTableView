 //
//  LEOBoxBaseCellTopView.m
//  PrivacyGuard
//
//  Created by Ternence on 15/11/12.
//  Copyright © 2015年 LEO. All rights reserved.
//

#import "LEOBoxBaseCellTopView.h"
#import "LEOBoxBaseCellHeader.h"
#import "UITool.h"
#import "LEOBoxTextField.h"
#import "LEODropTableTextField.h"
#import "DataManager.h"
#import "LEOBoxBasicCellConfigHeader.h"
#import "LEOPopupIconMenu.h"

@interface LEOBoxBaseCellTopView ()
@property (nonatomic, strong) UIImageView *shawdowView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *starView1;
@property (nonatomic, strong) UIImageView *starView2;
@property (nonatomic, strong) UIImageView *starView3;
@property (nonatomic, strong) UIImageView *bankRemindIcon;
@property (nonatomic, strong) UILabel *bankRemindLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) LEODropTableTextField *dropTitleField;
@property (nonatomic, strong) UIButton *arrowBtn;

@property (nonatomic, assign) BOOL arrowDown;
@property (nonatomic, strong) NSString *defaultTitle;
@property (nonatomic, strong) NSString *defaultIconName;
@end

@implementation LEOBoxBaseCellTopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.shadowColor = HHColor(0xd0, 0xd8, 0xea).CGColor;
        self.layer.shadowOpacity = 0.36;
        self.layer.shadowOffset = CGSizeMake(4, 4);
        self.layer.shadowRadius = 4;

    }
    return self;
}

- (UIImageView *)shawdowView
{
    if (!_shawdowView) {
        _shawdowView = [[UIImageView alloc] init];
        _shawdowView.image = [UIImage imageNamed:@"box_cell_showdowImage"];
    }
    return _shawdowView;
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageWithContentsOfFile:_config.iconName];
        [_iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddIcon)]];
        _iconView.layer.cornerRadius = 4;
        _iconView.clipsToBounds = YES;
        _iconView.userInteractionEnabled = YES;
    }
    return _iconView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"QQ";
        _titleLabel.textColor = C4;
        _titleLabel.font = T2;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.text = @"6948438";
        _subtitleLabel.textColor = C3;
        _subtitleLabel.font = T4;
    }
    return _subtitleLabel;
}

- (UILabel *)bankRemindLabel
{
    if (!_bankRemindLabel) {
        _bankRemindLabel = [[UILabel alloc] init];
        _bankRemindLabel.text = @"6948438";
    }
    return _bankRemindLabel;
}

- (LEODropTableTextField*)dropTitleField{
    if (_dropTitleField == nil) {
        InfoType type = infoType_loginInfo;
        
        if (self.config.VCType == LEOBoxVCTypeMember) {
            type = infoType_membCard;
        }else if (self.config.VCType == LEOBoxVCTypeBank){
            type = infoType_bankCard;
        }
        _dropTitleField = [[LEODropTableTextField alloc] initWithFrame:CGRectZero DataArray:[[DataManager sharedInstance] getDefualtIconArrayWithType:type]];
        _dropTitleField.placeholder = @"login name";
        _dropTitleField.textColor = C4;
        _dropTitleField.font = T2;
    }
    return _dropTitleField;
}

- (UIImageView *)starView1
{
    if (!_starView1) {
        _starView1 = [[UIImageView alloc] init];
        _starView1.image = [UIImage imageNamed:@"star_white"];
        
    }
    return _starView1;
}

- (UIImageView *)starView2
{
    if (!_starView2) {
        _starView2 = [[UIImageView alloc] init];
        _starView2.image = [UIImage imageNamed:@"star_white"];
        
    }
    return _starView2;
}

- (UIImageView *)starView3
{
    if (!_starView3) {
        _starView3 = [[UIImageView alloc] init];
        _starView3.image = [UIImage imageNamed:@"star_white"];
       
    }
    return _starView3;
}

- (UIImageView *)bankRemindIcon
{
    if (!_bankRemindIcon) {
        _bankRemindIcon = [[UIImageView alloc] init];
        _bankRemindIcon.image = [UIImage imageNamed:@"box_bank_remindTime_clock"];
        
    }
    return _bankRemindIcon;
}

- (UIButton *)arrowBtn
{
    if (!_arrowBtn) {
        _arrowBtn = [[UIButton alloc] init];
        [_arrowBtn setImage:[UIImage imageNamed:@"box_cell_down_normal"] forState:UIControlStateNormal];
        [_arrowBtn setImage:[UIImage imageNamed:@"box_cell_down_press"] forState:UIControlStateHighlighted];
        [_arrowBtn addTarget:self action:@selector(arrowBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _arrowDown = YES;
        
    }
    return _arrowBtn;
}

- (void)refreshEditObject:(LEOSecurityBoxDataBaseObject *)object
{
    self.dropTitleField.text = object.title;

    if (![self isBlankString:object.icon_url]) {
        self.iconView.image = [UIImage imageWithContentsOfFile:object.icon_url];
    }else{
        if (self.config.status == LEOBoxBaseCellStatusNew || self.config.status == LEOBoxBaseCellStatusEdit) {
            self.iconView.image = [UIImage imageNamed:@"box_icon_add"];
        }else{
            self.iconView.image = [UIImage imageNamed:self.defaultIconName];
        }
        
    }
    
}

- (void)arrowBtnEnabled:(BOOL)enabled
{
    self.arrowBtn.enabled = enabled;
}

- (void)arrowBtnDidClicked:(UIButton *)arrowBtn
{
    self.arrowDown = !self.arrowDown;
    if ([self.delegate respondsToSelector:@selector(topView:open:)]) {
        [self.delegate topView:self open:!self.arrowDown];
    }
    
}

- (void)setArrowDown:(BOOL)arrowDown
{
    _arrowDown = arrowDown;
    if (_arrowDown) {
        [self.arrowBtn setImage:[UIImage imageNamed:@"box_cell_down_normal"] forState:UIControlStateNormal];
        [self.arrowBtn setImage:[UIImage imageNamed:@"box_cell_down_press"] forState:UIControlStateHighlighted];
    }else{
        [self.arrowBtn setImage:[UIImage imageNamed:@"box_cell_up_normal"] forState:UIControlStateNormal];
        [self.arrowBtn setImage:[UIImage imageNamed:@"box_cell_up_press"] forState:UIControlStateHighlighted];
    }
}

- (void)setConfig:(LEOBoxBasicCellTopViewConfig *)config
{
    _config = config;

    switch (_config.VCType) {
        case LEOBoxVCTypeAccount:
            _defaultTitle = NSLocalizedString(@"Name", nil);
            _defaultIconName = @"box_account_icon_default";
            break;
        case LEOBoxVCTypeMember:
            _defaultTitle = NSLocalizedString(@"Merchant Name", nil);
            _defaultIconName = @"box_member_icon_default";
            break;
        case LEOBoxVCTypeBank:
            _defaultTitle = NSLocalizedString(@"Issuing Bank", nil);
            _defaultIconName = @"box_bank_icon_default";
            break;
    }
    __weak __typeof(self)weakSelf = self;
    switch (_config.status) {
        case LEOBoxBaseCellStatusNormal:{
            
            [self addSubview:self.iconView];
            [self addSubview:self.titleLabel];
            [self addSubview:self.subtitleLabel];
            if (![self isBlankString:_config.iconName]) {
                self.iconView.image = [UIImage imageWithContentsOfFile:_config.iconName];
            }else{
                self.iconView.image = [UIImage imageNamed:self.defaultIconName];
            }
            
            if ([self isBlankString:_config.title]) {
                self.titleLabel.text = _config.placeHolder;
            }else{
                self.titleLabel.text = _config.title;
            }
            self.subtitleLabel.text = _config.subTitle;
            [self addSubview:self.arrowBtn];
            self.arrowDown = YES;

            if (_config.VCType == LEOBoxVCTypeBank) {
                if ( _config.subTitle.length > 4) {
                    [self addSubview:self.starView1];
                    [self addSubview:self.starView2];
                    [self addSubview:self.starView3];
                    self.subtitleLabel.text = [_config.subTitle substringFromIndex:(_config.subTitle.length - 4)];
                }
            }

            break;
        }
        case LEOBoxBaseCellStatusNew:{
            [self addSubview:self.iconView];
            [self addSubview:self.dropTitleField];
            [self setupRespondRegion];
            self.iconView.image = [UIImage imageNamed:_config.iconName];
            
            self.dropTitleField.text = _config.title;
            self.dropTitleField.placeholder = _config.placeHolder;
            
            [_dropTitleField setSelectBlock:^(LEOWebInfo *webinfo) {
                if (weakSelf.config.titleBlock) {
                    weakSelf.config.titleBlock(webinfo);
                }
            }];
            [_dropTitleField setTextChangeBlock:^(NSString *content, BOOL finished) {
                if (weakSelf.config.textChangeBlock) {
                    weakSelf.config.textChangeBlock(content,finished);
                }
            }];
            break;
        }
        case LEOBoxBaseCellStatusEdit:{

            [self addSubview:self.iconView];
            [self addSubview:self.dropTitleField];
            [self setupRespondRegion];
            if ([self isBlankString:_config.iconName]) {
                self.iconView.image = [UIImage imageNamed:@"box_icon_add"];
            }else{
               self.iconView.image = [UIImage imageWithContentsOfFile:_config.iconName];
            }
            
            self.dropTitleField.text = _config.title;
            self.dropTitleField.placeholder = _config.placeHolder;
            
            [_dropTitleField setSelectBlock:^(LEOWebInfo *webinfo) {
                if (weakSelf.config.titleBlock) {
                    weakSelf.config.titleBlock(webinfo);
                }
            }];
            [_dropTitleField setTextChangeBlock:^(NSString *content, BOOL finished) {
                if (weakSelf.config.textChangeBlock) {
                    weakSelf.config.textChangeBlock(content, finished);
                }
            }];
            break;
        }
        case LEOBoxBaseCellStatusPreview:{

            [self addSubview:self.iconView];
            [self addSubview:self.titleLabel];
            [self addSubview:self.subtitleLabel];
            if (![self isBlankString:_config.iconName]) {
                self.iconView.image = [UIImage imageWithContentsOfFile:_config.iconName];
            }else{
                self.iconView.image = [UIImage imageNamed:self.defaultIconName];
            }
            if ([self isBlankString:_config.title]) {
                self.titleLabel.text = _config.placeHolder;
            }else{
                self.titleLabel.text = _config.title;
            }
            self.subtitleLabel.text = _config.subTitle;
            [self addSubview:self.arrowBtn];
            self.arrowDown = NO;
            if (_config.VCType == LEOBoxVCTypeBank) {
                if ( _config.subTitle.length > 4) {
                    [self addSubview:self.starView1];
                    [self addSubview:self.starView2];
                    [self addSubview:self.starView3];
                    self.subtitleLabel.text = [_config.subTitle substringFromIndex:(_config.subTitle.length - 4)];
                }
            }
            break;
        }
    }
    if (_config.status != LEOBoxBaseCellStatusNormal) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = C8;
        line.frame = CGRectMake(0, 0, self.bounds.size.width, 2);
        [self addSubview:line];
    }
    [self setNeedsLayout];
}

/**
 *  增加响应区域
 */
- (void)setupRespondRegion
{
    UIView *regionView = [[UIView alloc] init];
    CGFloat beginX = Cell_Normal_TopView_Icon_LeftMargin * 2 + Cell_Normal_TopView_Icon_WH;
    regionView.frame = CGRectMake(beginX, 0, Cell_BottomView_Cell_W - beginX, Cell_Normal_TopView_H);
    regionView.backgroundColor = [UIColor clearColor];
    [self addSubview:regionView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginToEdit)];
    [regionView addGestureRecognizer:tapGesture];
}

- (void)beginToEdit
{
    [self.dropTitleField becomeFirstResponder];
}

- (NSAttributedString *)getBankRemindDayText
{

    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = C9;
    attrs[NSFontAttributeName] = T5;
    NSAttributedString *string1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld ",self.config.remindCount] attributes:attrs];
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithAttributedString:string1];
    
    NSMutableDictionary *attrs2 = [NSMutableDictionary dictionary];
    attrs2[NSForegroundColorAttributeName] = C8;
    attrs2[NSFontAttributeName] = T5;
    NSAttributedString *string2 = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Day(s)", nil) attributes:attrs2];
    [mutableString  appendAttributedString:string2];
    return mutableString;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.config.status == LEOBoxBaseCellStatusNew || self.config.status == LEOBoxBaseCellStatusEdit){
        
        self.iconView.frame = CGRectMake(Cell_Normal_TopView_Icon_LeftMargin, (Cell_Normal_TopView_H - Cell_Normal_TopView_Icon_WH) / 2, Cell_Normal_TopView_Icon_WH, Cell_Normal_TopView_Icon_WH);
        CGFloat beginY = (Cell_Normal_TopView_H - Cell_New_TopView_TitleField_H - Cell_New_TopView_Line_Title_Margin - 1) / 2;
        self.dropTitleField.frame = CGRectMake(CGRectGetMaxX(self.iconView.frame) + Cell_Normal_TopView_Title_Icon_Margin, beginY, Cell_BottomView_Cell_W - CGRectGetMaxX(self.iconView.frame) - Cell_Normal_TopView_Title_Icon_Margin, Cell_New_TopView_TitleField_H);
        
    }else if (self.config.status == LEOBoxBaseCellStatusNormal || self.config.status == LEOBoxBaseCellStatusPreview){
        
        self.iconView.frame = CGRectMake(Cell_Normal_TopView_Icon_LeftMargin, (Cell_Normal_TopView_H - Cell_Normal_TopView_Icon_WH) / 2, Cell_Normal_TopView_Icon_WH, Cell_Normal_TopView_Icon_WH);
        CGSize titleSize = [UITool sizeWithString:self.titleLabel.text font:self.titleLabel.font];
        CGSize subTitleSize = [UITool sizeWithString:self.subtitleLabel.text font:self.subtitleLabel.font];
        CGFloat beginY = (Cell_Normal_TopView_H - titleSize.height - subTitleSize.height - Cell_Normal_TopView_SubTitle_Title_Margin) / 2;
        
        self.arrowBtn.frame = CGRectMake(Cell_BottomView_Cell_W - Cell_Normal_TopView_Arrow_RightMargin - Cell_Normal_TopView_Arrow_WH, (Cell_Normal_TopView_H - Cell_Normal_TopView_Arrow_WH) / 2, Cell_Normal_TopView_Arrow_WH, Cell_Normal_TopView_Arrow_WH);
        CGFloat beginX = CGRectGetMaxX(self.iconView.frame) + Cell_Normal_TopView_Title_Icon_Margin;
        CGFloat maxW = CGRectGetMinX(self.arrowBtn.frame) - beginX;
        self.titleLabel.frame = CGRectMake(beginX, beginY, maxW, titleSize.height);
        self.subtitleLabel.frame = CGRectMake(beginX, CGRectGetMaxY(self.titleLabel.frame) + Cell_Normal_TopView_SubTitle_Title_Margin, maxW, subTitleSize.height);
        
        if (self.config.VCType == LEOBoxVCTypeBank) {

            if ( _config.subTitle.length > 4) {
                CGSize size = [UITool sizeWithString:_subtitleLabel.text font:_subtitleLabel.font];
                self.starView1.frame = CGRectMake(CGRectGetMaxX(self.iconView.frame) + Cell_Normal_TopView_Title_Icon_Margin, CGRectGetMaxY(self.titleLabel.frame) + Cell_Normal_TopView_SubTitle_Title_Margin, Cell_TopView_StarW, size.height);
                self.starView2.frame = CGRectMake(CGRectGetMaxX(self.starView1.frame) + Cell_TopView_StarMargin, CGRectGetMaxY(self.titleLabel.frame) + Cell_Normal_TopView_SubTitle_Title_Margin, Cell_TopView_StarW, size.height);
                self.starView3.frame = CGRectMake(CGRectGetMaxX(self.starView2.frame) + Cell_TopView_StarMargin, CGRectGetMaxY(self.titleLabel.frame) + Cell_Normal_TopView_SubTitle_Title_Margin, Cell_TopView_StarW, size.height);
                self.subtitleLabel.frame = CGRectMake(CGRectGetMaxX(self.starView3.frame) + Cell_TopView_StarMargin, CGRectGetMaxY(self.titleLabel.frame) + Cell_Normal_TopView_SubTitle_Title_Margin, size.width, size.height);
            }
        }
    }
}

- (void)onAddIcon{
    if (self.config.status == LEOBoxBaseCellStatusNormal || self.config.status == LEOBoxBaseCellStatusPreview) {
        return;
    }
    
    NSArray* array ;
    InfoType type = infoType_default;
    if (self.config.VCType == LEOBoxVCTypeAccount) {
        type = infoType_loginInfo;
    }else if (self.config.VCType == LEOBoxVCTypeMember) {
        type = infoType_membCard;
    }else if (self.config.VCType == LEOBoxVCTypeBank) {
        type = infoType_bankCard;
    }
    array = [[DataManager sharedInstance] getDefualtIconArrayWithType:type];
    LEOPopupIconMenu* menu = [[LEOPopupIconMenu alloc] initWithSize:CGSizeMake(217, 220) Array:array];
    [menu showMenuInView:self.iconView];
    [menu setSelectBlock:^(LEOWebInfo *webinfo) {
        self.iconView.image = [UIImage imageWithContentsOfFile:webinfo.iconUrl];
    
        if (self.config.iconBlock) {
            self.config.iconBlock(webinfo);
        };
    }];
}

- (void)titleStartEdit
{
    //等待bottomview的动画执行完后开始处于编辑状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.dropTitleField becomeFirstResponder];
    });
    
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
    
}
@end

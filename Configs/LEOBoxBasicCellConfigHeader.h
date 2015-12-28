//
//  LEOBoxBasicCellConfigHeader.h
//  PrivacyGuard
//
//  Created by Ternence on 15/11/17.
//  Copyright © 2015年 LEO. All rights reserved.
//

#ifndef LEOBoxBasicCellConfigHeader_h
#define LEOBoxBasicCellConfigHeader_h

typedef NS_ENUM(NSUInteger, LEOBoxBaseCellStatus) {
    LEOBoxBaseCellStatusNormal,
    LEOBoxBaseCellStatusPreview,
    LEOBoxBaseCellStatusEdit,
    LEOBoxBaseCellStatusNew,
};

typedef NS_ENUM(NSUInteger, LEOBoxVCType) {
    LEOBoxVCTypeAccount,
    LEOBoxVCTypeMember,
    LEOBoxVCTypeBank,
};

#define KBoxWaveAnimationBeginNotification @"KBoxWaveAnimationBeginNotification"
#define KBoxWaveAnimationEndNotification @"KBoxWaveAnimationEndNotification"

#define KDefaultTag 100
#define shadowSpace ConvertByHeight(8)

#endif /* LEOBoxBasicCellConfigHeader_h */

//
//  TLSUIStandardHeader.h
//  TLSTableView
//
//  Created by Ternence on 15/12/18.
//  Copyright © 2015年 Leomaster. All rights reserved.
//

#ifndef TLSUIStandardHeader_h
#define TLSUIStandardHeader_h

#ifdef DEBUG
#define HHLog(...) NSLog(__VA_ARGS__)
#else
#define HHLog(...)
#endif

#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
#define HHColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define CHECK_NULL(object)  ([object isKindOfClass:[NSNull class]] ? @"" : object)

#define iOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define belowIOS8 ([[UIDevice currentDevice].systemVersion doubleValue] < 8.0)
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 8.0)

#define C1  HHColor(0x5b,0x74,0xcd)
#define C2  HHColor(0xb5,0xc1,0xd9)
#define C3  HHColor(0xbb,0xbb,0xbb)
#define C4  HHColor(0x1f,0x23,0x3c)
#define C5  HHColor(0xf2,0xf6,0xf8)
#define C6  HHColor(0xfa,0xfb,0xfc)
#define C7  HHColor(0xd0,0xd8,0xea)
#define C8  HHColor(0x7e,0x96,0xdf)
#define C9  HHColor(0xdf,0x7e,0x93)
#define C10  HHColor(0x3f,0x43,0x58)
#define C11  HHColor(0xff,0xff,0xff)
#define C12  HHColor(0x70,0xcd,0x5b)
#define C13  HHColor(0xf0,0xce,0x7b)
#define C14  HHColor(0xd0,0xd8,0xea)
#define C15  HHColor(0x5b,0x75,0xce)
#define C16  HHColor(0xf8,0xf8,0xf8)

#define C100  HHColor(0xc3,0xcf,0xf9)

#define T1 [UIFont systemFontOfSize:17.0]
#define T2 [UIFont systemFontOfSize:15.0]
#define T3 [UIFont systemFontOfSize:14.0]
#define T4 [UIFont systemFontOfSize:13.0]
#define T5 [UIFont systemFontOfSize:12.0]
#define T6 [UIFont systemFontOfSize:11.0]

#endif /* TLSUIStandardHeader_h */

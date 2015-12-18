//
//  LEOBoxBaseCellHeader.h
//  PrivacyGuard
//
//  Created by Ternence on 15/11/12.
//  Copyright © 2015年 LEO. All rights reserved.
//

#ifndef LEOBoxBaseCellHeader_h
#define LEOBoxBaseCellHeader_h

#define BASE_HEIGTH 568.0f
#define BASE_WIDTH 320.0f
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
#define ConvertByWidth(length) (length*SCREEN_WIDTH/BASE_WIDTH)
#define ConvertByHeight(length) (length*SCREEN_HEIGHT/BASE_HEIGTH)

#define Cell_TopView_StarW ConvertByWidth(30)
#define Cell_TopView_StarMargin ConvertByWidth(5)

#define Cell_BottomView_Cell_W (SCREEN_WIDTH - (ConvertByWidth(12) * 2))
#define Cell_Cell_Margin ConvertByHeight(2)
#define Cell_TopView_BottomView_Margin ConvertByHeight(1)
#define Cell_Normal_LeftRightMargin ConvertByWidth(12)
#define Cell_Normal_TopView_H ConvertByHeight(70)
#define Cell_Normal_TopView_Icon_LeftMargin ConvertByWidth(12)
#define Cell_Normal_TopView_Icon_WH ConvertByWidth(40)
#define Cell_Normal_TopView_Title_Icon_Margin ConvertByWidth(15)
#define Cell_Normal_TopView_SubTitle_Title_Margin ConvertByHeight(5)
#define Cell_Normal_TopView_Arrow_RightMargin ConvertByWidth(0)
#define Cell_Normal_TopView_Arrow_WH ConvertByWidth(60)
#define Cell_Normal_TopView_Bank_Icon_TopMargin ConvertByHeight(5)
#define Cell_Normal_TopView_Bank_Icon_WH ConvertByWidth(12)
#define Cell_Normal_TopView_Bank_Date_Right_Margin ConvertByWidth(12)
#define Cell_Normal_TopView_Bank_Date_Icon_Margin ConvertByWidth(3)

#define Cell_New_TopView_Line_Title_Margin ConvertByHeight(5)
#define Cell_New_TopView_TitleField_H ConvertByHeight(30)
#define Cell_New_TopView_TitleRegion_Line_Margin ConvertByHeight(5)
#define Cell_New_TopView_TitleRegion_W ConvertByWidth(217)
#define Cell_New_TopView_TitleRegion_H ConvertByHeight(219)
#define Cell_New_TopView_TitleRegion_Cell_H ConvertByHeight(48)
#define Cell_New_TopView_TitleRegion_Cell_Icon_leftMargin ConvertByWidth(10)
#define Cell_New_TopView_TitleRegion_Cell_Icon_WH ConvertByWidth(28)
#define Cell_New_TopView_TitleRegion_Cell_Title_Icon_Margin ConvertByWidth(10)
#define Cell_New_TopView_IconRegion_Top_Margin ConvertByHeight(5)

#define Cell_Preview_BottomView_Cell_H ConvertByHeight(48)
#define Cell_Preview_BottomView_Cell_Item_leftRightMargin ConvertByWidth(15)
#define Cell_Preview_BottomView_Cell_Item_Title_SubTitle_Margin ConvertByHeight(4)
#define Cell_Preview_BottomView_Cell_BottomBtn_WH ConvertByWidth(18)
#define Cell_Preview_BottomView_Cell_Indicator_Bg_W ConvertByWidth(70)
#define Cell_Preview_BottomView_Cell_Indicator_Bg_H ConvertByHeight(36)

#define Cell_Preview_BottomView_Cell_BarCode_CellH ConvertByHeight(90)
#define Cell_Preview_BottomView_Cell_BarCode_W ConvertByWidth(270)
#define Cell_Preview_BottomView_Cell_BarCode_H ConvertByHeight(70)

#define Cell_Preview_BottomView_Cell_QRCode_CellH ConvertByHeight(70)
#define Cell_Preview_BottomView_Cell_QRCode_WH ConvertByWidth(62)

#define Cell_Edit_BottomView_Cell_Progress_LeftRightMargin ConvertByWidth(5)
#endif /* LEOBoxBaseCellHeader_h */

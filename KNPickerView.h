//
//  KNPickerView.h
//  Kidnapper
//
//  Created by test on 15-7-8.
//  Copyright (c) 2015年 Fujian Ruijie Networks Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ROW_NUMBER 5

@interface KNPickerView : UIScrollView

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *lineDescription;

@end

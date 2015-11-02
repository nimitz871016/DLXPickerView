//
//  KNTableViewCell.h
//  Kidnapper
//
//  Created by test on 15-7-16.
//  Copyright (c) 2015年 Fujian Ruijie Networks Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AUIAnimatableLabel.h"

@interface KNTableViewCell : UITableViewCell

@property (nonatomic, strong) AUIAnimatableLabel     *label;
@property (nonatomic, strong) UIImageView *icon;

@end

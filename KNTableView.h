//
//  KNTableView.h
//  Kidnapper
//
//  Created by test on 15-7-16.
//  Copyright (c) 2015年 Fujian Ruijie Networks Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KNTableViewDelegate <NSObject>

- (void) didSelectAtIndex: (NSIndexPath *)indexPath;

@end

@interface KNTableView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) id<KNTableViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style data:(NSArray *)data;

@end


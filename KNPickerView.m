//
//  KNPickerView.m
//  Kidnapper
//
//  Created by test on 15-7-8.
//  Copyright (c) 2015年 Fujian Ruijie Networks Co., Ltd. All rights reserved.
//

#import "KNPickerView.h"

@interface KNPickerView ()

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIScrollView *slaveScrollView;
@property (nonatomic, assign) NSUInteger     rows;
@property (nonatomic, assign) NSUInteger     lines;
@property (nonatomic, assign) CGFloat        rowHeight;
@property (nonatomic, assign) CGFloat        lineWidth;

@end

@implementation KNPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _rows = ROW_NUMBER;
        _rowHeight = frame.size.height / _rows;
        _lines = [_data count];
        _lineWidth = frame.size.width / _lines;
        _slaveScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 2 * _rowHeight, _rowHeight, frame.size.height)];
        [_slaveScrollView setUserInteractionEnabled:NO];
        [_mainScrollView setUserInteractionEnabled:NO];
        for (int i = 0 ; i < [_data count] ; i++) {
            for (NSString *string in [_data objectAtIndex:i]) {
                UILabel *label = [[UILabel alloc]init];
                [label setText:string];
                [label sizeToFit];
                [label setTextAlignment:NSTextAlignmentCenter];
                [_mainScrollView addSubview:[label copy]];
                [_slaveScrollView addSubview:[label copy]];
            }
        }
//        [_slaveScrollView setContentSize:frame.size];
//        [_mainScrollView setContentSize:CGSizeMake(frame.size.width, _rowHeight)];
        [_mainScrollView setPagingEnabled:YES];
        [_slaveScrollView setPagingEnabled:YES];
        [self addSubview:_slaveScrollView];
        [self addSubview:_mainScrollView];
//        _mainScrollView
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *) data lineDescription:(NSArray *)lineDescription{
    _data = data;
    _lineDescription = lineDescription;
    if ([_data count] != [_lineDescription count]) {
        NSLog(@"数据输入错误");
        return nil;
    }else{
        return [self initWithFrame:frame];
    }
}


@end

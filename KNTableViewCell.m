//
//  KNTableViewCell.m
//  Kidnapper
//
//  Created by test on 15-7-16.
//  Copyright (c) 2015年 Fujian Ruijie Networks Co., Ltd. All rights reserved.
//

#import "KNTableViewCell.h"

@implementation KNTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label = [[AUIAnimatableLabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
//        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_label];
    }
    return self;
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
//    CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGFloat height = self.frame.size.height;
    
    _label.center = CGPointMake(self.bounds.size.width / 2 , height / 2 );
//    _label.center = self.center;
}

@end

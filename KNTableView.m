//
//  KNTableView.m
//  Kidnapper
//
//  Created by test on 15-7-16.
//  Copyright (c) 2015年 Fujian Ruijie Networks Co., Ltd. All rights reserved.
//

#import "KNTableView.h"
#import "KNTableViewCell.h"
#import "UIColor+parseColor.h"
#import "AUIAnimatableLabel.h"
#import "UIFont+CoreTextExtensions.h"

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)


@interface KNTableView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *currentIndex;

@end

@implementation KNTableView

- (UITableView *)tableViewInitWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
    if (tableView) {
        tableView.delegate = self;
        tableView.dataSource = self;
//        self.allowsSelection = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorColor = [UIColor clearColor];
        tableView.bounces = NO;
        tableView.allowsSelection = NO;

        //添加中间的两条1px分隔线
        
        CGFloat posY1 = frame.size.height / 5 * 2 ;
        CGFloat posY2 = frame.size.height / 5 * 3 ;
        
        UIView *seper1 = [[UIView alloc]initWithFrame:CGRectMake(0, posY1 - SINGLE_LINE_ADJUST_OFFSET, frame.size.width, SINGLE_LINE_WIDTH)];
        UIView *seper2 = [[UIView alloc]initWithFrame:CGRectMake(0, posY2 - SINGLE_LINE_ADJUST_OFFSET, frame.size.width, SINGLE_LINE_WIDTH)];
        
        [seper1 setBackgroundColor:[UIColor hexColor:@"#cccccc"]];
        [seper2 setBackgroundColor:[UIColor hexColor:@"#cccccc"]];
        [self addSubview:seper1];
        [self addSubview:seper2];
    }
    return tableView;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style data:(NSArray *)data{
    self = [super initWithFrame:frame];
    _tableView = [self tableViewInitWithFrame:frame style:style];
    
    if (self) {
        NSMutableArray *tempData = [[NSMutableArray alloc]initWithArray:data];
        [tempData insertObject:@"" atIndex:0];
        [tempData insertObject:@"" atIndex:1];
        [tempData addObject:@""];
        [tempData addObject:@""];
        _data = [tempData copy];
        [self addSubview:_tableView];
        [self sendSubviewToBack:_tableView];
    }
    return self;
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"kntableviewcell";
    KNTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[KNTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    [cell.label setText:[_data objectAtIndex:indexPath.row]];
    [cell.label setFont:[UIFont systemFontOfSize:17]];
    [cell.label setVerticalTextAlignment:AUITextVerticalAlignmentCenter];
    [cell sizeToFit];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return tableView.bounds.size.height / 3;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.bounds.size.height / 5;
    
//    return 44;
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    CGFloat pageSize = self.bounds.size.height / 5;
    NSInteger page = roundf(offset.y / pageSize);
    CGFloat targetY = pageSize * page;
    return CGPointMake(offset.x, targetY);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray *visibleIndex = [_tableView indexPathsForVisibleRows];
    NSArray *visibleIndexSorted = [visibleIndex sortedArrayUsingComparator:^NSComparisonResult(id a, id b){
        CGRect r1 = [_tableView rectForRowAtIndexPath:(NSIndexPath *)a];
        CGRect r2 = [_tableView rectForRowAtIndexPath:(NSIndexPath *)b];
        CGFloat y1 = fabsf(r1.origin.y + r1.size.height/2 - _tableView.contentOffset.y - _tableView.center.y);
        CGFloat y2 = fabsf(r2.origin.y + r2.size.height/2 - _tableView.contentOffset.y - _tableView.center.y);
        if (y1 > y2) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];

    NSArray *middleIndex = @[[visibleIndexSorted objectAtIndex:0]];
    
    if ([self.currentIndex isEqualToArray: middleIndex]){
        return;
    }
    
    NSArray *firstLayerIndex = @[[visibleIndexSorted objectAtIndex:1] , [visibleIndexSorted objectAtIndex:2]];
    NSArray *secondLayerIndex = @[[visibleIndexSorted objectAtIndex:3] , [visibleIndexSorted objectAtIndex:4]];
    
    [self hightlightMiddleCell:middleIndex];
    [self hightlightFirstCell:firstLayerIndex];
    [self hightlightSecondCell:secondLayerIndex];
    
    
    self.currentIndex = middleIndex;
    [_delegate didSelectAtIndex:[self.currentIndex objectAtIndex:0]];
}

#pragma mark - change cell.label color

- (void) hightlightMiddleCell:(NSArray *)indexs{
    KNTableViewCell *cell = (KNTableViewCell *)[_tableView cellForRowAtIndexPath:[indexs objectAtIndex:0]];
//    [UIView animateWithDuration:3.0f animations:^{
//        [cell.label setTextColor:[UIColor hexColor:@"#00b856"]];
////        [cell.label setTextColor:[UIColor hexColor:@"#00b856"]];
//        [cell.label setFont:[UIFont systemFontOfSize:30]];
//        [cell.label sizeToFit];
//    }];
    
    
    CABasicAnimation *colorAnimation = [CABasicAnimation
                                        animationWithKeyPath:@"foregroundColor"];
    colorAnimation.duration = 0.35f;
    colorAnimation.fillMode = kCAFillModeForwards;
    colorAnimation.removedOnCompletion = NO;
    colorAnimation.fromValue = (__bridge id)[UIColor hexColor:@"#666666"].CGColor;
    colorAnimation.toValue = (__bridge id) [UIColor hexColor:@"#00b856"].CGColor;
    colorAnimation.timingFunction = [CAMediaTimingFunction
                                     functionWithName:kCAMediaTimingFunctionLinear];
//
    
//    CABasicAnimation *fontAnimation = [CABasicAnimation animationWithKeyPath:@"font"];
//    fontAnimation.duration = 3.0f;
//    fontAnimation.fillMode = kCAFillModeForwards;
//    fontAnimation.removedOnCompletion = NO;
//    fontAnimation.fromValue = (__bridge id)[UIFont systemFontOfSize:24].CTFont;
//    fontAnimation.toValue   = (__bridge id)[UIFont systemFontOfSize:30].CTFont;
//    fontAnimation.timingFunction = [CAMediaTimingFunction
//                                     functionWithName:kCAMediaTimingFunctionLinear];
//    
//    [cell.label.textLayer addAnimation:fontAnimation forKey:@"fontAnimation"];
    
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    
//    group.animations = @[colorAnimation,fontAnimation];
    
//    [cell.label setFont:[UIFont systemFontOfSize:30]];
    [cell.label.textLayer setForegroundColor:[UIColor hexColor:@"#00b856"].CGColor]; // This is what I have actually added
    [cell.label.textLayer addAnimation:colorAnimation forKey:@"colorAnimation"];
    
}

- (void) hightlightFirstCell:(NSArray *)indexs{
    for (NSIndexPath *index in indexs) {
        KNTableViewCell *cell = (KNTableViewCell *)[_tableView cellForRowAtIndexPath:index];
//        [UIView animateWithDuration:0.35f animations:^{
////            [cell.label setTextColor:[UIColor hexColor:@"#666666"]];
//            cell.label.textColor = [UIColor hexColor:@"#666666"];
////            [cell.label setFont:[UIFont systemFontOfSize:24]];
////            [cell.label sizeToFit];
//        }];
        
        
        CABasicAnimation *colorAnimation = [CABasicAnimation
                                            animationWithKeyPath:@"foregroundColor"];
        colorAnimation.duration = 0.35f;
        colorAnimation.fillMode = kCAFillModeForwards;
        colorAnimation.removedOnCompletion = NO;
        colorAnimation.fromValue = (__bridge id)[UIColor hexColor:@"#00b856"].CGColor;
        colorAnimation.toValue = (__bridge id) [UIColor hexColor:@"#666666"].CGColor;
        colorAnimation.timingFunction = [CAMediaTimingFunction
                                         functionWithName:kCAMediaTimingFunctionLinear];
        
//        [cell.label setFont:[UIFont systemFontOfSize:24]];
        [cell.label.textLayer setForegroundColor:[UIColor hexColor:@"#666666"].CGColor]; // This is what I have actually added
        [cell.label.textLayer addAnimation:colorAnimation forKey:@"colorAnimation"];
    }
    
    
}

- (void) hightlightSecondCell:(NSArray *)indexs{
    for (NSIndexPath *index in indexs) {
        KNTableViewCell *cell = (KNTableViewCell *)[_tableView cellForRowAtIndexPath:index];
//        [UIView animateWithDuration:0.35f animations:^{
////            [cell.label setTextColor:[UIColor hexColor:@"#999999"]];
//            cell.label.textColor = [UIColor hexColor:@"#999999"];
////            cell.label.font = [UIFont systemFontOfSize:18];
////            [cell.label sizeToFit];
//        }];
        
        CABasicAnimation *colorAnimation = [CABasicAnimation
                                            animationWithKeyPath:@"foregroundColor"];
        colorAnimation.duration = 0.35f;
        colorAnimation.fillMode = kCAFillModeForwards;
        colorAnimation.removedOnCompletion = NO;
        colorAnimation.fromValue = (__bridge id)[UIColor hexColor:@"#666666"].CGColor;
        colorAnimation.toValue = (__bridge id) [UIColor hexColor:@"#999999"].CGColor;
        colorAnimation.timingFunction = [CAMediaTimingFunction
                                         functionWithName:kCAMediaTimingFunctionLinear];
        
        
        [cell.label.textLayer setForegroundColor:[UIColor hexColor:@"#999999"].CGColor]; // This is what I have actually added
        [cell.label.textLayer addAnimation:colorAnimation forKey:@"colorAnimation"];
        
        
    }
}

@end

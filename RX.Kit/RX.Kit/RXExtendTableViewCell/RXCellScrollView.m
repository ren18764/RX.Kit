//
//  EQCellScrollView.m
//  RX-KIT
//
//  Created by 任玺 on 15/11/23.
//  Copyright © 2015年 Constantine. All rights reserved.
//

#import "RXCellScrollView.h"

@implementation RXCellScrollView

#pragma mark - 处理 ScrollView 与 UITableViewCell 的手势冲突
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    if(!self.dragging)
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    if(!self.dragging)
    {
        [self.nextResponder touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
}

- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return [super touchesShouldCancelInContentView:view];
}

@end

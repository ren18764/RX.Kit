//
//  UIActionSheet+EQGlobal.m
//  RX-KIT
//
//  Created by 任玺 on 15/6/27.
//  Copyright (c) 2015年 Constantine. All rights reserved.
//

#import "RXGlobalActionSheet.h"

#define GLOBAL_DISMISS_NTF      @"globalDismissNtf"

@implementation RXGlobalActionSheet

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  @author 任玺, 15-06-27
 *
 *  触发全局销毁，会销毁所有 开启canGlobalDismiss 的UIActionSheet
 */
+(void)globalDimiss
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GLOBAL_DISMISS_NTF object:nil];
}

/**
 *  @author 任玺, 15-06-27
 *
 *  设置UIActionSheet可以通过全局销毁。
 *
 *  @param canGlobalDismiss     YES,允许全局销毁.
 */
-(void)setCanGlobalDismiss:(BOOL)canGlobalDismiss
{
    if (canGlobalDismiss) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissWithNotify:) name:GLOBAL_DISMISS_NTF object:nil];
    }
}


#pragma mark - Notification Function
-(void)dismissWithNotify:(NSNotification *)notify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:YES];
}

@end

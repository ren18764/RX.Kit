//
//  EQGlobalActionSheet.h
//  RX-KIT
//
//  Created by 任玺 on 15/6/27.
//  Copyright (c) 2015年 Constantine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RXGlobalActionSheet :UIActionSheet

/**
 *  @author 任玺, 15-06-27
 *
 *  触发全局销毁，会销毁所有 canGlobalDismiss==YES 的UIActionSheet
 */
+(void)globalDimiss;


/**
 *  @author 任玺, 15-06-27
 *
 *  设置UIActionSheet可以通过全局销毁。
 *
 *  @param canGlobalDismiss     YES,允许全局销毁.
 */
-(void)setCanGlobalDismiss:(BOOL)canGlobalDismiss;

@end

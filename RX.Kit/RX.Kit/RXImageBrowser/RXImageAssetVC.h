//
//  EQImageAssetVC.h
//  RX-KIT
//
//  Created by 任玺 on 15/11/30.
//  Copyright © 2015年 Constantine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RXImageAssetVC : UIViewController

/**
 *  会话相册页面
 *  @param imageArray 图片数组
 *  @param callback   回调，用于切换当前显示的index
 */
-(instancetype)initWithImageArray:(NSArray *)imageArray callback:(void(^)(NSInteger index))callback;

@end

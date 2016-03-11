//
//  EQImageBrowser.h
//  RX-KIT
//
//  Created by 任玺 on 15/11/30.
//  Copyright © 2015年 Constantine. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EQSessionInfo;
@interface RXImageBrowserVC : UIViewController

/**
 *  图片浏览器，传入文件夹路径与当前要展示的图片
 *
 *  @param sessionInfo          会话对象
 *  @param currentImageName     当前要展示的图片
 *  @param rectInSuperView      触发区域的坐标，用来做动画
 */
-(instancetype)initImageBrowser:(EQSessionInfo *)sessionInfo
               currentImageName:(NSString *)currentImageName
                rectInSuperView:(CGRect)rectInSuperView;

/**
 *  显示图片浏览器
 */
-(void)show;

@end




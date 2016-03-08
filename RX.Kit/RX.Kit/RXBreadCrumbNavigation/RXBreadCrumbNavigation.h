//
//  EQBreadCrumbNavigation.h
//  RX-KIT
//
//  Created by 任玺 on 15/8/10.
//  Copyright (c) 2015年 Constantine. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  实现面包屑导航，配合 UINavigationController 跳转VC最好。
 *  用于多数据层级的展示和导航，比如公司组织架构。
 */
@protocol RXBreadCrumbNavigationDelegate <NSObject>

-(void)popToIndex:(NSInteger )index;

@end

@interface RXBreadCrumbNavigation : UIView

-(instancetype)initWithFrame:(CGRect)frame path:(NSArray *)path delegate:(id<RXBreadCrumbNavigationDelegate>)delegate;

@end

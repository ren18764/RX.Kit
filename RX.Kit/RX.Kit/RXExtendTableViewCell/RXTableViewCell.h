//
//  RXTableViewCell.h
//  RX-KIT
//
//  Created by 任玺 on 15/11/23.
//  Copyright © 2015年 Constantine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RXTableViewCellDelegate <NSObject>

-(void)buttonClicked:(NSInteger)tag indexPath:(NSIndexPath *)indexPath;

@end

@interface RXTableViewCell : UITableViewCell

/**
 *  UITableViewCell 扩展，支持侧滑后显示多个按钮。
 *
 *  @param style
 *  @param reuseIdentifier
 *  @param buttonTitles    按钮标题数组
 *  @param buttonColors    按钮背景颜色数组
 *  @param contentHeight   行高，用于设置内容高度
 *  @param indexPath       索引
 *  @param delegate        委托
 *
 */
-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                buttonTitles:(NSArray *)buttonTitles
                buttonColors:(NSArray *)buttonColors
               contentHeight:(CGFloat)contentHeight
                   indexPath:(NSIndexPath *)indexPath
                    delegate:(id<RXTableViewCellDelegate>)delegate;
@end

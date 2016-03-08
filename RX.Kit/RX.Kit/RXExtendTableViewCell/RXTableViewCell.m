//
//  RXTableViewCell.m
//  RX-KIT
//
//  Created by 任玺 on 15/11/23.
//  Copyright © 2015年 Constantine. All rights reserved.
//

#import "RXTableViewCell.h"
#import "RXCellScrollView.h"

#define BTN_H_SPACE     10

#define CELL_SHOW_EXTEND_BTN_NTF            @"cellShowExtendBtnNtf"

#define CELL_USERINFO_KEY            @"cellUserInfoKey"

@interface RXTableViewCell () <UIScrollViewDelegate>

@end

@implementation RXTableViewCell
{
    NSArray *_buttonTitles;
    NSArray *_buttonColors;
    CGFloat _contentHeight;
    NSIndexPath *_indexPath;
    __weak id<RXTableViewCellDelegate> _delegate;
    RXCellScrollView *_contentScrollView;
    
    UIView *_btnContentView;
    CGFloat _btn_max_x; //扩展按钮在屏幕坐标系的X
}

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
                    delegate:(id<RXTableViewCellDelegate>)delegate
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        _buttonTitles = buttonTitles;
        _buttonColors = buttonColors;
        _contentHeight = contentHeight;
        _indexPath = indexPath;
        _delegate = delegate;
        
        _contentScrollView = [[RXCellScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _contentHeight)];
        _contentScrollView.delegate = self;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        [self addSubview:_contentScrollView];
        
        //如果没有背景色，则指定白色
        if(CGColorEqualToColor(self.backgroundColor.CGColor, [UIColor clearColor].CGColor)
           || self.backgroundColor == nil){
            self.contentView.backgroundColor = [UIColor whiteColor];
        }else{
            self.contentView.backgroundColor = self.backgroundColor;
        }
        
        [_contentScrollView addSubview:self.contentView];
        
        [self loadButton];
    }
    return self;
}

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Private Function
-(void)loadButton
{
    _btnContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _contentHeight)];
    
    _btn_max_x = SCREEN_WIDTH;
    for (int i=0; i<_buttonTitles.count; i++) {
        NSString *btnTitle = [_buttonTitles objectAtIndex:i];
        CGSize btnSize = [btnTitle sizeWithAttributes:@{NSFontAttributeName:FONT_SYSTEM(16)}];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_btn_max_x-btnSize.width-2*BTN_H_SPACE, 0, btnSize.width+2*BTN_H_SPACE, _contentHeight)];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        if(_buttonColors.count >i){
            btn.backgroundColor = [_buttonColors objectAtIndex:i];
        }
        btn.titleLabel.font = FONT_SYSTEM(16);
        [_btnContentView addSubview:btn];
        _btn_max_x -= btnSize.width+2*BTN_H_SPACE;
    }
    
    [_contentScrollView addSubview:_btnContentView];
    _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH+(SCREEN_WIDTH-_btn_max_x), _contentHeight);
    //把内容图层拿到最上
    [_contentScrollView bringSubviewToFront:self.contentView];
}

-(void)btnAction:(UIButton *)sender
{
    if (_delegate
        && [_delegate conformsToProtocol:@protocol(RXTableViewCellDelegate)]
        && [_delegate respondsToSelector:@selector(buttonClicked:indexPath:)]) {
        
        [_delegate buttonClicked:sender.tag indexPath:_indexPath];
    }
}

//保持 _btnContentView 在界面中位置不变
- (void)keepContentsInScreenCenter
{
    _btnContentView.frame = CGRectMake(_contentScrollView.contentOffset.x, 0, SCREEN_WIDTH, _contentHeight);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self keepContentsInScreenCenter];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self keepContentsInScreenCenter];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(_contentScrollView.contentOffset.x == SCREEN_WIDTH-_btn_max_x){
        //发出消息，让其他cell做收起操作
        [[NSNotificationCenter defaultCenter] postNotificationName:CELL_SHOW_EXTEND_BTN_NTF object:nil userInfo:@{CELL_USERINFO_KEY:_indexPath}];
        
        //添加监听，如果有其他cell发出展示消息，则本cell做收起操作。
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveShowExtendNotify:) name:CELL_SHOW_EXTEND_BTN_NTF object:nil];
        
    }else if (_contentScrollView.contentOffset.x == 0){
        //恢复状态后，就移除监听
        [[NSNotificationCenter defaultCenter] removeObserver:self name:CELL_SHOW_EXTEND_BTN_NTF object:nil];
    }
}

#pragma mark - Notification Function
-(void)receiveShowExtendNotify:(NSNotification *)notify
{
    NSIndexPath *tmpIndexPath = notify.userInfo[CELL_USERINFO_KEY];
    
    if ([tmpIndexPath compare:_indexPath] != NSOrderedSame) {
        //恢复状态后，就移除监听
        [[NSNotificationCenter defaultCenter] removeObserver:self name:CELL_SHOW_EXTEND_BTN_NTF object:nil];
        
        [_contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

@end




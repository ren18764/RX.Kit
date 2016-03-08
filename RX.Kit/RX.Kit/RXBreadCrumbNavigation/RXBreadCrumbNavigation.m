//
//  EQBreadCrumbNavigation.m
//  RX-KIT
//
//  Created by 任玺 on 15/8/10.
//  Copyright (c) 2015年 Constantine. All rights reserved.
//

#import "RXBreadCrumbNavigation.h"

#define BTN_WIDTH       60

@implementation RXBreadCrumbNavigation
{
    id<RXBreadCrumbNavigationDelegate> _delegate;
    UIScrollView *_scrollView;
}

-(instancetype)initWithFrame:(CGRect)frame path:(NSArray *)path delegate:(id<RXBreadCrumbNavigationDelegate>)delegate
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _delegate = delegate;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        
        CGFloat btn_x = 0;
        for(int i=0; i<path.count; i++) {
            NSString *sectionStr = [path objectAtIndex:i];
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:sectionStr];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [attributedString length])];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [attributedString length])];
            
            NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(frame))
                                                         options:options
                                                         context:nil];

            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btn_x, 2, CGRectGetWidth(rect)+BTN_WIDTH, CGRectGetHeight(frame))];
            [btn setAttributedTitle:attributedString forState:UIControlStateNormal];
            
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            
            [btn setImage:[UIImage imageNamed:@"mail_s_icon_transmit"] forState:UIControlStateNormal];
            
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(btn.imageView.frame))];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(btn.titleLabel.frame)+40, 0, 0)];
            
            btn.tag = i;
            [btn addTarget:self action:@selector(breadCrumbAction:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:btn];
            
            btn_x += CGRectGetWidth(rect)+BTN_WIDTH;
        }

        [_scrollView setContentSize:CGSizeMake(btn_x, CGRectGetHeight(frame))];
        if(btn_x-CGRectGetWidth(self.frame)>0){
            [_scrollView setContentOffset:CGPointMake(btn_x-CGRectGetWidth(self.frame), 0) animated:YES];
        }
    }
    
    return self;
}

#pragma mark - UIControl Action
-(void)breadCrumbAction:(UIButton *)sender
{
    if (_delegate
        && [_delegate conformsToProtocol:@protocol(RXBreadCrumbNavigationDelegate)]
        && [_delegate respondsToSelector:@selector(popToIndex:)]) {
        
        [_delegate popToIndex:sender.tag];
    }
}


@end


//
//  EQImageBrowserCell.m
//  RX-KIT
//
//  Created by 任玺 on 15/11/30.
//  Copyright © 2015年 Constantine. All rights reserved.
//

#import "RXImageBrowserCell.h"

@interface RXImageBrowserCell () <UIScrollViewDelegate>

@end

@implementation RXImageBrowserCell
{
    UIScrollView *_scrollerView;
    UIImageView *_imageView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _scrollerView.delegate = self;
        _scrollerView.maximumZoomScale = 2.0;
        _scrollerView.minimumZoomScale = 1;
        _scrollerView.showsHorizontalScrollIndicator = NO;
        _scrollerView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollerView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        [_scrollerView addSubview:_imageView];
    }
    return self;
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = image;
}

- (void)prepareForReuse
{
    _scrollerView.zoomScale = 1.0;
}

#pragma mark - UIScrollViewDelegate
//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

@end



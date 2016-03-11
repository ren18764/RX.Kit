//
//  EQImageAssetCell.m
//  RX-KIT
//
//  Created by 任玺 on 16/1/4.
//  Copyright © 2016年 Constantine. All rights reserved.
//

#import "RXImageAssetCell.h"

@implementation RXImageAssetCell
{
    UIImageView *_imageView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
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

}



@end


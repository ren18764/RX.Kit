//
//  EQImageAssetVC.m
//  RX-KIT
//
//  Created by 任玺 on 15/11/30.
//  Copyright © 2015年 Constantine. All rights reserved.
//

#import "RXImageAssetVC.h"
#import "RXImageAssetCell.h"

#define ASSET_COLLECTION_VIEW_RECT          CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TITLE_HEIGHT)

static NSString * CellIdentifier = @"imageAssetCell";
@interface RXImageAssetVC ()    <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation RXImageAssetVC
{
    NSArray *_imageArray;        //存储图片文件数据，UIImage对象
    void (^_callback)(NSInteger index);
    
    UICollectionView *_collectionView;
}

/**
 *  会话相册页面
 *  @param imageArray 图片数组
 *  @param callback   回调，用于切换当前显示的index
 */
-(instancetype)initWithImageArray:(NSArray *)imageArray callback:(void(^)(NSInteger index))callback
{
    if(self = [super init]){
        self.view.backgroundColor = [UIColor whiteColor];
        _imageArray = imageArray;
        _callback = callback;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self initNavigationBar:@"会话相册" leftImage:nil rightImage:nil leftText:@"取消" rightText:nil];
    
    //网格布局
    _collectionView = [[UICollectionView alloc] initWithFrame:ASSET_COLLECTION_VIEW_RECT collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = UIColorFromRGB(0x333333);
    [_collectionView registerClass:[RXImageAssetCell class] forCellWithReuseIdentifier:CellIdentifier];
    [self.view addSubview:_collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navgition Btn Action
-(void)leftBtnPressed
{
    _callback(-1);
}

-(void)rightBtnPressed
{
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width / 4.0f -5;
    return CGSizeMake(cellWidth, cellWidth);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4, 4, 4, 4);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(4, 4);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _callback(indexPath.row);
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RXImageAssetCell *imageBrowserCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    imageBrowserCell.image = [_imageArray objectAtIndex:indexPath.row];
    
    return imageBrowserCell;
}

@end



//
//  EQImageBrowser.m
//  RX-KIT
//
//  Created by 任玺 on 15/11/30.
//  Copyright © 2015年 Constantine. All rights reserved.
//

#import "RXImageBrowserVC.h"
#import "RXImageBrowserCell.h"
#import "RXImageAssetVC.h"
#import "RXGlobalActionSheet.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define COLLECTIONVIEW_RECT                 CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

static NSString * CellIdentifier = @"photoBrowserCell";

@interface RXImageBrowserVC () <UICollectionViewDelegate, UICollectionViewDataSource, UIActionSheetDelegate>

@end

@implementation RXImageBrowserVC
{
    EQSessionInfo *_sessionInfo;
    NSString *_currentImageName;
    
    NSMutableArray *_imageArray;        //存储图片文件数据，UIImage对象
    
    UICollectionView *_collectionView;
    NSIndexPath *_currentIndexPath;
    CGRect _rectInSuperView;
    
    UIButton *_albumBtn;
}

/**
 *  图片浏览器，传入文件夹路径与当前要展示的图片
 *
 *  @param sessionInfo          会话对象
 *  @param currentImageName     当前要展示的图片
 *  @param superVC              父窗口
 *  @param rectInSuperView      触发区域的坐标，用来做动画
 */
-(instancetype)initImageBrowser:(EQSessionInfo *)sessionInfo
               currentImageName:(NSString *)currentImageName
                rectInSuperView:(CGRect)rectInSuperView
{
    if (self = [super init]) {
        _sessionInfo = sessionInfo;
        _rectInSuperView = rectInSuperView;
        [self loadImageAssetPath:IM_CACHE_USER_PATH(sessionInfo.sessionID) currentImageName:currentImageName];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.alpha = 0.0;
    self.view.backgroundColor = cor1;
    
    UICollectionViewFlowLayout *flowLayout =  [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:COLLECTIONVIEW_RECT collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.maximumZoomScale = 1.0;
    _collectionView.minimumZoomScale = 1.0;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[RXImageBrowserCell class] forCellWithReuseIdentifier:CellIdentifier];
    [_collectionView scrollToItemAtIndexPath:_currentIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    [self.view addSubview:_collectionView];
    
    _albumBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-32-15, SCREEN_HEIGHT-32-10, 32, 32)];
    [_albumBtn setImage:[UIImage imageNamed:@"album_nor"] forState:UIControlStateNormal];
    [_albumBtn setImage:[UIImage imageNamed:@"album_press"] forState:UIControlStateHighlighted];
    [_albumBtn addTarget:self action:@selector(presentAlbum:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_albumBtn];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
    [self.view addGestureRecognizer:longPressGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  显示图片浏览器
 */
-(void)show
{
    [UIView animateWithDuration:0.2 animations:^{
        [_collectionView setFrame:COLLECTIONVIEW_RECT];
        [_collectionView scrollToItemAtIndexPath:_currentIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
        self.view.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Private Function
-(void)loadImageAssetPath:(NSString *)imageAssetPath
         currentImageName:(NSString *)currentImageName
{
    _imageArray = [[NSMutableArray alloc] init];
    for (MessageModel *messageModel in _sessionInfo.messageArray) {
        if (messageModel.fileType == PIC_MSG_TYPE) {
            
            NSString *fileNamePath = [imageAssetPath stringByAppendingPathComponent:messageModel.imageChatData.imageName];
            UIImage *image = [UIImage imageWithContentsOfFile:fileNamePath];
            if (image) {
                [_imageArray addObject:image];
            }
            
            if ([messageModel.imageChatData.imageName isEqualToString:currentImageName]) {
                _currentIndexPath = [NSIndexPath indexPathForRow:_imageArray.count-1 inSection:0];
            }
        }
    }
}

-(void)saveImageAssetURL:(NSURL *)assetURL complete:(void(^)(NSError *error))complete
{
    //相册存在标示
    __block BOOL albumWasFound = NO;

    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop){
         
         //判断相册是否存在
         if ([SYSTEM_ALBUM_NAME compare:[group valueForProperty:ALAssetsGroupPropertyName]] == NSOrderedSame) {
             //存在
             albumWasFound = YES;
             [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                 //添加进相册
                 [group addAsset: asset];
                 complete(nil);
                 
             } failureBlock:^(NSError *error) {
                 complete(error);
             }];
             
             return;
         }
         
         //如果不存在该相册创建
         if (group == nil
             && albumWasFound == NO){
             __weak ALAssetsLibrary* weakSelf = assetsLibrary;
             
             //创建相册
             [assetsLibrary addAssetsGroupAlbumWithName:SYSTEM_ALBUM_NAME resultBlock:^(ALAssetsGroup *group) {
                 
                 [weakSelf assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                     [group addAsset: asset];
                     complete(nil);
                     
                 } failureBlock:^(NSError *error) {
                     complete(error);
                 }];
                 
             } failureBlock:^(NSError *error) {
                 complete(error);
             }];
             
             return;
         }
         
     }failureBlock:^(NSError *error) {
         complete(error);
     }];
}

#pragma mark -  UIGestureRecognizer Action
-(void)tapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self hide:nil];
}

-(void)longPressGestureRecognizer:(UITapGestureRecognizer *)longPressGestureRecognizer
{
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        EQGlobalActionSheet *actionSheet = [[EQGlobalActionSheet alloc] initWithTitle:nil
                                                                             delegate:self
                                                                    cancelButtonTitle:@"取消"
                                                               destructiveButtonTitle:nil
                                                                    otherButtonTitles:@"转发", @"保存到相册", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet setCanGlobalDismiss:YES];
        [actionSheet showInView:self.view];
    }
}

#pragma mark - UIControl Action
-(void)hide:(UIControl *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor clearColor];
        [_collectionView setFrame:_rectInSuperView];
        self.view.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

-(void)presentAlbum:(UIButton *)sender
{
    RXImageAssetVC *imageAssetVC = [[RXImageAssetVC alloc] initWithImageArray:_imageArray callback:^(NSInteger index) {
        if (index>=0) {
            _currentIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [_collectionView scrollToItemAtIndexPath:_currentIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UINavigationController *navCtl = [[UINavigationController alloc] initWithRootViewController:imageAssetVC];
    
    if (isIOS8) {
        navCtl.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }else{
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    [self presentViewController:navCtl animated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            //转发
            UIImage *image = [_imageArray objectAtIndex:_currentIndexPath.row];
            
            NSMutableDictionary *selectedDic = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *disEnableSelectedDic = [[NSMutableDictionary alloc] init];
            
            NSString *contacterID = [[EQUserInfoManager shareInstance] getUID];
            EQContactsDatabase *contactsDatabase = [[EQContactsDatabase alloc] initWithDB];
            EQContacter *contacter = [contactsDatabase getLocalContacterWithContactID:contacterID];
            if (!contacter) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"通讯录获取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                return;
            }
            [disEnableSelectedDic setObject:contacter forKey:contacterID];
            
            EQContactSelectorVC *contactSelectorVC = [[EQContactSelectorVC alloc] initWithSelectedDic:selectedDic
                                                                                 disEnableSelectedDic:disEnableSelectedDic
                                                                                 essentialSelectedDic:nil
                                                                                        selectedLimit:0
                                                                                          isShowGroup:NO
                                                                                    callBack:^(NSMutableDictionary *selectedDic) {
                                                                                        
                                                                                        [self dismissViewControllerAnimated:YES completion:^{
                                                                                            if (selectedDic) {
                                                                                                //通知转发消息
                                                                                                [[NSNotificationCenter defaultCenter] postNotificationName:SEND_XMPP_IMAGE_WITH_CONTACTER_NTF object:nil userInfo:@{USERINFO_KEY:selectedDic.allValues, MESSAGE_CONTENT_KEY:image}];
                                                                                            }
                                                                                        }];
                                                                                    }];
            
            UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:contactSelectorVC];
            if (isIOS8) {
                navigationVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }else{
                self.modalPresentationStyle = UIModalPresentationCurrentContext;
            }
            [self presentViewController:navigationVC animated:YES completion:nil];
        }
            break;
            
        case 1:{
            //保存到相册
            UIImage *image = [_imageArray objectAtIndex:_currentIndexPath.row];

            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            [assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
                [self saveImageAssetURL:assetURL complete:^(NSError *error) {
                    NSString *message = nil;
                    if (!error) {
                        message = @"成功保存到相册";
                        
                    }else{
                        message = [error description];
                    }
                    
                    [Alert showPopInfoWithTimeout:self.view message:message callback:nil];
                }];
            }];
        }
            break;
            
        case 2:
            //取消
            break;
            
        default:
            break;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = CGRectGetWidth(COLLECTIONVIEW_RECT);
    CGFloat cellHeight = CGRectGetHeight(COLLECTIONVIEW_RECT);
    return CGSizeMake(cellWidth, cellHeight);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - UICollectionViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    RXImageBrowserCell *imageBrowserCell = [[_collectionView visibleCells] firstObject];
    
    return imageBrowserCell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    _currentIndexPath = indexPath;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self hide:nil];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RXImageBrowserCell *imageBrowserCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    imageBrowserCell.image = [_imageArray objectAtIndex:indexPath.row];
    
    return imageBrowserCell;
}

@end



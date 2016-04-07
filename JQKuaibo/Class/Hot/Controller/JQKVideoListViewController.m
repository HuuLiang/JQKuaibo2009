//
//  JQKVideoListViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/8.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKVideoListViewController.h"
#import "JQKVideoCell.h"
#import "JQKVideoDetailViewController.h"
#import "JQKChannel.h"
#import "JQKVideoListModel.h"

static NSString *const kMovieCellReusableIdentifier = @"MovieCellReusableIdentifier";

@interface JQKVideoListViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic,retain) JQKVideoListModel *videoModel;
@property (nonatomic,retain) NSMutableArray<JQKVideo *> *videos;
@property (nonatomic) BOOL coverImageIsLandscape;
@end

@implementation JQKVideoListViewController

DefineLazyPropertyInitialization(JQKVideoListModel, videoModel)
DefineLazyPropertyInitialization(NSMutableArray, videos)

- (instancetype)initWithField:(JQKVideoListField)field {
    self = [super init];
    if (self) {
        _field = field;
    }
    return self;
}

- (instancetype)initWithChannel:(JQKChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
        _field = JQKVideoListFieldChannel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_channel) {
        self.title = _channel.Name;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = layout.minimumInteritemSpacing;
    layout.sectionInset = UIEdgeInsetsMake(layout.minimumInteritemSpacing, layout.minimumInteritemSpacing, layout.minimumInteritemSpacing, layout.minimumInteritemSpacing);
    
    _layoutCollectionView = [[UICollectionView  alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = self.view.backgroundColor;
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    [_layoutCollectionView registerClass:[JQKVideoCell class] forCellWithReuseIdentifier:kMovieCellReusableIdentifier];
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCollectionView JQK_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadMoviesWithRefreshFlag:YES];
    }];
    [_layoutCollectionView JQK_addPagingRefreshWithHandler:^{
        @strongify(self);
        [self loadMoviesWithRefreshFlag:NO];
    }];
    [_layoutCollectionView JQK_triggerPullToRefresh];
}

- (void)loadMoviesWithRefreshFlag:(BOOL)isRefresh {
    @weakify(self);
    NSUInteger page = isRefresh?1:self.videoModel.fetchedVideos.Pinfo.Page.unsignedIntegerValue+1;
    if (page > 1 && ![JQKUtil isPaid]) {
        [_layoutCollectionView JQK_endPullToRefresh];
        [[JQKHudManager manager] showHudWithText:@"成为VIP后可以查看更多"];
        return;
    }
    
    [self.videoModel fetchVideosWithField:_field
                                   pageNo:page
                                 pageSize:kDefaultPageSize
                                 columnId:_channel.Id
                        completionHandler:^(BOOL success, id obj)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (success) {
            
            void (^SuccessBlock)(void) = ^{
                @strongify(self);
                [self->_layoutCollectionView JQK_endPullToRefresh];
                
                if (isRefresh) {
                    [self.videos removeAllObjects];
                }
                
                JQKVideos *videos = obj;
                if (videos.Videos) {
                    [self.videos addObjectsFromArray:videos.Videos];
                    [self->_layoutCollectionView reloadData];
                }
                
                if (videos.Pinfo.Page.unsignedIntegerValue == videos.Pinfo.PageCount.unsignedIntegerValue) {
                    [self->_layoutCollectionView JQK_pagingRefreshNoMoreData];
                }
            };
            
            JQKVideos *videos = obj;
            if (videos.Videos.count == 0) {
                SuccessBlock();
                return ;
            }
            
            NSURL *imageURL = [NSURL URLWithString:videos.Videos.firstObject.coverUrl];
            [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL options:0 progress:nil
                                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
             {
                if (image) {
                    self.coverImageIsLandscape = image.size.width >= image.size.height;
                }
                
                SuccessBlock();
            }];
            
        } else {
            [self->_layoutCollectionView JQK_endPullToRefresh];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JQKVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMovieCellReusableIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.videos.count) {
        JQKVideo *video = self.videos[indexPath.item];
        cell.title = video.Name;
        cell.imageURL = [NSURL URLWithString:video.coverUrl];
        cell.isVIP = video.Vip.boolValue;
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videos.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    const CGFloat width = (CGRectGetWidth(collectionView.bounds) - layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right)/2;
    const CGFloat height = [JQKVideoCell heightRelativeToWidth:width landscape:self.coverImageIsLandscape];
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.videos.count) {
        JQKVideo *video = self.videos[indexPath.item];
        if (video.Vip.boolValue) {
            JQKVideoDetailViewController *videoVC = [[JQKVideoDetailViewController alloc] initWithVideo:video];
            [self.navigationController pushViewController:videoVC animated:YES];
        } else {
            [self playVideo:video withTimeControl:NO shouldPopPayment:YES];
        }
        
    }
}
@end

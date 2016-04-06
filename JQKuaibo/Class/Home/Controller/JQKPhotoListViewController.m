//
//  JQKPhotoListViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKPhotoListViewController.h"
#import "JQKChannel.h"
#import "JQKVideoCell.h"
#import "JQKPhotoListModel.h"

static NSString *const kPhotoCellReusableIdentifier = @"PhotoCellReusableIdentifier";

@interface JQKPhotoListViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic,retain) NSMutableArray<JQKPhoto *> *photos;
@property (nonatomic,retain) JQKPhotoListModel *photoModel;
@end

@implementation JQKPhotoListViewController

DefineLazyPropertyInitialization(JQKPhotoListModel, photoModel)
DefineLazyPropertyInitialization(NSMutableArray, photos)

- (instancetype)initWithPhotoAlbum:(JQKChannel *)album {
    self = [super init];
    if (self) {
        _album = album;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _album.Name;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = layout.minimumInteritemSpacing;
    layout.sectionInset = UIEdgeInsetsMake(layout.minimumInteritemSpacing, layout.minimumInteritemSpacing, layout.minimumInteritemSpacing, layout.minimumInteritemSpacing);
    
    _layoutCollectionView = [[UICollectionView  alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = self.view.backgroundColor;
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    [_layoutCollectionView registerClass:[JQKVideoCell class] forCellWithReuseIdentifier:kPhotoCellReusableIdentifier];
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCollectionView JQK_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadPhotosWithRefreshFlag:YES];
    }];
    [_layoutCollectionView JQK_addPagingRefreshWithHandler:^{
        @strongify(self);
        [self loadPhotosWithRefreshFlag:NO];
    }];
    [_layoutCollectionView JQK_triggerPullToRefresh];
}

- (void)loadPhotosWithRefreshFlag:(BOOL)isRefresh {
    @weakify(self);
    [self.photoModel fetchPhotosWithAlbumId:_album.Id page:isRefresh?1:self.photoModel.fetchedPhotos.Pinfo.Page.unsignedIntegerValue+1 pageSize:kDefaultPageSize completionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutCollectionView JQK_endPullToRefresh];
        
        if (success) {
            if (isRefresh) {
                [self.photos removeAllObjects];
            }
            
            JQKPhotos *photos = obj;
            if (photos.Pictures) {
                [self.photos addObjectsFromArray:photos.Pictures];
                [self->_layoutCollectionView reloadData];
            }
            
            if (photos.Pinfo.Page.unsignedIntegerValue == photos.Pinfo.PageCount.unsignedIntegerValue) {
                [self->_layoutCollectionView JQK_pagingRefreshNoMoreData];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JQKVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellReusableIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.photos.count) {
        JQKPhoto *photo = self.photos[indexPath.item];
        cell.title = photo.Name;
        cell.imageURL = [NSURL URLWithString:photo.coverUrl];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    const CGFloat width = (CGRectGetWidth(collectionView.bounds) - layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right)/2;
    const CGFloat height = [JQKVideoCell heightRelativeToWidth:width landscape:NO];
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.photos.count) {
        JQKPhoto *photo = self.photos[indexPath.item];
        [self switchToViewPhoto:photo];
    }
}

@end

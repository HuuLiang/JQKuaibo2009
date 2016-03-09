//
//  JQKMovieViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/8.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKMovieViewController.h"
#import "JQKMovieCell.h"
#import "JQKMovieModel.h"

static NSString *const kMovieCellReusableIdentifier = @"MovieCellReusableIdentifier";

@interface JQKMovieViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic,retain) JQKMovieModel *movieModel;
@property (nonatomic,retain) NSOperationQueue *operationQueue;
@property (nonatomic,retain) NSMutableArray<JQKVideo *> *videos;
@end

@implementation JQKMovieViewController

DefineLazyPropertyInitialization(JQKMovieModel, movieModel)
DefineLazyPropertyInitialization(NSMutableArray, videos)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = layout.minimumInteritemSpacing;
    layout.sectionInset = UIEdgeInsetsMake(layout.minimumInteritemSpacing, layout.minimumInteritemSpacing, layout.minimumInteritemSpacing, layout.minimumInteritemSpacing);
    
    _layoutCollectionView = [[UICollectionView  alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = self.view.backgroundColor;
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    [_layoutCollectionView registerClass:[JQKMovieCell class] forCellWithReuseIdentifier:kMovieCellReusableIdentifier];
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
    [self.movieModel fetchMoviesInPage:isRefresh?1:self.movieModel.fetchedVideos.page.unsignedIntegerValue+1
                 withCompletionHandler:^(BOOL success, id obj)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutCollectionView JQK_endPullToRefresh];
        
        if (success) {
            if (isRefresh) {
                [self.videos removeAllObjects];
            }
            
            JQKVideos *videos = obj;
            if (videos.programList) {
                [self.videos addObjectsFromArray:videos.programList];
                [self->_layoutCollectionView reloadData];
            }
            
            if (videos.page.unsignedIntegerValue * videos.pageSize.unsignedIntegerValue >= videos.items.unsignedIntegerValue) {
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
    JQKMovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMovieCellReusableIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.videos.count) {
        JQKVideo *video = self.videos[indexPath.item];
        cell.title = video.title;
        cell.imageURL = [NSURL URLWithString:video.coverImg];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videos.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    const CGFloat width = (CGRectGetWidth(collectionView.bounds) - layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right)/2;
    const CGFloat height = width * 0.8;
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JQKVideo *video = self.videos[indexPath.item];
    [self switchToPlayProgram:(JQKProgram *)video];
}
@end

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
#import "JQKChannel.h"
#import "JQKChannelProgramModel.h"

static NSString *const kMovieCellReusableIdentifier = @"MovieCellReusableIdentifier";

@interface JQKMovieViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic,retain) JQKChannelProgramModel *programModel;
@property (nonatomic,retain) NSMutableArray<JQKVideo *> *videos;
@end

@implementation JQKMovieViewController

DefineLazyPropertyInitialization(JQKChannelProgramModel, programModel)
DefineLazyPropertyInitialization(NSMutableArray, videos)

- (instancetype)initWithChannel:(JQKChannel *)channel {
    self = [self init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _channel.name;
    
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
    [self.programModel fetchProgramsWithColumnId:_channel.columnId
                                          pageNo:isRefresh?1:self.programModel.fetchedPrograms.page.unsignedIntegerValue+1
                                        pageSize:kDefaultPageSize
                               completionHandler:^(BOOL success, id obj)
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
            
            JQKChannelPrograms *channelPrograms = obj;
            if (channelPrograms.programList) {
                [self.videos addObjectsFromArray:channelPrograms.programList];
                [self->_layoutCollectionView reloadData];
            }
            
            if (channelPrograms.page.unsignedIntegerValue * channelPrograms.pageSize.unsignedIntegerValue >= channelPrograms.items.unsignedIntegerValue) {
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

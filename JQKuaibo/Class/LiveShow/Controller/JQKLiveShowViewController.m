//
//  JQKLiveShowViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKLiveShowViewController.h"
#import "JQKHotVideoModel.h"
#import "JQKHotVideoCell.h"
#import "JQKSystemConfigModel.h"

static NSString *const kLiveShowCellReusableIdentifier = @"LiveShowCellReusableIdentifier";

@interface JQKLiveShowViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
//    UIImageView *_headerImageView;
//    UILabel *_priceLabel;
    
//    UITableView *_layoutTableView;
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic,retain) JQKHotVideoModel *videoModel;
@property (nonatomic,retain) NSMutableArray<JQKProgram *> *videos;
@end

@implementation JQKLiveShowViewController

DefineLazyPropertyInitialization(JQKHotVideoModel, videoModel)
DefineLazyPropertyInitialization(NSMutableArray, videos)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = layout.minimumInteritemSpacing;
    layout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);
    
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = [UIColor whiteColor];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    [_layoutCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kLiveShowCellReusableIdentifier];
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCollectionView JQK_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadVideosWithPage:1];
    }];
    [_layoutCollectionView JQK_addPagingRefreshWithHandler:^{
        @strongify(self);
        [self loadVideosWithPage:self.videoModel.fetchedVideos.page.unsignedIntegerValue+1];
    }];
    [_layoutCollectionView JQK_triggerPullToRefresh];
}

- (void)loadVideosWithPage:(NSUInteger)page {
    @weakify(self);
    [self.videoModel fetchVideosWithPageNo:page completionHandler:^(BOOL success, JQKVideos *videos) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutCollectionView JQK_endPullToRefresh];
        
        if (success) {
            if (page == 1) {
                [self.videos removeAllObjects];
            }
            [self.videos addObjectsFromArray:videos.programList];
            [self->_layoutCollectionView reloadData];
            
            if (videos.items.unsignedIntegerValue == self.videos.count) {
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLiveShowCellReusableIdentifier forIndexPath:indexPath];
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    cell.layer.cornerRadius = 5;
    
    if (indexPath.item < self.videos.count) {
        JQKVideo *video = self.videos[indexPath.item];
        
        if (!cell.backgroundView) {
            cell.backgroundView = [[UIImageView alloc] init];
        }
        
        UIImageView *imageView = (UIImageView *)cell.backgroundView;
        [imageView sd_setImageWithURL:[NSURL URLWithString:video.coverImg]];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videos.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    const CGFloat width = (CGRectGetWidth(collectionView.bounds) - layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right)/2;
    const CGFloat height = width * 517./310.;
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JQKVideo *video = self.videos[indexPath.item];
    [self switchToPlayProgram:(JQKProgram *)video];
}
//
//#pragma mark - UITableViewDataSource,UITableViewDelegate
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    JQKHotVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:kLiveShowCellReusableIdentifier forIndexPath:indexPath];
//    
//    if (indexPath.row < self.videos.count) {
//        JQKProgram *video = self.videos[indexPath.row];
//        cell.imageURL = [NSURL URLWithString:video.coverImg];
//        cell.title = video.title;
//        //cell.subtitle = video.specialDesc;
//        
////        @weakify(self);
////        cell.playAction = ^{
////            @strongify(self);
////            [self switchToPlayProgram:video];
////        };
//    }
//    return cell;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.videos.count;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row < self.videos.count) {
//        JQKProgram *video = self.videos[indexPath.row];
//        [self switchToPlayProgram:video];
//    }
//}
@end

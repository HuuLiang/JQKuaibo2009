//
//  JQKHomeViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKHomeViewController.h"
#import "JQKVideoDetailViewController.h"
#import "JQKVideoCell.h"
#import "JQKHomeSectionHeaderView.h"
#import "JQKSystemConfigModel.h"
#import <SDCycleScrollView.h>
#import "JQKVideoListModel.h"
#import "JQKPhotoAlbumModel.h"
#import "JQKPhotoListViewController.h"

static NSString *const kHomeCellReusableIdentifier = @"HomeCellReusableIdentifier";
static NSString *const kBannerCellReusableIdentifier = @"BannerCellReusableIdentifier";
static NSString *const kHomeSectionHeaderReusableIdentifier = @"HomeSectionHeaderReusableIdentifier";

typedef NS_ENUM(NSUInteger, JQKHomeSection) {
    JQKHomeSectionBanner,
    JQKHomeSectionTrial,
    JQKHomeSectionVIP,
    JQKHomeSectionMeitui,
    JQKHomeSectionNvyou,
    JQKHomeSectionPhotos,
    JQKHomeSectionCount
};

@interface JQKHomeViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>
{
    UICollectionView *_layoutCollectionView;
    
    UICollectionViewCell *_bannerCell;
    SDCycleScrollView *_bannerView;
}
@property (nonatomic,retain) NSMutableDictionary<NSNumber *, JQKVideoListModel *> *videoModels;
@property (nonatomic,retain) JQKPhotoAlbumModel *albumModel;
@property (nonatomic,retain) dispatch_group_t dataDispatchGroup;
@end

@implementation JQKHomeViewController

DefineLazyPropertyInitialization(JQKPhotoAlbumModel, albumModel)

- (dispatch_group_t)dataDispatchGroup {
    if (_dataDispatchGroup) {
        return _dataDispatchGroup;
    }
    
    _dataDispatchGroup = dispatch_group_create();
    return _dataDispatchGroup;
}

- (NSMutableDictionary<NSNumber *,JQKVideoListModel *> *)videoModels {
    if (_videoModels) {
        return _videoModels;
    }
    
    _videoModels = [[NSMutableDictionary alloc] init];
    for (NSUInteger i = 0; i < JQKHomeSectionCount-1; ++i) {
        [_videoModels setObject:[[JQKVideoListModel alloc] init] forKey:@(i)];
    }
    return _videoModels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _bannerView = [[SDCycleScrollView alloc] init];
    _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _bannerView.autoScrollTimeInterval = 3;
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _bannerView.delegate = self;
    _bannerView.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = layout.minimumLineSpacing;
    
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = [UIColor whiteColor];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    [_layoutCollectionView registerClass:[JQKVideoCell class] forCellWithReuseIdentifier:kHomeCellReusableIdentifier];
    [_layoutCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kBannerCellReusableIdentifier];
    [_layoutCollectionView registerClass:[JQKHomeSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeSectionHeaderReusableIdentifier];
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCollectionView JQK_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadChannels];
    }];
    [_layoutCollectionView JQK_triggerPullToRefresh];
}

- (void)loadChannels {
    @weakify(self);
    
    for (NSUInteger i = 0; i < JQKHomeSectionCount; ++i) {
        dispatch_group_enter(self.dataDispatchGroup);
    }
    
    [self.videoModels[@(JQKHomeSectionBanner)] fetchVideosWithField:JQKVideoListFieldRecommend
                                                             pageNo:0 pageSize:6 columnId:nil
                                                  completionHandler:^(BOOL success, id obj)
    {
        @strongify(self);
        if (self) {
            dispatch_group_leave(self.dataDispatchGroup);
        }
    }];
    
    [self.videoModels[@(JQKHomeSectionTrial)] fetchVideosWithField:JQKVideoListFieldChannel
                                                            pageNo:1 pageSize:10 columnId:@"13"
                                                 completionHandler:^(BOOL success, id obj)
    {
        @strongify(self);
        if (self) {
            dispatch_group_leave(self.dataDispatchGroup);
        }
    }];
    
    [self.videoModels[@(JQKHomeSectionVIP)] fetchVideosWithField:JQKVideoListFieldVIP
                                                          pageNo:1 pageSize:8 columnId:nil
                                               completionHandler:^(BOOL success, id obj)
    {
        @strongify(self);
        if (self) {
            dispatch_group_leave(self.dataDispatchGroup);
        }
    }];
    
    [self.videoModels[@(JQKHomeSectionMeitui)] fetchVideosWithField:JQKVideoListFieldChannel
                                                             pageNo:1 pageSize:6 columnId:@"17"
                                                  completionHandler:^(BOOL success, id obj)
    {
        @strongify(self);
        if (self) {
            dispatch_group_leave(self.dataDispatchGroup);
        }
    }];
    
    [self.videoModels[@(JQKHomeSectionNvyou)] fetchVideosWithField:JQKVideoListFieldChannel
                                                            pageNo:1 pageSize:6 columnId:@"10"
                                                 completionHandler:^(BOOL success, id obj)
    {
        @strongify(self);
        if (self) {
            dispatch_group_leave(self.dataDispatchGroup);
        }
    }];
    
    [self.albumModel fetchAlbumsWithPage:1 pageSize:6 completionHandler:^(BOOL success, id obj)
    {
        @strongify(self);
        if (self) {
            dispatch_group_leave(self.dataDispatchGroup);
        }
    }];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_group_wait(self.dataDispatchGroup, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_layoutCollectionView JQK_endPullToRefresh];
            
            [self refreshBannerView];
            [_layoutCollectionView reloadData];
        });
    });
}

- (void)refreshBannerView {
    NSMutableArray *imageUrlGroup = [NSMutableArray array];
    NSMutableArray *titlesGroup = [NSMutableArray array];
    for (JQKVideo *bannerVideo in self.videoModels[@(JQKHomeSectionBanner)].fetchedVideos.Videos) {
        [imageUrlGroup addObject:bannerVideo.coverUrl];
        [titlesGroup addObject:bannerVideo.Name];
    }
    _bannerView.imageURLStringsGroup = imageUrlGroup;
    _bannerView.titlesGroup = titlesGroup;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (!_bannerCell) {
            _bannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannerCellReusableIdentifier forIndexPath:indexPath];
            [_bannerCell.contentView addSubview:_bannerView];
            {
                [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(_bannerCell.contentView);
                }];
            }
        }
        return _bannerCell;
    }
    
    JQKVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellReusableIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == JQKHomeSectionPhotos) {
        if (indexPath.item < self.albumModel.fetchedAlbums.count) {
            JQKChannel *channel = self.albumModel.fetchedAlbums[indexPath.item];
            cell.imageURL = [NSURL URLWithString:channel.CoverURL];
            cell.title = channel.Name;
            cell.isVIP = NO;
        }
    } else {
        JQKVideoListModel *videoModel = self.videoModels[@(indexPath.section)];
        if (indexPath.item < videoModel.fetchedVideos.Videos.count) {
            JQKVideo *video = videoModel.fetchedVideos.Videos[indexPath.item];
            cell.imageURL = [NSURL URLWithString:video.coverUrl];
            cell.title = video.Name;
            cell.isVIP = video.Vip.boolValue;
        }
    }

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return JQKHomeSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section < JQKHomeSectionPhotos) {
        return self.videoModels[@(section)].fetchedVideos.Videos.count;
    } else if (section == JQKHomeSectionPhotos) {
        return self.albumModel.fetchedAlbums.count;
    } else {
        return 0;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    JQKHomeSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHomeSectionHeaderReusableIdentifier forIndexPath:indexPath];
    switch (indexPath.section) {
        case JQKHomeSectionTrial:
            headerView.title = @"试看专区";
            headerView.titleColor = [UIColor colorWithHexString:@"#55ffff"];
            break;
        case JQKHomeSectionVIP:
            headerView.title = @"VIP贵宾区";
            headerView.titleColor = [UIColor redColor];
            break;
        case JQKHomeSectionMeitui:
            headerView.title = @"美腿丝袜";
            headerView.titleColor = [UIColor colorWithHexString:@"#8ab337"];
            break;
        case JQKHomeSectionNvyou:
            headerView.title = @"女优秀场";
            headerView.titleColor = [UIColor colorWithHexString:@"#91bc4c"];
            break;
        case JQKHomeSectionPhotos:
            headerView.title = @"美女图集";
            headerView.titleColor = [UIColor colorWithHexString:@"#e8851c"];
            break;
        default:
            headerView.title = nil;
            break;
    }
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JQKHomeSectionBanner) {
        return ;
    } else if (indexPath.section < JQKHomeSectionPhotos) {
        JQKVideoListModel *videoModel = self.videoModels[@(indexPath.section)];
        if (indexPath.item < videoModel.fetchedVideos.Videos.count) {
            JQKVideo *video = videoModel.fetchedVideos.Videos[indexPath.item];
            if (indexPath.section == JQKHomeSectionTrial) {
                [self switchToPlayVideo:video];
            } else {
                JQKVideoDetailViewController *videoVC = [[JQKVideoDetailViewController alloc] initWithVideo:video];
                [self.navigationController pushViewController:videoVC animated:YES];
            }
        }
    } else if (indexPath.section == JQKHomeSectionPhotos) {
        if (indexPath.item < self.albumModel.fetchedAlbums.count) {
            JQKChannel *album = self.albumModel.fetchedAlbums[indexPath.item];
            JQKPhotoListViewController *photoVC = [[JQKPhotoListViewController alloc] initWithPhotoAlbum:album];
            [self.navigationController pushViewController:photoVC animated:YES];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    if (indexPath.section == 0 && indexPath.item == 0) {
        return CGSizeMake(fullWidth, fullWidth/2);
    } else {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
        UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
        const CGFloat width = (fullWidth - layout.minimumInteritemSpacing - insets.left - insets.right)/2;
        const CGFloat height = [JQKVideoCell heightRelativeToWidth:width landscape:YES];
        return CGSizeMake(width, height);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return section == 0 ? UIEdgeInsetsMake(0,0,5,0) : UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeZero;
    }
    
    UIEdgeInsets insets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    return CGSizeMake(CGRectGetWidth(collectionView.bounds)-insets.left-insets.right, 30);
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    JQKVideoListModel *videoModel = self.videoModels[@(JQKHomeSectionBanner)];
    if (index < videoModel.fetchedVideos.Videos.count) {
        JQKVideo *bannerVideo = videoModel.fetchedVideos.Videos[index];
        JQKVideoDetailViewController *videoVC = [[JQKVideoDetailViewController alloc] initWithVideo:bannerVideo];
        [self.navigationController pushViewController:videoVC animated:YES];
    }
}
@end

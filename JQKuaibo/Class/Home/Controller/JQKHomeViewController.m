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
#import "JQKChannelModel.h"

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
//@property (nonatomic,retain) NSMutableDictionary<NSNumber *, JQKVideoListModel *> *videoModels;
@property (nonatomic,retain) JQKChannelModel *channels;
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

- (JQKChannelModel *)channels {
    if (_channels) {
        return _channels;
    }
    _channels = [[JQKChannelModel alloc] init];
    
    return _channels;
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
    

    [self.channels fetchHomeChannelsWithCompletionHandler:^(BOOL success, id obj) {
        if (success) {
            @strongify(self);
            [_layoutCollectionView JQK_endPullToRefresh];
            
            [self refreshBannerView];
            
            [_layoutCollectionView reloadData];
        }
    }];
}

- (void)refreshBannerView {
    NSMutableArray *imageUrlGroup = [NSMutableArray array];
    NSMutableArray *titlesGroup = [NSMutableArray array];
    
    for (JQKChannel *channel in _channels.fetchedChannels) {
        if (channel.type == 4) {
            for (JQKVideo *bannerVideo in channel.programList) {
                [imageUrlGroup addObject:bannerVideo.coverImg];
                [titlesGroup addObject:bannerVideo.title];
            }
            _bannerView.imageURLStringsGroup = imageUrlGroup;
            _bannerView.titlesGroup = titlesGroup;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JQKVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellReusableIdentifier forIndexPath:indexPath];
    
    JQKChannel *channel = _channels.fetchedChannels[indexPath.section];
    if (channel.type == 4) {
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
    } else {
        if (indexPath.item < channel.programList.count) {
            JQKVideo *video = channel.programList[indexPath.item];
            cell.imageURL = [NSURL URLWithString:video.coverImg];
            cell.title = video.title;
            [cell setVipLabel:video.spec];
        }
    }
//    } else if (channel.type == 1) {
//        if (indexPath.item < channel.programList.count) {
//            JQKVideo *video = channel.programList[indexPath.item];
//            cell.imageURL = [NSURL URLWithString:video.coverImg];
//            cell.title = video.title;
//            [cell setVIP:video.spec];
//        }
//    } else if (channel.type == 2) {
//        if (indexPath.item < channel.programList.count) {
//            JQKVideo
//        }
//    }

//    return cell;
    
//    if (indexPath.section == 0) {
//        if (!_bannerCell) {
//            _bannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannerCellReusableIdentifier forIndexPath:indexPath];
//            [_bannerCell.contentView addSubview:_bannerView];
//            {
//                [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.edges.equalTo(_bannerCell.contentView);
//                }];
//            }
//        }
//        return _bannerCell;
//    }
//    
//    JQKVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellReusableIdentifier forIndexPath:indexPath];
//    
//    if (indexPath.section == JQKHomeSectionPhotos) {
//        if (indexPath.item < self.albumModel.fetchedAlbums.count) {
//            JQKChannel *channel = self.albumModel.fetchedAlbums[indexPath.item];
//            cell.imageURL = [NSURL URLWithString:channel.columnImg];
//            cell.title = channel.name;
//            cell.isVIP = NO;
//        }
//    } else {
//        JQKVideoListModel *videoModel = self.videoModels[@(indexPath.section)];
//        if (indexPath.item < videoModel.fetchedVideos.programList.count) {
//            JQKVideo *video = videoModel.fetchedVideos.programList[indexPath.item];
//            cell.imageURL = [NSURL URLWithString:video.videoUrl];
//            cell.title = video.title;
//            cell.isVIP = video.VIP.boolValue;
//        }
//    }

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _channels.fetchedChannels.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    JQKChannel *channel = _channels.fetchedChannels[section];
    if (channel.type == 4) {
        return 1;
    } else if (channel.type == 1 || channel.type == 2 || channel.type == 3 || channel.type == 5) {
        return channel.programList.count;
    } else {
        return 0;
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    JQKHomeSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHomeSectionHeaderReusableIdentifier forIndexPath:indexPath];
    
    JQKChannel *channel = _channels.fetchedChannels[indexPath.section];
    headerView.title = channel.name;
    
    NSArray *colors = @[@"#55ffff",@"#8ab337",@"#91bc4c",@"#d63b32",@"#e8851c"];
    headerView.titleColor = [UIColor colorWithHexString:colors[indexPath.section % colors.count]];
    
//    if ([channel.name isEqualToString:@"试看专区"]) {
//        headerColor = [UIColor colorWithHexString:@"#55ffff"];
//    } else if ([channel.name isEqualToString:@"VIP贵宾区"]) {
//        headerColor = [UIColor redColor];
//    } else if ([channel.name isEqualToString:@"美腿丝袜"]) {
//        headerColor = [UIColor colorWithHexString:@"#8ab337"];
//    } else if ([channel.name isEqualToString:@"女优秀场"]) {
//        headerColor = [UIColor colorWithHexString:@"#91bc4c"];
//    } else if ([channel.name isEqualToString:@"美女图集"]) {
//        headerColor = [UIColor colorWithHexString:@"#e8851c"];
//    } else {
//        headerView.title = nil;
//    }
//    
    
//    switch (indexPath.section) {
//        case JQKHomeSectionTrial:
//            headerView.title = @"试看专区";
//            headerView.titleColor = [UIColor colorWithHexString:@"#55ffff"];
//            break;
//        case JQKHomeSectionVIP:
//            headerView.title = @"VIP贵宾区";
//            headerView.titleColor = [UIColor redColor];
//            break;
//        case JQKHomeSectionMeitui:
//            headerView.title = @"美腿丝袜";
//            headerView.titleColor = [UIColor colorWithHexString:@"#8ab337"];
//            break;
//        case JQKHomeSectionNvyou:
//            headerView.title = @"女优秀场";
//            headerView.titleColor = [UIColor colorWithHexString:@"#91bc4c"];
//            break;
//        case JQKHomeSectionPhotos:
//            headerView.title = @"美女图集";
//            headerView.titleColor = [UIColor colorWithHexString:@"#e8851c"];
//            break;
//        default:
//            headerView.title = nil;
//            break;
//    }
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JQKChannel *channel = _channels.fetchedChannels[indexPath.section];
    JQKVideo *video = channel.programList[indexPath.item];
    if (channel.type == 4) {
        return;
    } else if (channel.type == 5) {
        [self switchToPlayVideo:channel.programList[indexPath.item]];
    } else if (channel.type == 1 || channel.type == 3) {
        if (indexPath.item < channel.programList.count) {
            JQKVideoDetailViewController *videoVC = [[JQKVideoDetailViewController alloc] initWithVideo:video columnId:channel.columnId];
            [self.navigationController pushViewController:videoVC animated:YES];
        }
    } else if (channel.type == 2) {
        if (indexPath.item < channel.programList.count) {
            JQKPhotoListViewController *photoVC = [[JQKPhotoListViewController alloc] initWithPhotoAlbum:video];
            [self.navigationController pushViewController:photoVC animated:YES];
        }
    }
//    if (indexPath.section == JQKHomeSectionBanner) {
//        return ;
//    } else if (indexPath.section < JQKHomeSectionPhotos) {
//        JQKVideoListModel *videoModel = self.videoModels[@(indexPath.section)];
//        if (indexPath.item < videoModel.fetchedVideos.programList.count) {
//            JQKVideo *video = videoModel.fetchedVideos.programList[indexPath.item];
//            if (indexPath.section == JQKHomeSectionTrial) {
//                [self switchToPlayVideo:video];
//            } else {
//                JQKVideoDetailViewController *videoVC = [[JQKVideoDetailViewController alloc] initWithVideo:video];
//                [self.navigationController pushViewController:videoVC animated:YES];
//            }
//        }
//    } else if (indexPath.section == JQKHomeSectionPhotos) {
//        if (indexPath.item < self.albumModel.fetchedAlbums.count) {
//            JQKChannel *album = self.albumModel.fetchedAlbums[indexPath.item];
//            JQKPhotoListViewController *photoVC = [[JQKPhotoListViewController alloc] initWithPhotoAlbum:album];
//            [self.navigationController pushViewController:photoVC animated:YES];
//        }
//    }
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
    for (JQKChannel *channel in _channels.fetchedChannels) {
        if (channel.type == 4) {
            if (index < channel.programList.count) {
                JQKVideo *bannerVideo = channel.programList[index];
                if (bannerVideo.type == 5) {
                    JQKVideoDetailViewController *videoVC = [[JQKVideoDetailViewController alloc] initWithVideo:bannerVideo columnId:channel.columnId];
                    [self.navigationController pushViewController:videoVC animated:YES];
                } else if (bannerVideo.type == 1) {
                    JQKVideoDetailViewController *videoVC = [[JQKVideoDetailViewController alloc] initWithVideo:bannerVideo columnId:channel.columnId];
                    [self.navigationController pushViewController:videoVC animated:YES];
                } else if (bannerVideo.type == 3) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:bannerVideo.videoUrl]];
                }
            }
        }
    }
    
//    JQKVideoListModel *videoModel = self.videoModels[@(JQKHomeSectionBanner)];
//    if (index < videoModel.fetchedVideos.programList.count) {
//        JQKVideo *bannerVideo = videoModel.fetchedVideos.programList[index];
//        JQKVideoDetailViewController *videoVC = [[JQKVideoDetailViewController alloc] initWithVideo:bannerVideo];
//        [self.navigationController pushViewController:videoVC animated:YES];
//    }
}
@end

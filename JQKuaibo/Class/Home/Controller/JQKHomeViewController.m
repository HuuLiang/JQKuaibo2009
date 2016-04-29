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
@property (nonatomic) NSMutableArray *dataSource;
//@property (nonatomic,retain) JQKPhotoAlbumModel *albumModel;
@property (nonatomic,retain) dispatch_group_t dataDispatchGroup;
@end

@implementation JQKHomeViewController

//DefineLazyPropertyInitialization(JQKPhotoAlbumModel, albumModel)

//- (dispatch_group_t)dataDispatchGroup {
//    if (_dataDispatchGroup) {
//        return _dataDispatchGroup;
//    }
//    
//    _dataDispatchGroup = dispatch_group_create();
//    return _dataDispatchGroup;
//}

- (JQKChannelModel *)channels {
    if (_channels) {
        return _channels;
    }
    _channels = [[JQKChannelModel alloc] init];
    
    return _channels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc] init];
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
        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:_channels.fetchedChannels];
        if (success) {
            @strongify(self);
            [self.channels fetchPhotosWithCompletionHandler:^(BOOL success, id obj) {
                if (success) {
                    JQKChannel * channel = [[JQKChannel alloc] init];
                    channel.name = @"美女图集";
                    channel.type = 2;
                    channel.programList = _channels.fetchPhotos;
                    [_dataSource addObject:channel];
                }
                [self loadHomeData];
            }];
        } else {
            [self loadHomeData];
        }
    }];
}

- (void)loadHomeData {
    [_layoutCollectionView JQK_endPullToRefresh];
    [self refreshBannerView];
    [_layoutCollectionView reloadData];
}

- (void)refreshBannerView {
    NSMutableArray *imageUrlGroup = [NSMutableArray array];
    NSMutableArray *titlesGroup = [NSMutableArray array];
    
    for (JQKChannel *channel in _dataSource) {
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
    
    JQKChannel *channel = _dataSource[indexPath.section];
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
    } else if (channel.type == 1 || channel.type == 3 || channel.type ==5) {
        if (indexPath.item < channel.programList.count) {
            JQKVideo *video = channel.programList[indexPath.item];
            cell.imageURL = [NSURL URLWithString:video.coverImg];
            cell.title = video.title;
            [cell setVipLabel:video.spec];
        }
    } else if (channel.type == 2) {
        if (indexPath.item < channel.programList.count) {
            JQKChannel *photoChannel = channel.programList[indexPath.item];
            cell.imageURL = [NSURL URLWithString:photoChannel.columnImg];
            cell.title = photoChannel.name;
            [cell setVipLabel:6];
        }
    }


    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    JQKChannel *channel = _dataSource[section];
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
    
    JQKChannel *channel = _dataSource[indexPath.section];
    headerView.title = channel.name;
    
    NSArray *colors = @[@"#55ffff",@"#8ab337",@"#91bc4c",@"#d63b32",@"#e8851c"];
    headerView.titleColor = [UIColor colorWithHexString:colors[indexPath.section % colors.count]];
    

    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JQKChannel *channel = _dataSource[indexPath.section];
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
            JQKChannel *photoChannel = channel.programList[indexPath.item];
            JQKPhotoListViewController *photoVC = [[JQKPhotoListViewController alloc] initWithPhotoAlbum:photoChannel];
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
}
@end

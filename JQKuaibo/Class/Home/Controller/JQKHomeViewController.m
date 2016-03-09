//
//  JQKHomeViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKHomeViewController.h"
#import "JQKHomeCollectionViewLayout.h"
#import "JQKHomeCell.h"
#import "JQKChannelModel.h"
#import "JQKProgramViewController.h"
#import "JQKAdView.h"
#import "JQKSystemConfigModel.h"
#import <SDCycleScrollView.h>
#import "JQKHomeVideoProgramModel.h"

static NSString *const kHomeCellReusableIdentifier = @"HomeCellReusableIdentifier";
static NSString *const kBannerCellReusableIdentifier = @"BannerCellReusableIdentifier";

static const NSUInteger kFreeVideoItemOffset = 1;
static const NSUInteger kChannelItemOffset = 3;

@interface JQKHomeViewController () <UICollectionViewDataSource,UICollectionViewDelegate,JQKHomeCollectionViewLayoutDelegate,SDCycleScrollViewDelegate>
{
    UICollectionView *_layoutCollectionView;
    
    UICollectionViewCell *_bannerCell;
    SDCycleScrollView *_bannerView;
}
@property (nonatomic,retain) JQKChannelModel *channelModel;
@property (nonatomic,retain) JQKHomeVideoProgramModel *videoModel;
@property (nonatomic,retain) JQKAdView *leftAdView;
@property (nonatomic,retain) JQKAdView *rightAdView;
@property (nonatomic,retain) dispatch_group_t dataDispatchGroup;
@end

@implementation JQKHomeViewController

DefineLazyPropertyInitialization(JQKChannelModel, channelModel)
DefineLazyPropertyInitialization(JQKHomeVideoProgramModel, videoModel)

- (dispatch_group_t)dataDispatchGroup {
    if (_dataDispatchGroup) {
        return _dataDispatchGroup;
    }
    
    _dataDispatchGroup = dispatch_group_create();
    return _dataDispatchGroup;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _bannerView = [[SDCycleScrollView alloc] init];
    _bannerView.autoScrollTimeInterval = 3;
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _bannerView.delegate = self;
    _bannerView.backgroundColor = [UIColor whiteColor];
    
    JQKHomeCollectionViewLayout *layout = [[JQKHomeCollectionViewLayout alloc] init];
    layout.interItemSpacing = 8;
    layout.delegate = self;
    
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = [UIColor whiteColor];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    [_layoutCollectionView registerClass:[JQKHomeCell class] forCellWithReuseIdentifier:kHomeCellReusableIdentifier];
    [_layoutCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kBannerCellReusableIdentifier];
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(layout.interItemSpacing, layout.interItemSpacing, layout.interItemSpacing, layout.interItemSpacing));
        }];
    }
    
    @weakify(self);
    [_layoutCollectionView JQK_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadChannels];
    }];
    [_layoutCollectionView JQK_triggerPullToRefresh];
    
    [self loadAds];
}

- (void)loadChannels {
    @weakify(self);
    dispatch_group_enter(self.dataDispatchGroup);
    [self.channelModel fetchChannelsWithCompletionHandler:^(BOOL success, NSArray<JQKChannel *> *channels) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        dispatch_group_leave(self.dataDispatchGroup);
    }];
    
    dispatch_group_enter(self.dataDispatchGroup);
    [self.videoModel fetchProgramsWithCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        dispatch_group_leave(self.dataDispatchGroup);
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

- (void)loadAds {
    void (^AdBlock)(void) = ^{
        if ([JQKSystemConfigModel sharedModel].spreadLeftImage.length > 0) {
            [self.view addSubview:self.leftAdView];
            {
                [self.leftAdView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.centerY.equalTo(self.view);
                    make.width.equalTo(self.view).dividedBy(4);
                    make.height.equalTo(self.leftAdView.mas_width).multipliedBy(3);
                }];
            }
        } else if (_leftAdView) {
            [self.leftAdView removeFromSuperview];
            self.leftAdView = nil;
        }
        
        if ([JQKSystemConfigModel sharedModel].spreadRightImage.length > 0) {
            [self.view addSubview:self.rightAdView];
            {
                [self.rightAdView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.centerY.equalTo(self.view);
                    make.width.equalTo(self.view).dividedBy(4);
                    make.height.equalTo(self.rightAdView.mas_width).multipliedBy(3);
                }];
            }
        } else if (_rightAdView) {
            [self.rightAdView removeFromSuperview];
            self.rightAdView = nil;
        }
    };
    
    if ([JQKSystemConfigModel sharedModel].loaded) {
        AdBlock();
    } else {
        [[JQKSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
            if (success) {
                AdBlock();
            }
        }];
    }
}

- (void)refreshBannerView {
    NSMutableArray *imageUrlGroup = [NSMutableArray array];
    NSMutableArray *titlesGroup = [NSMutableArray array];
    for (JQKProgram *bannerProgram in self.videoModel.fetchedBannerPrograms) {
        [imageUrlGroup addObject:bannerProgram.coverImg];
        [titlesGroup addObject:bannerProgram.title];
    }
    _bannerView.imageURLStringsGroup = imageUrlGroup;
    _bannerView.titlesGroup = titlesGroup;
}

- (JQKAdView *)leftAdView {
    if (_leftAdView) {
        return _leftAdView;
    }
    
    _leftAdView = [[JQKAdView alloc] initWithImageURL:[NSURL URLWithString:[JQKSystemConfigModel sharedModel].spreadLeftImage]
                                                adURL:[NSURL URLWithString:[JQKSystemConfigModel sharedModel].spreadLeftUrl]];
    @weakify(self);
    _leftAdView.closeAction = ^(id obj) {
        @strongify(self);
        
        [self.leftAdView removeFromSuperview];
        self.leftAdView = nil;
    };
    return _leftAdView;
}

- (JQKAdView *)rightAdView {
    if (_rightAdView) {
        return _rightAdView;
    }
    
    _rightAdView = [[JQKAdView alloc] initWithImageURL:[NSURL URLWithString:[JQKSystemConfigModel sharedModel].spreadRightImage]
                                                adURL:[NSURL URLWithString:[JQKSystemConfigModel sharedModel].spreadRightUrl]];
    @weakify(self);
    _rightAdView.closeAction = ^(id obj) {
        @strongify(self);
        
        [self.rightAdView removeFromSuperview];
        self.rightAdView = nil;
    };
    return _rightAdView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
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
    
    JQKHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellReusableIdentifier forIndexPath:indexPath];
    
    if (indexPath.item < kChannelItemOffset) {
        NSUInteger item = indexPath.item - 1;
        if (item < self.videoModel.fetchedVideoPrograms.count) {
            JQKProgram *program = self.videoModel.fetchedVideoPrograms[indexPath.item-1];
            cell.imageURL = [NSURL URLWithString:program.coverImg];
        }
    } else {
        NSUInteger item = indexPath.item - kChannelItemOffset;
        if (item < self.channelModel.fetchedChannels.count) {
            JQKChannel *channel = self.channelModel.fetchedChannels[item];
            cell.imageURL = [NSURL URLWithString:channel.columnImg];
            //    cell.title = channel.name;
            //    cell.subtitle = channel.columnDesc;
        }
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.channelModel.fetchedChannels.count + kChannelItemOffset;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < kFreeVideoItemOffset) {
        return ;
    }
    
    if (indexPath.item >= kFreeVideoItemOffset && indexPath.item < kChannelItemOffset) {
        if (indexPath.item - kFreeVideoItemOffset < self.videoModel.fetchedVideoPrograms.count) {
            JQKProgram *program = self.videoModel.fetchedVideoPrograms[indexPath.item - kFreeVideoItemOffset];
            [self playVideo:program withTimeControl:NO shouldPopPayment:YES];
        }
    } else if (indexPath.item - kChannelItemOffset < self.channelModel.fetchedChannels.count) {
        JQKChannel *selectedChannel = self.channelModel.fetchedChannels[indexPath.item - kChannelItemOffset];
        
        if (selectedChannel.type.unsignedIntegerValue == JQKChannelTypeSpread) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:selectedChannel.spreadUrl]];
        } else {
            JQKProgramViewController *programVC = [[JQKProgramViewController alloc] initWithChannel:selectedChannel];
            UINavigationController *programNav = [[UINavigationController alloc] initWithRootViewController:programVC];
            [self presentViewController:programNav animated:NO completion:nil];
        }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout hasAdBannerForItem:(NSUInteger)item {
    if (item >= kChannelItemOffset && item-kChannelItemOffset < self.channelModel.fetchedChannels.count) {
        JQKChannel *channel = self.channelModel.fetchedChannels[item-kChannelItemOffset];
        return channel.type.unsignedIntegerValue == JQKChannelTypeSpread && channel.spreadUrl.length > 0;
    }
    return NO;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    JQKProgram *bannerProgram = self.videoModel.fetchedBannerPrograms[index];
    if (bannerProgram.type.unsignedIntegerValue == JQKProgramTypeVideo) {
        [self switchToPlayProgram:bannerProgram];
    } else if (bannerProgram.type.unsignedIntegerValue == JQKProgramTypeSpread) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:bannerProgram.videoUrl]];
    }
}
@end

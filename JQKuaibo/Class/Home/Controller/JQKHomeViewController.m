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

static NSString *const kHomeCellReusableIdentifier = @"HomeCellReusableIdentifier";

@interface JQKHomeViewController () <UICollectionViewDataSource,UICollectionViewDelegate,JQKHomeCollectionViewLayoutDelegate>
{
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic,retain) JQKChannelModel *channelModel;
@property (nonatomic,retain) JQKAdView *leftAdView;
@property (nonatomic,retain) JQKAdView *rightAdView;
@end

@implementation JQKHomeViewController

DefineLazyPropertyInitialization(JQKChannelModel, channelModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    JQKHomeCollectionViewLayout *layout = [[JQKHomeCollectionViewLayout alloc] init];
    layout.interItemSpacing = 8;
    layout.delegate = self;
    
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = [UIColor whiteColor];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    [_layoutCollectionView registerClass:[JQKHomeCell class] forCellWithReuseIdentifier:kHomeCellReusableIdentifier];
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
    [self.channelModel fetchChannelsWithCompletionHandler:^(BOOL success, NSArray<JQKChannel *> *channels) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutCollectionView JQK_endPullToRefresh];
        
        if (success) {
            [self->_layoutCollectionView reloadData];
        }
    }];
}

- (void)loadAds {
    @weakify(self);
    [[JQKSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (success) {
            if ([JQKSystemConfig sharedConfig].spreadLeftImage.length > 0) {
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
            
            if ([JQKSystemConfig sharedConfig].spreadRightImage.length > 0) {
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
        }
    }];
}

- (JQKAdView *)leftAdView {
    if (_leftAdView) {
        return _leftAdView;
    }
    
    _leftAdView = [[JQKAdView alloc] initWithImageURL:[NSURL URLWithString:[JQKSystemConfig sharedConfig].spreadLeftImage]
                                                adURL:[NSURL URLWithString:[JQKSystemConfig sharedConfig].spreadLeftUrl]];
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
    
    _rightAdView = [[JQKAdView alloc] initWithImageURL:[NSURL URLWithString:[JQKSystemConfig sharedConfig].spreadRightImage]
                                                adURL:[NSURL URLWithString:[JQKSystemConfig sharedConfig].spreadRightUrl]];
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
    JQKHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellReusableIdentifier forIndexPath:indexPath];
    
    if (indexPath.item < self.channelModel.fetchedChannels.count) {
        JQKChannel *channel = self.channelModel.fetchedChannels[indexPath.item];
        cell.imageURL = [NSURL URLWithString:channel.columnImg];
//    cell.title = channel.name;
//    cell.subtitle = channel.columnDesc;
    }

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.channelModel.fetchedChannels.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.channelModel.fetchedChannels.count) {
        JQKChannel *selectedChannel = self.channelModel.fetchedChannels[indexPath.item];
        
        if (selectedChannel.type.unsignedIntegerValue == JQKChannelTypeBanner) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:selectedChannel.spreadUrl]];
        } else {
            JQKProgramViewController *programVC = [[JQKProgramViewController alloc] initWithChannel:selectedChannel];
            UINavigationController *programNav = [[UINavigationController alloc] initWithRootViewController:programVC];
            [self presentViewController:programNav animated:NO completion:nil];
        }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout hasAdBannerForItem:(NSUInteger)item {
    if (item < self.channelModel.fetchedChannels.count) {
        JQKChannel *channel = self.channelModel.fetchedChannels[item];
        return channel.type.unsignedIntegerValue == JQKChannelTypeBanner && channel.spreadUrl.length > 0;
    }
    return NO;
}
@end

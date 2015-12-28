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

static NSString *const kHomeCellReusableIdentifier = @"HomeCellReusableIdentifier";

@interface JQKHomeViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic,retain) JQKChannelModel *channelModel;
@end

@implementation JQKHomeViewController

DefineLazyPropertyInitialization(JQKChannelModel, channelModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    JQKHomeCollectionViewLayout *layout = [[JQKHomeCollectionViewLayout alloc] init];
    layout.interItemSpacing = 5;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JQKHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellReusableIdentifier forIndexPath:indexPath];
    
    JQKChannel *channel = self.channelModel.fetchedChannels[indexPath.item];
    cell.imageURL = [NSURL URLWithString:channel.columnImg];
//    cell.title = channel.name;
//    cell.subtitle = channel.columnDesc;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.channelModel.fetchedChannels.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JQKChannel *selectedChannel = self.channelModel.fetchedChannels[indexPath.item];
    
    JQKProgramViewController *programVC = [[JQKProgramViewController alloc] initWithChannel:selectedChannel];
    UINavigationController *programNav = [[UINavigationController alloc] initWithRootViewController:programVC];
    [self presentViewController:programNav animated:NO completion:nil];
}
@end

//
//  JQKHotVideoViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKHotVideoViewController.h"
#import "JQKHotVideoModel.h"
#import "JQKHotVideoCell.h"
#import "JQKSystemConfigModel.h"

static NSString *const kHotVideoCellReusableIdentifier = @"HotVideoCellReusableIdentifier";

@interface JQKHotVideoViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_headerImageView;
    UILabel *_priceLabel;
    
    UITableView *_layoutTableView;
}
@property (nonatomic,retain) JQKHotVideoModel *videoModel;
@property (nonatomic,retain) NSMutableArray<JQKProgram *> *videos;
@end

@implementation JQKHotVideoViewController

DefineLazyPropertyInitialization(JQKHotVideoModel, videoModel)
DefineLazyPropertyInitialization(NSMutableArray, videos)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (![JQKUtil isPaid]) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.userInteractionEnabled = YES;
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:14.];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [_headerImageView addSubview:_priceLabel];
        {
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_headerImageView);
                make.top.equalTo(_headerImageView.mas_centerY);
                make.width.equalTo(_headerImageView).multipliedBy(0.1);
                
            }];
        }
        
        @weakify(self);
        [_headerImageView bk_whenTapped:^{
            @strongify(self);
            if (![JQKUtil isPaid]) {
                [self payForProgram:nil];
            };
        }];
        [self.view addSubview:_headerImageView];
        {
            [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self.view);
                make.height.equalTo(_headerImageView.mas_width).multipliedBy(0.2);
            }];
        }
    }
    
    _layoutTableView = [[UITableView alloc] init];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.rowHeight = kScreenWidth*0.8;
    _layoutTableView.tableFooterView = [[UIView alloc] init];
    _layoutTableView.separatorColor = [UIColor blackColor];
    [_layoutTableView registerClass:[JQKHotVideoCell class] forCellReuseIdentifier:kHotVideoCellReusableIdentifier];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(_headerImageView?_headerImageView.mas_bottom:self.view);
        }];
    }
    
    @weakify(self);
    [_layoutTableView JQK_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadVideosWithPage:1];
        [self loadHeaderImage];
    }];
    [_layoutTableView JQK_triggerPullToRefresh];
    
    [_layoutTableView JQK_addPagingRefreshWithHandler:^{
        @strongify(self);
        
        NSUInteger currentPage = self.videoModel.fetchedVideos.page.unsignedIntegerValue;
        [self loadVideosWithPage:currentPage+1];
    }];
}

- (void)loadHeaderImage {
    if ([JQKUtil isPaid]) {
        return ;
    }
    
    @weakify(self);
    JQKSystemConfigModel *systemConfigModel = [JQKSystemConfigModel sharedModel];
    [systemConfigModel fetchSystemConfigWithCompletionHandler:^(BOOL success) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (success) {
            @weakify(self);
            [self->_headerImageView sd_setImageWithURL:[NSURL URLWithString:systemConfigModel.channelTopImage]
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
            {
                @strongify(self);
                if (!self) {
                    return ;
                }
                
                if (image) {
                    double showPrice = systemConfigModel.payAmount;
                    BOOL showInteger = (NSUInteger)(showPrice * 100) % 100 == 0;
                    self->_priceLabel.text = showInteger ? [NSString stringWithFormat:@"%ld", (NSUInteger)showPrice] : [NSString stringWithFormat:@"%.2f", showPrice];
                } else {
                    self->_priceLabel.text = nil;
                }
            }];
        }
    }];
    
}

- (void)onPaidNotification:(NSNotification *)notification {
    [_headerImageView removeFromSuperview];
    _headerImageView = nil;
    
    [_layoutTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadVideosWithPage:(NSUInteger)page {
    @weakify(self);
    [self.videoModel fetchVideosWithPageNo:page completionHandler:^(BOOL success, JQKVideos *videos) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutTableView JQK_endPullToRefresh];
        
        if (success) {
            if (page == 1) {
                [self.videos removeAllObjects];
            }
            [self.videos addObjectsFromArray:videos.programList];
            [self->_layoutTableView reloadData];
            
            if (videos.items.unsignedIntegerValue == self.videos.count) {
                [self->_layoutTableView JQK_pagingRefreshNoMoreData];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JQKHotVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:kHotVideoCellReusableIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.videos.count) {
        JQKProgram *video = self.videos[indexPath.row];
        cell.imageURL = [NSURL URLWithString:video.coverImg];
        cell.title = video.title;
        //cell.subtitle = video.specialDesc;
        
//        @weakify(self);
//        cell.playAction = ^{
//            @strongify(self);
//            [self switchToPlayProgram:video];
//        };
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}
@end

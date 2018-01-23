//
//  JQKMoreViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKMoreViewController.h"
#import "JQKAppSpreadModel.h"
#import "JQKMoreCell.h"

static NSString *const kMoreCellReusableIdentifier = @"MoreCellReusableIdentifier";

@interface JQKMoreViewController () <UITableViewDataSource,UITableViewSeparatorDelegate>
{
    UITableView *_layoutTableView;
}
@property (nonatomic,retain) JQKAppSpreadModel *spreadModel;
@end

@implementation JQKMoreViewController

DefineLazyPropertyInitialization(JQKAppSpreadModel, spreadModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _layoutTableView = [[UITableView alloc] init];
    _layoutTableView.backgroundColor = self.view.backgroundColor;
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.rowHeight = kScreenWidth * 0.4;
    _layoutTableView.separatorInset = UIEdgeInsetsZero;
    _layoutTableView.hasRowSeparator = YES;
    _layoutTableView.hasSectionBorder = YES;
    [_layoutTableView registerClass:[JQKMoreCell class]
             forCellReuseIdentifier:kMoreCellReusableIdentifier];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutTableView JQK_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadAppSpreads];
    }];
    [_layoutTableView JQK_triggerPullToRefresh];
}

- (void)loadAppSpreads {
    @weakify(self);
    [self.spreadModel fetchAppSpreadWithCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutTableView JQK_endPullToRefresh];
        
        if (success) {
            [self->_layoutTableView reloadData];
        }
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[JQKStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[JQKUtil currentSubTabPageIndex] forSlideCount:1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JQKMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kMoreCellReusableIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    if (!cell.backgroundView) {
    //        cell. = [[UIImageView alloc] init];
    //    }
    
    //    UIImageView *imageView = (UIImageView *)cell.backgroundView;
    
    if (indexPath.row < self.spreadModel.fetchedSpreads.count) {
        JQKAppSpread *appSpread = self.spreadModel.fetchedSpreads[indexPath.row];
        cell.imageURL = [NSURL URLWithString:appSpread.coverImg];
        [JQKUtil checkAppInstalledWithBundleId:appSpread.specialDesc completionHandler:^(BOOL installed) {
            if (installed) {
                cell.isInstalled = YES;
            }
        }];
        
    } else {
        cell.imageURL = nil;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.spreadModel.fetchedSpreads.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.spreadModel.fetchedSpreads.count) {
        JQKAppSpread *appSpread = self.spreadModel.fetchedSpreads[indexPath.row];
        if (appSpread.videoUrl.length > 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appSpread.videoUrl]];
        }
        [[JQKStatsManager sharedManager] statsCPCWithProgram:appSpread programLocation:indexPath.item inChannel:_spreadModel.fetchChannels andTabIndex:self.tabBarController.selectedIndex subTabIndex:[JQKUtil currentSubTabPageIndex]];
    }
}
@end

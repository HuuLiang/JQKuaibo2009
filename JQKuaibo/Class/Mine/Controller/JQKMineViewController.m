//
//  JQKMineViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKMineViewController.h"
#import "JQKMineTopBanner.h"
#import "JQKSystemConfigModel.h"
#import "JQKPaymentInfo.h"
#import "JQKMineCell.h"
#import "JQKVideo.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, JQKMineCellSection) {
    JQKMineTopCellSection,
    JQKMineChargeCellSection,
    JQKMineGoldCellSection,
    JQKMineHistoryCellSection,
    JQKMineCellSectionCount
};

static const void *kPlaceholderLabelAssociatedKey = &kPlaceholderLabelAssociatedKey;
static const void *kTitleLabelAssociatedKey = &kTitleLabelAssociatedKey;
static const void *kSubtitleLabelAssociatedKey = &kSubtitleLabelAssociatedKey;

static NSString *const kMineCellReusableIdentifier = @"MineCellReusableIdentifier";

@interface JQKMineViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_layoutTableView;
    
    JQKMineTopBanner *_topCell;
    UITableViewCell *_chargeCell;
    UITableViewCell *_goldCell;
    UITableViewCell *_historyCell;
}
@property (nonatomic,retain) NSArray<JQKVideo *> *allPlayedVideos;
@end

@implementation JQKMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _layoutTableView = [[UITableView alloc] init];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_layoutTableView registerClass:[JQKMineCell class] forCellReuseIdentifier:kMineCellReusableIdentifier];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.allPlayedVideos = [JQKVideo allPlayedVideos];
    [_layoutTableView reloadSections:[NSIndexSet indexSetWithIndex:JQKMineHistoryCellSection]
                    withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    JQKSystemConfigModel *sysConfigModel = [JQKSystemConfigModel sharedModel];
    if (sysConfigModel.payAmount) {
        _topCell.price = sysConfigModel.payAmount;
    } else {
        @weakify(self);
        [sysConfigModel fetchSystemConfigWithCompletionHandler:^(BOOL success) {
            @strongify(self);
            if (!self) {
                return ;
            }
            
            if (success) {
                self->_topCell.price = sysConfigModel.payAmount;
            }
        }];
    }
}

- (void)onPaidNotification:(NSNotification *)notification {
    [_layoutTableView reloadSections:[NSIndexSet indexSetWithIndex:JQKMineChargeCellSection]
                    withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return JQKMineCellSectionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JQKMineTopCellSection) {
        if (!_topCell) {
            _topCell = [[JQKMineTopBanner alloc] init];
            _topCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            @weakify(self);
            _topCell.payAction = ^{
                @strongify(self);
                if ([JQKUtil isPaid]) {
                    [[JQKHudManager manager] showHudWithText:@"您已经购买了终身VIP"];
                } else {
                    [self payForProgram:nil];
                }
            };
            
            _topCell.goToMovieAction = ^{
                @strongify(self);
                self.tabBarController.selectedIndex = 1;
            };
        }
        return _topCell;
    } else {
        JQKMineCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineCellReusableIdentifier forIndexPath:indexPath];

        if (indexPath.section == JQKMineChargeCellSection) {
            if ([JQKUtil isPaid]) {
                JQKPaymentInfo *paymentInfo = [JQKUtil successfulPaymentInfo];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:kDefaultDateFormat];
                
                NSDate *date = [dateFormatter dateFromString:paymentInfo.paymentTime];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString = [dateFormatter stringFromDate:date];
                
                cell.title = @"购买终身VIP";
                cell.subtitle = dateString;
            } else {
                cell.placeholder = @"您还未充值会员，您可以充值会员后观看所有影片";
            }
        } else if (indexPath.section == JQKMineGoldCellSection) {
            cell.placeholder = @"您还未下载任何应用，您可以免费下载应用后获得金币";
        } else if (indexPath.section == JQKMineHistoryCellSection) {
            if (self.allPlayedVideos.count == 0) {
                cell.placeholder = @"您还未播放任何影片，您可以免费获得金币后观看所有影片";
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                
                JQKVideo *playedVideo = self.allPlayedVideos[indexPath.row];
                cell.title = playedVideo.title;
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString = [dateFormatter stringFromDate:playedVideo.playedDate];
                cell.subtitle = dateString;
            }
        }
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == JQKMineHistoryCellSection) {
        if (self.allPlayedVideos.count == 0) {
            return 1;
        } else {
            return self.allPlayedVideos.count;
        }
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"充值记录";
    } else if (section == 2) {
        return @"获取金币记录";
    } else if (section == 3) {
        return @"观看影视记录";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JQKMineTopCellSection) {
        return 120;
    } else if (indexPath.section == JQKMineChargeCellSection) {
        return [JQKUtil isPaid] ? 44 : 120;
    } else if (indexPath.section == JQKMineGoldCellSection) {
        return 120;
    } else {
        return [JQKVideo allPlayedVideos].count > 0 ? 44 : 120;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JQKMineHistoryCellSection && self.allPlayedVideos.count > 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        JQKVideo *video = self.allPlayedVideos[indexPath.row];
        [self playVideo:video];
    }
}
@end

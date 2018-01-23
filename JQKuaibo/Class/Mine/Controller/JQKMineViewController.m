//
//  JQKMineViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/17.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKMineViewController.h"
#import "JQKInputTextViewController.h"
#import "JQKWebViewController.h"
#import "JQKVipCell.h"
#import "JQKSystemConfigModel.h"

static NSString *const kMineCellReusableIdentifier = @"MineCellReusableIdentifier";
static NSString *const kVipCellIdentifier = @"kvipcellidentifer";

typedef NS_ENUM(NSUInteger, JQKMineCellRow) {
//    JQKMineCellVip,
    JQKMineCellRowFeedback,
    JQKMineCellRowAgreement,
    JQKMineCellRowCount
};

@interface JQKMineViewController () <UITableViewDataSource,UITableViewSeparatorDelegate>
{
    UITableView *_layoutTableView;
}
@end

@implementation JQKMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = self.view.backgroundColor;
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
//    _layoutTableView.rowHeight = MAX(44, lround(kScreenHeight * 0.08));
    _layoutTableView.separatorColor = [UIColor lightGrayColor];
    _layoutTableView.hasRowSeparator = YES;
    _layoutTableView.hasSectionBorder = YES;
    [_layoutTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kMineCellReusableIdentifier];
    [_layoutTableView registerClass:[JQKVipCell class] forCellReuseIdentifier:kVipCellIdentifier];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self.navigationController.navigationBar bk_whenTouches:1 tapped:5 handler:^{
        NSString *baseURLString = [JQK_BASE_URL stringByReplacingCharactersInRange:NSMakeRange(0, JQK_BASE_URL.length-6) withString:@"******"];
        [[JQKHudManager manager] showHudWithText:[NSString stringWithFormat:@"Server:%@\nChannelNo:%@\nPackageCertificate:%@\npV:%@", baseURLString, JQK_CHANNEL_NO, JQK_PACKAGE_CERTIFICATE, JQK_REST_PV]];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPaidNotification) name:kPaidNotificationName object:nil];
    
}

- (void)onPaidNotification {
    [_layoutTableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineCellReusableIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        if (indexPath.row == JQKMineCellRowFeedback) {
            cell.imageView.image = [UIImage imageNamed:@"feedback"];
            cell.textLabel.text = @"联系客服";
        } else if (indexPath.row == JQKMineCellRowAgreement) {
            cell.imageView.image = [UIImage imageNamed:@"agreement"];
            cell.textLabel.text = @"用户协议";
        }
        return cell;
    }
    
    if ( indexPath.section == 0){
        if (indexPath.row == 0) {
            
            JQKVipCell *vipCell = [tableView dequeueReusableCellWithIdentifier:kVipCellIdentifier forIndexPath:indexPath];
            vipCell.memberTitle = [JQKUtil isPaid] ? @"VIP会员" :@"成为VIP会员";
            @weakify(self);
            if (!vipCell.memberAction) {
                vipCell.memberAction = ^(id sender){
                    @strongify(self);
                    if ([JQKUtil isPaid]) {
                        [[JQKHudManager manager] showHudWithText:@"您已经是会员，感谢您的观看！"];
                    }else {
                        
                        [self switchToPlayVideo:nil programLocation:0 inChannel:nil];
                    }
                };
                
            }
            return vipCell;
        }
        
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        
        return 20;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.item == 0) {
            return 200./667.*kScreenHeight;
        }
    }
    return MAX(44, lround(kScreenHeight * 0.08));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return JQKMineCellRowCount;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == JQKMineCellRowFeedback) {
        [self contactCustomerService];
//        JQKInputTextViewController *inputVC = [[JQKInputTextViewController alloc] init];
//        inputVC.completeButtonTitle = @"提交";
//        inputVC.title = cell.textLabel.text;
//        inputVC.limitedTextLength = 140;
//        inputVC.completionHandler = ^BOOL(id sender, NSString *text) {
//            [[JQKHudManager manager] showProgressInDuration:1];
//            
//            UIViewController *thisVC = sender;
//            [thisVC bk_performBlock:^(id obj) {
//                [[obj navigationController] popViewControllerAnimated:YES];
//                [[JQKHudManager manager] showHudWithText:@"感谢您的意见~~~"];
//            } afterDelay:1];
//            
//            return NO;
//        };
//        [self.navigationController pushViewController:inputVC animated:YES];
    } else if (indexPath.row == JQKMineCellRowAgreement) {
        NSString *urlString = [JQK_BASE_URL stringByAppendingString:[JQKUtil isPaid]?JQK_AGREEMENT_PAID_URL:JQK_AGREEMENT_NOTPAID_URL];
        JQKWebViewController *webVC = [[JQKWebViewController alloc] initWithURL:[NSURL URLWithString:urlString]];
        webVC.title = cell.textLabel.text;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)contactCustomerService {
    NSString *contactScheme = [JQKSystemConfigModel sharedModel].contactScheme;
    NSString *contactName = [JQKSystemConfigModel sharedModel].contactName;
    
    if (contactScheme.length == 0) {
        return ;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:nil
                                   message:[NSString stringWithFormat:@"是否联系客服%@？", contactName ?: @""]
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@[@"确认"]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         if (buttonIndex == 1) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:contactScheme]];
         }
     }];
}

@end

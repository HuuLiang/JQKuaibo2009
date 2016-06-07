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

static NSString *const kMineCellReusableIdentifier = @"MineCellReusableIdentifier";

typedef NS_ENUM(NSUInteger, JQKMineCellRow) {
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
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _layoutTableView.backgroundColor = self.view.backgroundColor;
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.rowHeight = MAX(44, lround(kScreenHeight * 0.08));
    _layoutTableView.hasRowSeparator = YES;
    _layoutTableView.hasSectionBorder = YES;
    [_layoutTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kMineCellReusableIdentifier];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineCellReusableIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == JQKMineCellRowFeedback) {
        cell.imageView.image = [UIImage imageNamed:@"feedback"];
        cell.textLabel.text = @"意见投诉";
    } else if (indexPath.row == JQKMineCellRowAgreement) {
        cell.imageView.image = [UIImage imageNamed:@"agreement"];
        cell.textLabel.text = @"用户协议";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return JQKMineCellRowCount;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == JQKMineCellRowFeedback) {
        JQKInputTextViewController *inputVC = [[JQKInputTextViewController alloc] init];
        inputVC.completeButtonTitle = @"提交";
        inputVC.title = cell.textLabel.text;
        inputVC.limitedTextLength = 140;
        inputVC.completionHandler = ^BOOL(id sender, NSString *text) {
            [[JQKHudManager manager] showProgressInDuration:1];
            
            UIViewController *thisVC = sender;
            [thisVC bk_performBlock:^(id obj) {
                [[obj navigationController] popViewControllerAnimated:YES];
                [[JQKHudManager manager] showHudWithText:@"感谢您的意见~~~"];
            } afterDelay:1];
            
            return NO;
        };
        [self.navigationController pushViewController:inputVC animated:YES];
    } else if (indexPath.row == JQKMineCellRowAgreement) {
        NSString *urlString = [JQK_BASE_URL stringByAppendingString:[JQKUtil isPaid]?JQK_AGREEMENT_PAID_URL:JQK_AGREEMENT_NOTPAID_URL];
        JQKWebViewController *webVC = [[JQKWebViewController alloc] initWithURL:[NSURL URLWithString:urlString]];
        webVC.title = cell.textLabel.text;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}
@end

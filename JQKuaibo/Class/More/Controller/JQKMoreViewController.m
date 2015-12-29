//
//  JQKMoreViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKMoreViewController.h"

@interface JQKMoreViewController () <UIWebViewDelegate>
{
    UIWebView *_webView;
}
@property (nonatomic,retain,readonly) NSURLRequest *urlRequest;
@end

@implementation JQKMoreViewController
@synthesize urlRequest = _urlRequest;

- (NSURLRequest *)urlRequest {
    if (_urlRequest) {
        return _urlRequest;
    }
    
    NSString *urlString = [JQK_BASE_URL stringByAppendingString:JQK_AGREEMENT_URL];
    _urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    return _urlRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    {
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self.navigationController.navigationBar bk_whenTouches:1 tapped:5 handler:^{
        [[JQKHudManager manager] showHudWithText:[NSString stringWithFormat:@"Server:%@\nChannelNo:%@\nPackageCertificate:%@", JQK_BASE_URL, JQK_CHANNEL_NO, JQK_PACKAGE_CERTIFICATE]];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_webView loadRequest:self.urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

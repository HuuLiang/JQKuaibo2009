//
//  JQKWebViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKBaseViewController.h"

@interface JQKWebViewController : JQKBaseViewController

@property (nonatomic) NSURL *url;

- (instancetype)initWithURL:(NSURL *)url;

@end

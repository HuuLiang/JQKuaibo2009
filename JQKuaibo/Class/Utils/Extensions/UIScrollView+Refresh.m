//
//  UIScrollView+Refresh.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/8.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <MJRefresh.h>

@implementation UIScrollView (Refresh)

- (void)JQK_addPullToRefreshWithHandler:(void (^)(void))handler {
    if (!self.header) {
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:handler];
        refreshHeader.lastUpdatedTimeLabel.hidden = YES;
        self.header = refreshHeader;
    }
}

- (void)JQK_triggerPullToRefresh {
    [self.header beginRefreshing];
}

- (void)JQK_endPullToRefresh {
    [self.header endRefreshing];
    [self.footer resetNoMoreData];
}

//- (void)JQK_addPagingRefreshWithHandler:(void (^)(void))handler {
//    if (!self.footer) {
//        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:handler];
//        self.footer = refreshFooter;
//    }
//}
- (void)JQK_addPagingRefreshWithIsChangeFooter:(BOOL)changeFooter withHandler:(void (^)(void))handler{
    if (!self.footer) {
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:handler];
        if (changeFooter && ![JQKUtil isPaid]) {
            [refreshFooter setTitle:@"⬆️成为VIP，上拉或者点击加载更多" forState:MJRefreshStateIdle];
        }
        
        self.footer = refreshFooter;
    }
}
- (void)JQK_pagingRefreshNoMoreData {
    [self.footer endRefreshingWithNoMoreData];
}
@end

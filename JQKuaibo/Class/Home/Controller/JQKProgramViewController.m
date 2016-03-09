//
//  JQKProgramViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKProgramViewController.h"
#import "JQKChannelProgramModel.h"
#import "JQKChannel.h"
#import "JQKChannelProgram.h"
#import "JQKProgramCell.h"

static const NSUInteger kDefaultPageSize = 20;
static NSString *const kProgramCellReusableIdentifier = @"ProgramCellReusableIdentifier";

@interface JQKProgramViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_layoutTableView;
}
@property (nonatomic,retain) JQKChannelProgramModel *programModel;
@property (nonatomic,retain) NSMutableArray<JQKProgram *> *programs;
@property (nonatomic) NSUInteger currentPage;
@end

@implementation JQKProgramViewController

DefineLazyPropertyInitialization(JQKChannelProgramModel, programModel)
DefineLazyPropertyInitialization(NSMutableArray, programs)

- (instancetype)initWithChannel:(JQKChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.channel.name;
    
    _layoutTableView = [[UITableView alloc] init];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.backgroundColor = [UIColor colorWithWhite:0.05 alpha:1];
    _layoutTableView.separatorColor = [UIColor colorWithWhite:0.5 alpha:1];
    _layoutTableView.rowHeight = kScreenHeight * 0.18;
    _layoutTableView.tableFooterView = [[UIView alloc] init];
    [_layoutTableView registerClass:[JQKProgramCell class] forCellReuseIdentifier:kProgramCellReusableIdentifier];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutTableView JQK_addPullToRefreshWithHandler:^{
        @strongify(self);
        
        self.currentPage = 0;
        [self.programs removeAllObjects];
        [self loadPrograms];
    }];
    [_layoutTableView JQK_triggerPullToRefresh];
    
    [_layoutTableView JQK_addPagingRefreshWithHandler:^{
        @strongify(self);
        [self loadPrograms];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"返回"
                                                                                style:UIBarButtonItemStylePlain
                                                                              handler:^(id sender)
    {
        @strongify(self);
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }];
    [self.navigationItem.leftBarButtonItem setTitlePositionAdjustment:UIOffsetMake(5, 0) forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.barTintColor = _layoutTableView.backgroundColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.],
                                                                    NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.bounds)-1,
                                                                    CGRectGetWidth(self.navigationController.navigationBar.bounds), 1)];
    bottomBorder.backgroundColor = _layoutTableView.separatorColor;
    [self.navigationController.navigationBar addSubview:bottomBorder];
}

- (void)loadPrograms {
    @weakify(self);
    [self.programModel fetchProgramsWithColumnId:self.channel.columnId
                                          pageNo:++self.currentPage
                                        pageSize:kDefaultPageSize
                               completionHandler:^(BOOL success, JQKChannelPrograms *programs) {
                                   @strongify(self);
                                   
                                   if (!self) {
                                       return;
                                   }
                                   
                                   if (success && programs.programList) {
                                       [self.programs addObjectsFromArray:programs.programList];
                                       [self->_layoutTableView reloadData];
                                   }
                                   
                                   [self->_layoutTableView JQK_endPullToRefresh];
                                   
                                   if (self.programs.count >= programs.items.unsignedIntegerValue) {
                                       [self->_layoutTableView JQK_pagingRefreshNoMoreData];
                                   }
                               }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JQKProgramCell *cell = [tableView dequeueReusableCellWithIdentifier:kProgramCellReusableIdentifier
                                                           forIndexPath:indexPath];
    cell.backgroundColor = tableView.backgroundColor;
    
    if (indexPath.row < self.programs.count) {
        JQKProgram *program = self.programs[indexPath.row];
        cell.title = program.title;
        cell.subtitle = program.specialDesc;
        cell.thumbImageURL = [NSURL URLWithString:program.coverImg];
        
        NSDictionary *tags = @{@(JQKVideoSpecHot):@"hot_tag",
                               @(JQKVideoSpecNew):@"new_tag",
                               @(JQKVideoSpecHD):@"hd_tag"};
        cell.tagImage = [UIImage imageNamed:tags[program.spec]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.programs.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JQKProgram *program = self.programs[indexPath.row];
    [self switchToPlayProgram:program];
    
    if (![JQKUtil isPaid]) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
}

@end

//
//  JQKVideoDetailViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKVideoDetailViewController.h"
#import "JQKVideoPlayerCell.h"
#import "JQKVideoCell.h"
#import "JQKVideoCommentCell.h"
#import "JQKVideoDetailHeaderView.h"
#import "JQKVideoCommentInputView.h"
#import "JQKGetCommentsInfo.h"

#import "JQKVideo.h"
#import "JQKVideoListModel.h"
#import <TPKeyboardAvoidingCollectionView.h>

static NSString *const kVideoPlayerCellReusableIdentifier = @"VideoPlayerCellReusableIdentifier";
static NSString *const kRecommendVideoCellReusableIdentifier = @"RecommendVideoCellReusableIdentifier";
static NSString *const kCommentCellReusableIdentifier = @"CommentCellReusableIdentifier";
static NSString *const kHeaderViewReusableIdentifier = @"HeaderViewReusableIdentifier";
static NSString *const kCommentInputViewReusableIdentifier = @"CommentInputViewReusableIdentifier";

typedef NS_ENUM(NSUInteger, JQKVideoSection) {
    JQKVideoPlayerSection,
    JQKRecommendVideoSection,
    JQKCommentSection,
    JQKVideoSectionCount
};

@interface JQKVideoDetailViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCV;
}
@property (nonatomic,retain) JQKVideoListModel *recommendVideoModel;
@property (nonatomic,readonly) NSUInteger popularity;
@property (nonatomic) NSString *colunmId;
@property (nonatomic) NSMutableArray * array;
@end

@implementation JQKVideoDetailViewController
@synthesize popularity = _popularity;

DefineLazyPropertyInitialization(JQKVideoListModel, recommendVideoModel)

- (instancetype)initWithVideo:(JQKVideo *)video columnId:(NSString *)columnId{
    self = [self init];
    if (self) {
        _video = video;
        _colunmId = columnId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.video.title;
    
    _array = [[NSMutableArray alloc] init];
    [self getComment];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5;

    _layoutCV = [[TPKeyboardAvoidingCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCV.backgroundColor = self.view.backgroundColor;
    _layoutCV.delegate = self;
    _layoutCV.dataSource = self;
    [_layoutCV registerClass:[JQKVideoPlayerCell class] forCellWithReuseIdentifier:kVideoPlayerCellReusableIdentifier];
    [_layoutCV registerClass:[JQKVideoCell class] forCellWithReuseIdentifier:kRecommendVideoCellReusableIdentifier];
    [_layoutCV registerClass:[JQKVideoCommentCell class] forCellWithReuseIdentifier:kCommentCellReusableIdentifier];
    [_layoutCV registerClass:[JQKVideoDetailHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewReusableIdentifier];
    [_layoutCV registerClass:[JQKVideoCommentInputView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kCommentInputViewReusableIdentifier];
    [self.view addSubview:_layoutCV];
    {
        [_layoutCV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCV JQK_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadRecommendVideos];
    }];
    [_layoutCV JQK_triggerPullToRefresh];
}

- (void)getComment {
    NSMutableArray * numArray = [[NSMutableArray alloc] initWithArray:[JQKGetCommentsInfo sharedInstance].array];
    if (numArray.count == 0) {
        return ;
    }
    
    for (NSInteger i = 0; i < 4; i++) {
        NSInteger count = arc4random() % numArray.count;
        [numArray removeObjectAtIndex:count];
        [_array addObject:[JQKGetCommentsInfo sharedInstance].array[count]];
    }
}

- (void)loadRecommendVideos {
    @weakify(self);
    [self.recommendVideoModel fetchVideosDetailsPageWithColumnId:_colunmId
                                                       programId:_video.programId
                                               CompletionHandler:^(BOOL success, id obj)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutCV JQK_endPullToRefresh];
        
        if (success) {
            [self->_layoutCV reloadSections:[NSIndexSet indexSetWithIndex:JQKRecommendVideoSection]];
        }
    }];
}

- (NSUInteger)popularity {
    if (_popularity > 0) {
        return _popularity;
    }
    
    _popularity = arc4random_uniform(100);
    return _popularity;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[JQKStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[JQKUtil currentSubTabPageIndex] forSlideCount:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return JQKVideoSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == JQKVideoPlayerSection) {
        return 1;
    } else if (section == JQKRecommendVideoSection) {
        return 4;
    } else if (section == JQKCommentSection) {
        return _array.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JQKVideoPlayerSection) {
        JQKVideoPlayerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVideoPlayerCellReusableIdentifier forIndexPath:indexPath];
        cell.imageURL = [NSURL URLWithString:self.video.coverImg];
        return cell;
    } else if (indexPath.section == JQKRecommendVideoSection) {
        JQKVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendVideoCellReusableIdentifier forIndexPath:indexPath];
        
        if (indexPath.item < self.recommendVideoModel.fetchedVideos.hotProgramList.count) {
            JQKVideo *video = self.recommendVideoModel.fetchedVideos.hotProgramList[indexPath.item];
            cell.imageURL = [NSURL URLWithString:video.coverImg];
            cell.title = video.title;
            [cell setVipLabel:video.spec];
        }
        return cell;
    } else if (indexPath.section == JQKCommentSection) {
        JQKVideoCommentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommentCellReusableIdentifier forIndexPath:indexPath];
        
        if (indexPath.item < _array.count) {
            JQKComment *comment = _array[indexPath.item];
            cell.avatarImageURL = [NSURL URLWithString:comment.icon];
            cell.nickName = comment.userName;
            cell.content = comment.content;
            cell.popularity = comment.popularity;
            cell.dateString = @"1天前";
        }
        return cell;
    } else {
        return nil;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        JQKVideoDetailHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderViewReusableIdentifier forIndexPath:indexPath];
        if (indexPath.section == JQKRecommendVideoSection) {
            headerView.title = @"会员独享";
            headerView.subtitle = [NSString stringWithFormat:@"播放：%ld万", (unsigned long)self.popularity];
        } else if (indexPath.section == JQKCommentSection) {
            headerView.title = @"热门评论";
            headerView.subtitle = nil;
        }
        return headerView;
    } else {
        if (indexPath.section == JQKCommentSection) {
            JQKVideoCommentInputView *inputView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCommentInputViewReusableIdentifier forIndexPath:indexPath];
            inputView.sendAction = ^(id sender) {
                [[JQKHudManager manager] showProgressInDuration:1];
                
                [sender resignInput];
                [sender bk_performBlock:^(id obj) {
                    JQKVideoCommentInputView *thisInputView = obj;
                    [thisInputView clearInput];
                    
                    [[JQKHudManager manager] showHudWithText:@"评论发送成功"];
                } afterDelay:1];
            };
            return inputView;
        }
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JQKVideoPlayerSection) {
//        [self switchToPlayVideo:self.video];
        [self switchToPlayVideo:self.video programLocation:indexPath.item inChannel:_channel];
    } else if (indexPath.section == JQKRecommendVideoSection) {
        if (indexPath.item < self.recommendVideoModel.fetchedVideos.hotProgramList.count) {
            JQKVideos *videos = self.recommendVideoModel.fetchedVideos;
            JQKVideoDetailViewController *videoVC = [[JQKVideoDetailViewController alloc] initWithVideo:videos.hotProgramList[indexPath.item] columnId:_colunmId];
            videoVC.channel = videos;
            [self.navigationController pushViewController:videoVC animated:YES];
            [[JQKStatsManager sharedManager] statsCPCWithProgram:videos.hotProgramList[indexPath.item] programLocation:indexPath.item inChannel:videos andTabIndex:self.tabBarController.selectedIndex subTabIndex:[JQKUtil currentSubTabPageIndex]];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    if (indexPath.section == JQKVideoPlayerSection) {
        return CGSizeMake(fullWidth, fullWidth/1.8);
    } else if (indexPath.section == JQKRecommendVideoSection) {
        UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
        const CGFloat itemWidth = (fullWidth - layout.minimumInteritemSpacing - insets.left - insets.right) / 2;
        const CGFloat itemHeight = [JQKVideoCell heightRelativeToWidth:itemWidth landscape:YES];
        return CGSizeMake(itemWidth, itemHeight);
    } else if (indexPath.section == JQKCommentSection) {
        UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
        return CGSizeMake(CGRectGetWidth(collectionView.bounds)-insets.left-insets.right, 92);
    }
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == JQKVideoPlayerSection) {
        return CGSizeZero;
    } else {
        UIEdgeInsets insets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
        return CGSizeMake(CGRectGetWidth(collectionView.bounds)-insets.left-insets.right, 30);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == JQKCommentSection) {
        UIEdgeInsets insets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
        return CGSizeMake(CGRectGetWidth(collectionView.bounds)-insets.left-insets.right, 60);
    } else {
        return CGSizeZero;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == JQKVideoPlayerSection) {
        return UIEdgeInsetsZero;
    } else {
        return UIEdgeInsetsMake(0, 5, 0, 5);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == JQKCommentSection) {
        return 0;
    }
    return 5;
}


@end

//
//  JQKPhotoListViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKPhotoListViewController.h"
//#import "JQKChannel.h"
#import "JQKVideoCell.h"
#import "JQKPhotoListModel.h"
#import "JQKVideoListModel.h"

static NSString *const kPhotoCellReusableIdentifier = @"PhotoCellReusableIdentifier";

@interface JQKPhotoListViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
    NSInteger _page;
}
@property (nonatomic,retain) NSArray<JQKPhoto *> *photos;
@property (nonatomic,retain) JQKPhotoListModel *photoModel;
@property (nonatomic,retain) NSArray<JQKVideo *> *videos;
@property (nonatomic,retain) JQKVideoListModel *videoModel;
@property (nonatomic,retain) NSMutableArray *photosArray;
@end

@implementation JQKPhotoListViewController

DefineLazyPropertyInitialization(JQKPhotoListModel, photoModel)
DefineLazyPropertyInitialization(JQKVideoListModel, videoModel)

DefineLazyPropertyInitialization(NSArray, photos)
DefineLazyPropertyInitialization(NSMutableArray, photosArray)


- (instancetype)initWithPhotoAlbum:(JQKVideo *)photoChannel {
    self = [super init];
    if (self) {
        _photoChannel = photoChannel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _photoChannel.name;
    _page = 1;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = layout.minimumInteritemSpacing;
    layout.sectionInset = UIEdgeInsetsMake(layout.minimumInteritemSpacing, layout.minimumInteritemSpacing, layout.minimumInteritemSpacing, layout.minimumInteritemSpacing);
    
    _layoutCollectionView = [[UICollectionView  alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = self.view.backgroundColor;
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    [_layoutCollectionView registerClass:[JQKVideoCell class] forCellWithReuseIdentifier:kPhotoCellReusableIdentifier];
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCollectionView JQK_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadPhotosWithRefreshFlag:YES];
    }];
    [_layoutCollectionView JQK_addPagingRefreshWithIsChangeFooter:YES withHandler:^{
        @strongify(self);
        if ([JQKUtil isPaid]) {
            
            [self loadPhotosWithRefreshFlag:NO];
        }else {
            [_layoutCollectionView JQK_endPullToRefresh];
         [self switchToPlayVideo:nil programLocation:0 inChannel:nil];
        }
    }];
    [_layoutCollectionView JQK_triggerPullToRefresh];
}

- (void)loadPhotosWithRefreshFlag:(BOOL)isRefresh {
    @weakify(self);
    
    NSUInteger page = isRefresh?1:_page++;
    
    [self.videoModel fetchPhotosWithPageNo:page
                                  columnId:_photoChannel.columnId.stringValue
                         completionHandler:^(BOOL success, id obj)
     {
         @strongify(self);
         if (!self) {
             return ;
         }
         
         [self->_layoutCollectionView JQK_endPullToRefresh];
         
         if (success) {
             JQKVideos *videos = obj;
             self.videos = videos.programList;
             [self->_layoutCollectionView reloadData];
         }
     }];
}

- (void)loadPhotosWithProgramId:(NSString *)programId programLocation:(NSUInteger)programLocation
                        program:(JQKVideo *)program
                      inChannel:(JQKVideos *)channel{
    @weakify(self);
    
    
    [self.photoModel fetchPhotoDetailsPageWithColumnId:_photoChannel.columnId.stringValue
                                             programId:programId
                                     CompletionHandler:^(BOOL success, id obj)
     {
         @strongify(self);
         if (!self) {
             return ;
         }
         if (success) {
             [_photosArray removeAllObjects];
             JQKPhotos *photos = obj;
             self.photos = photos.programUrlList;
             for (JQKPhoto * photo in _photos) {
                 [self.photosArray addObject:photo.url];
             }
             JQKPhoto *aphoto = [[JQKPhoto alloc] init];
             aphoto.Urls = self.photosArray;
             //             [self switchToViewPhoto:aphoto];
             [self switchToViewPhoto:aphoto programLocation:programLocation program:program inChannel:channel];
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JQKVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellReusableIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.videos.count) {
        JQKVideo *video = self.videos[indexPath.item];
        cell.title = video.title;
        cell.imageURL = [NSURL URLWithString:video.coverImg];
        [cell setVipLabel:video.type];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videos.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    const CGFloat width = (CGRectGetWidth(collectionView.bounds) - layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right)/2;
    const CGFloat height = [JQKVideoCell heightRelativeToWidth:width landscape:NO];
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.videos.count) {
        JQKVideo *video = self.videos[indexPath.item];
//        [self loadPhotosWithProgramId:video.programId];
        [self loadPhotosWithProgramId:video.programId programLocation:indexPath.item program:video inChannel:self.videoModel.fetchedVideos];
        
        [[JQKStatsManager sharedManager] statsCPCWithProgram:video programLocation:indexPath.item inChannel:self.videoModel.fetchedVideos andTabIndex:self.tabBarController.selectedIndex subTabIndex:[JQKUtil currentSubTabPageIndex]];
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[JQKStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[JQKUtil currentSubTabPageIndex] forSlideCount:1];
}


@end

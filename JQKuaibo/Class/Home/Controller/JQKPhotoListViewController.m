//
//  JQKPhotoListViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKPhotoListViewController.h"
#import "JQKChannel.h"
#import "JQKVideoCell.h"
#import "JQKPhotoListModel.h"

static NSString *const kPhotoCellReusableIdentifier = @"PhotoCellReusableIdentifier";

@interface JQKPhotoListViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic,retain) NSArray<JQKPhoto *> *photos;
@property (nonatomic,retain) JQKPhotoListModel *photoModel;
@end

@implementation JQKPhotoListViewController

DefineLazyPropertyInitialization(JQKPhotoListModel, photoModel)
DefineLazyPropertyInitialization(NSArray, photos)

- (instancetype)initWithPhotoAlbum:(JQKVideo *)video {
    self = [super init];
    if (self) {
        _photoVideo = video;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _photoVideo.title;
    
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
        [self loadPhotos];
    }];
    [_layoutCollectionView JQK_triggerPullToRefresh];
}

- (void)loadPhotos {
    @weakify(self);
    [self.photoModel fetchPhotosWithAlbumId:_photoVideo.programId CompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutCollectionView JQK_endPullToRefresh];
        
        if (success) {
            JQKPhotos *photos = obj;
            self.photos = photos.programUrlList;
            [self->_layoutCollectionView reloadData];
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
    
    if (indexPath.row < self.photos.count) {
        JQKPhoto *photo = self.photos[indexPath.item];
        cell.title = photo.title;
        cell.imageURL = [NSURL URLWithString:photo.url];
        [cell setVipLabel:6];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    const CGFloat width = (CGRectGetWidth(collectionView.bounds) - layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right)/2;
    const CGFloat height = [JQKVideoCell heightRelativeToWidth:width landscape:NO];
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.photos.count) {
        JQKPhoto *photo = self.photos[indexPath.item];
        [self switchToViewPhoto:photo];
    }
}

@end

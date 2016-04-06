//
//  JQKBaseViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKBaseViewController.h"
#import "JQKPaymentViewController.h"
#import "JQKVideoPlayerViewController.h"
#import "JQKVideo.h"
#import "JQKPhoto.h"
#import <MWPhotoBrowser.h>
#import <objc/runtime.h>

@import MediaPlayer;
@import AVKit;
@import AVFoundation.AVPlayer;
@import AVFoundation.AVAsset;
@import AVFoundation.AVAssetImageGenerator;

static const void* kPhotoNumberAssociatedKey = &kPhotoNumberAssociatedKey;

@interface JQKBaseViewController () <MWPhotoBrowserDelegate>
{
    UIButton *_rightNavButton;
}
- (UIViewController *)playerVCWithVideo:(JQKVideo *)video;
@end

@implementation JQKBaseViewController

- (BOOL)hidesBottomBarWhenPushed {
    return self.navigationController.viewControllers.firstObject != self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    
    if (self.navigationController.viewControllers.firstObject == self) {
        @weakify(self);
        _rightNavButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _rightNavButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_rightNavButton setImage:[UIImage imageNamed:@"VIP_navitem_normal"] forState:UIControlStateNormal];
        [_rightNavButton setImage:[UIImage imageNamed:@"VIP_navitem_selected"] forState:UIControlStateSelected];
        _rightNavButton.selected = [JQKUtil isPaid];
        [_rightNavButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            UIButton *thisButton = sender;
            if (!thisButton.selected) {
                [self payForPayable:nil];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightNavButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPaidNotification:) name:kPaidNotificationName object:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    DLog(@"%@ dealloc", [self class]);
}

- (void)switchToPlayVideo:(JQKVideo *)video {
    if (![JQKUtil isPaid]) {
        [self payForPayable:video];
    } else {
        [self playVideo:video];
    }
}

- (void)playVideo:(JQKVideo *)video {
    [self playVideo:video withTimeControl:YES shouldPopPayment:NO];
}

- (void)playVideo:(JQKVideo *)video withTimeControl:(BOOL)hasTimeControl shouldPopPayment:(BOOL)shouldPopPayment {
    if (hasTimeControl) {
        UIViewController *videoPlayVC = [self playerVCWithVideo:video];
        videoPlayVC.hidesBottomBarWhenPushed = YES;
        [self presentViewController:videoPlayVC animated:YES completion:nil];
    } else {
        JQKVideoPlayerViewController *playerVC = [[JQKVideoPlayerViewController alloc] initWithVideo:video];
        playerVC.hidesBottomBarWhenPushed = YES;
        [self presentViewController:playerVC animated:YES completion:nil];
    }
}

- (void)switchToViewPhoto:(JQKPhoto *)photo {
    if (![JQKUtil isPaid]) {
        [self payForPayable:photo];
    } else {
        NSMutableArray<MWPhoto *> *photos = [[NSMutableArray alloc] initWithCapacity:photo.Urls.count];
        [photo.Urls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:obj]]];
        }];
        
        MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
        photoBrowser.displayActionButton = NO;
        photoBrowser.delegate = self;
        objc_setAssociatedObject(photoBrowser, kPhotoNumberAssociatedKey, @(photos.count), OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self.navigationController pushViewController:photoBrowser animated:YES];
    }
}

- (void)payForPayable:(id<JQKPayable>)payable; {
    [[JQKPaymentViewController sharedPaymentVC] popupPaymentInView:self.view.window forPayable:payable withCompletionHandler:nil];
}

- (void)onPaidNotification:(NSNotification *)notification {
    _rightNavButton.selected = YES;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIViewController *)playerVCWithVideo:(JQKVideo *)video {
    UIViewController *retVC;
    if (NSClassFromString(@"AVPlayerViewController")) {
        AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
        playerVC.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:video.Url]];
        [playerVC aspect_hookSelector:@selector(viewDidAppear:)
                          withOptions:AspectPositionAfter
                           usingBlock:^(id<AspectInfo> aspectInfo){
                               AVPlayerViewController *thisPlayerVC = [aspectInfo instance];
                               [thisPlayerVC.player play];
                           } error:nil];
        
        retVC = playerVC;
    } else {
        retVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:video.Url]];
    }
    
    [retVC aspect_hookSelector:@selector(supportedInterfaceOrientations) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo){
        UIInterfaceOrientationMask mask = UIInterfaceOrientationMaskAll;
        [[aspectInfo originalInvocation] setReturnValue:&mask];
    } error:nil];
    
    [retVC aspect_hookSelector:@selector(shouldAutorotate) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo){
        BOOL rotate = YES;
        [[aspectInfo originalInvocation] setReturnValue:&rotate];
    } error:nil];
    return retVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MWPhotoBrowserDelegate

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    NSNumber *photoCount = objc_getAssociatedObject(photoBrowser, kPhotoNumberAssociatedKey);
    return [NSString stringWithFormat:@"第%ld张(共%ld张)", (unsigned long)index+1, (unsigned long)photoCount.unsignedIntegerValue];
}

@end

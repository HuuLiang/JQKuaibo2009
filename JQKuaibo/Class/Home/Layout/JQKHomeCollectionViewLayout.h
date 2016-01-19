//
//  JQKHomeCollectionViewLayout.h
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JQKHomeCollectionViewLayoutDelegate <NSObject>

@optional
- (BOOL)collectionView:(nonnull UICollectionView *)collectionView
                layout:(nonnull UICollectionViewLayout *)collectionViewLayout
    hasAdBannerForItem:(NSUInteger)item;

@end

@interface JQKHomeCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) CGFloat interItemSpacing;
@property (nonatomic,assign,nullable) id<JQKHomeCollectionViewLayoutDelegate> delegate;

@end

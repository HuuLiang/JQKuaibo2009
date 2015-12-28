//
//  JQKHomeCollectionViewLayout.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKHomeCollectionViewLayout.h"

typedef NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> LayoutAttributesDictionary;
static const CGFloat kTopImageScale = 1184./595.;
static const CGFloat kBigImageScale = 568./807.;
static const CGFloat kSmallImageScale = 563./382.;

@interface JQKHomeCollectionViewLayout ()
@property (nonatomic,retain) LayoutAttributesDictionary *layoutAttributes;

@property (nonatomic,readonly) CGSize topSize;
@property (nonatomic,readonly) CGSize bigSize;
@property (nonatomic,readonly) CGSize smallSize;
@end

@implementation JQKHomeCollectionViewLayout

DefineLazyPropertyInitialization(LayoutAttributesDictionary, layoutAttributes)

- (CGSize)bigSize {
    const CGFloat cvW = CGRectGetWidth(self.collectionView.bounds);
    const CGFloat bigH = (2*(cvW-_interItemSpacing)+_interItemSpacing*kSmallImageScale) / (2*kBigImageScale+kSmallImageScale);
    const CGFloat bigW = bigH * kBigImageScale;
    return CGSizeMake(bigW, bigH);
}

- (CGSize)smallSize {
    const CGFloat smallH = (self.bigSize.height-_interItemSpacing) / 2;
    const CGFloat smallW = smallH * kSmallImageScale;
    return CGSizeMake(smallW, smallH);
}

- (CGSize)halfSize {
    const CGFloat cvW = CGRectGetWidth(self.collectionView.bounds);
    const CGSize smallSize = [self smallSize];
    const CGFloat width = (cvW-_interItemSpacing)/2;
    
    if (smallSize.width == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(width, width * smallSize.height / smallSize.width);
}

- (CGSize)topSize {
    const CGFloat cvW = CGRectGetWidth(self.collectionView.bounds);
    return CGSizeMake(cvW, cvW/kTopImageScale);
}

- (void)prepareLayout {
    [super prepareLayout];
    
    [self.layoutAttributes removeAllObjects];
    NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    if (numberOfItems == 0) {
        return ;
    }
    
    const CGSize bigSize = self.bigSize;
    const CGSize smallSize = self.smallSize;
    const CGSize topSize = self.topSize;
    const CGSize halfSize = self.halfSize;
    
    const CGFloat bigH = bigSize.height;
    const CGFloat bigW = bigSize.width;
    const CGFloat smallH = smallSize.height;
    const CGFloat smallW = smallSize.width;
    const CGFloat topWidth = topSize.width;
    const CGFloat topHeight = topSize.height;
    const CGFloat halfH = halfSize.height;
    const CGFloat halfW = halfSize.width;
    
    for (NSUInteger i = 0; i < numberOfItems; ++i) {
        UICollectionViewLayoutAttributes *layoutAttribs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        if (i == 0) {
            layoutAttribs.frame = CGRectMake(0, 0, topWidth, topHeight);
        } else {
            NSUInteger index = i-1;
            
            CGFloat x = 0, y = 0;
            if (index % 7 < 3) {
                x = index % 7 == 0 ? 0 : bigW + _interItemSpacing;
                y = (index / 7) * (smallH*2+halfH*2 + _interItemSpacing * 4);//(bigH + smallH * 2 + _interItemSpacing * 3);
                
                if (index % 7 == 2) {
                    y += (smallH + _interItemSpacing);
                }
                
            } else {
                NSUInteger sIndex = index % 7 - 3;
                x = sIndex%2==0? 0 : halfW+_interItemSpacing;
                y = (index / 7) * (smallH*2+halfH*2 + _interItemSpacing * 4) + (sIndex/2) *(halfH + _interItemSpacing)+2*(smallH + _interItemSpacing);
            }
            
            y += (topHeight+_interItemSpacing);
            
            if (index % 7 == 0) {
                layoutAttribs.frame = CGRectMake(x, y, bigW, bigH);
            } else if (index % 7 < 3) {
                layoutAttribs.frame = CGRectMake(x, y, smallW, smallH);
            } else {
                layoutAttribs.frame = CGRectMake(x, y, halfW, halfH);
            }
        }
        [self.layoutAttributes setObject:layoutAttribs forKey:layoutAttribs.indexPath];
    }
}

- (CGSize)collectionViewContentSize {
    const NSUInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    if (itemCount == 0) {
        return CGSizeZero;
    }
    
    const CGSize smallSize = self.smallSize;
    const NSUInteger repeatedItemCount = itemCount - 1;
    CGSize contentSize = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), self.topSize.height + repeatedItemCount/7*(smallSize.height+_interItemSpacing)*4);
    
    const NSUInteger remainItems = repeatedItemCount % 7;
    if (remainItems == 0) {
        //contentSize = CGSizeMake(contentSize.width, contentSize.height-_interItemSpacing);
    } else {
        contentSize = CGSizeMake(contentSize.width, contentSize.height+(smallSize.height+_interItemSpacing)*2);
        if (remainItems > 3) {
            contentSize = CGSizeMake(contentSize.width, contentSize.height+(remainItems/2-1)*(smallSize.height+_interItemSpacing));
        }
    }
    return contentSize;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.layoutAttributes.allValues bk_select:^BOOL(id obj) {
        UICollectionViewLayoutAttributes *attributes = obj;
        return CGRectIntersectsRect(rect, attributes.frame);
    }];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttributes[indexPath];
}
@end

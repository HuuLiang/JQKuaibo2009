//
//  JQKVideoCell.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQKVideoCell : UICollectionViewCell

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSString *title;

- (void)setVipLabel:(NSInteger)spec;

+ (CGFloat)heightRelativeToWidth:(CGFloat)width landscape:(BOOL)isLandscape;

@end

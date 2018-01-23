//
//  JQKVideoCommentCell.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQKVideoCommentCell : UICollectionViewCell

@property (nonatomic) NSURL *avatarImageURL;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *content;
@property (nonatomic) NSUInteger popularity;
@property (nonatomic) NSString *dateString;

@end

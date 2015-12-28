//
//  JQKMineTopBanner.h
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/26.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JQKMineTopBannerAction)(void);

@interface JQKMineTopBanner : UITableViewCell

@property (nonatomic) double price;
@property (nonatomic,copy) JQKMineTopBannerAction payAction;
@property (nonatomic,copy) JQKMineTopBannerAction goToMovieAction;

@end

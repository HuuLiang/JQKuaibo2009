//
//  JQKPhotoListViewController.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKBaseViewController.h"

@class JQKChannel;
@interface JQKPhotoListViewController : JQKBaseViewController

@property (nonatomic,retain,readonly) JQKVideo *photoChannel;

- (instancetype)init __attribute__((unavailable("Use initWithPhotoAlbum: instead!")));

- (instancetype)initWithPhotoAlbum:(JQKVideo *)photoChannel;

@end

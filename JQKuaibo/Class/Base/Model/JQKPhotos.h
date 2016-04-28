//
//  JQKPhotos.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKURLResponse.h"
#import "JQKPhoto.h"

@interface JQKPhotos : JQKURLResponse

@property (nonatomic,retain) NSArray<JQKPhoto *> *programUrlList;

@end

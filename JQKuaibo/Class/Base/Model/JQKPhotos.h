//
//  JQKPhotos.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBURLResponse.h"
#import "JQKPhoto.h"

@interface JQKPhotos : QBURLResponse

@property (nonatomic,retain) NSArray<JQKPhoto *> *programUrlList;

@end

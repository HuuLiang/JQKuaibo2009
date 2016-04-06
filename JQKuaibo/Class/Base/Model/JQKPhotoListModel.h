//
//  JQKPhotoListModel.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKURLRequest.h"
#import "JQKPhotos.h"

@interface JQKPhotoListModel : JQKURLRequest
@property (nonatomic,retain,readonly) JQKPhotos *fetchedPhotos;

- (BOOL)fetchPhotosWithAlbumId:(NSString *)albumId page:(NSUInteger)page pageSize:(NSUInteger)pageSize completionHandler:(JQKCompletionHandler)handler;

@end

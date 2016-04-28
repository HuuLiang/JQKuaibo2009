//
//  JQKPhotoListModel.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
#import "JQKPhotos.h"

@interface JQKPhotoListModel : JQKEncryptedURLRequest
@property (nonatomic,retain,readonly) JQKPhotos *fetchedPhotos;

- (BOOL)fetchPhotosWithAlbumId:(NSString *)albumId CompletionHandler:(JQKCompletionHandler)handler;

@end

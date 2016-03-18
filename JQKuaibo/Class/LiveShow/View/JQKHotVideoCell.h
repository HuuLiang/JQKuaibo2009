//
//  JQKHotVideoCell.h
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/26.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JQKHotVideoPlayAction)(void);

@interface JQKHotVideoCell : UITableViewCell

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSString *title;
//@property (nonatomic) NSString *subtitle;
//@property (nonatomic,copy) JQKHotVideoPlayAction playAction;

@end

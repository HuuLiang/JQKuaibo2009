//
//  JQKProgramCell.h
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQKProgramCell : UITableViewCell

@property (nonatomic) NSURL *thumbImageURL;
@property (nonatomic,retain) UIImage *tagImage;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;

@end

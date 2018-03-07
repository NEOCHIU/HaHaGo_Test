//
//  TableViewCell.h
//  HaHaGo_Test
//
//  Created by nerochiu on 2018/3/5.
//  Copyright © 2018年 ISCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatarImg;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *discLabel;
@property (strong, nonatomic) IBOutlet UILabel *checkLabel;

@end

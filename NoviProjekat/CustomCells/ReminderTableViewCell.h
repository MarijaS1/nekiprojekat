//
//  ReminderTableViewCell.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 5/14/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define REMINDER_TABEL_VIEW_CELL_IDENTIFIER     @"reminderTableViewCell"

@interface ReminderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@end

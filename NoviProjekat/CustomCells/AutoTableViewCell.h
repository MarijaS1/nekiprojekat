//
//  AutoTableViewCell.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 5/16/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#define AUTO_TABLE_VIEW_CELL_IDENTIFIER       @"autoTableViewCell"

@interface AutoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *autoImageView;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeOfCarLabel;
@property (weak, nonatomic) IBOutlet UILabel *registrationPlateLabel;

@end

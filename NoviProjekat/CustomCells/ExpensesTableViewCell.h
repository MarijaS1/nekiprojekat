//
//  ExpensesTableViewCell.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 8/20/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpensesTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *expenseImageView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UILabel *purposeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *carLabel;
@end

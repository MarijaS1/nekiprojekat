//
//  AddNewExpenseViewController.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 8/13/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"

@interface AddNewExpenseViewController : BasicViewController
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UITextField *typeOfExpenseTF;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;

@property (weak, nonatomic) IBOutlet UITextField *carTextField;
@property (weak, nonatomic) IBOutlet UIButton *typeOfExpenseButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;

@property (weak, nonatomic) IBOutlet UIButton *carButton;

@end

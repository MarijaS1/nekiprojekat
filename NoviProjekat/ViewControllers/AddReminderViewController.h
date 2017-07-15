//
//  AddReminderViewController.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 5/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "BasicViewController.h"
#import <EventKit/EventKit.h>

@interface AddReminderViewController : BasicViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *typeOfReminderTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteTextField;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *typeOfRemiderButton;
@property (weak, nonatomic) IBOutlet UIButton *addReminder;

@property (strong, nonatomic) NSArray *eventsArray;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *notes;



@end

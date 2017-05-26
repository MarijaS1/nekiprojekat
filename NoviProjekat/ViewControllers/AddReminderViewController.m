//
//  AddReminderViewController.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 5/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "AddReminderViewController.h"
#import "ActionSheetPicker.h"
#import "CalendarService.h"
#import "Reminder.h"



@interface AddReminderViewController ()

@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) NSArray *pickTypeOfReminderArray;

@end

@implementation AddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGui];
}

#pragma mark - Private methods

-(void)initGui{
    self.view.backgroundColor = [UIColor getDarkGreyColor];
    self.pickTypeOfReminderArray=[[NSArray alloc] initWithObjects:@"Registracija", @"Vozacka dozvola", @"Godisnji servis", nil];
    
   
    self.selectedDate =nil;
    //self.title =@"Update Expense";
    
    self.titleTextField.delegate = self;
    self.dateTextField.delegate = self;
    
    self.tap = [[UITapGestureRecognizer alloc]
                initWithTarget:self
                action:@selector(dismissKeyboard)];
    [self.tap setCancelsTouchesInView:NO];
    [self.tap setEnabled:NO];
    [self.view addGestureRecognizer:self.tap];

}

#pragma mark -Keybord

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:@"textFieldShouldBeginEditing:" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
    [self.tap setEnabled:YES];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.titleTextField) {
        [self.typeOfReminderTextField becomeFirstResponder];
    }else if (textField == self.typeOfReminderTextField){
        [self.dateTextField becomeFirstResponder];
    }else if (textField == self.dateTextField){
        [self.noteTextField becomeFirstResponder];
    }else{
        [self dismissKeyboard];
    }
    
    return YES;
}

-(void) dismissKeyboard {
    [self.titleTextField resignFirstResponder];
    [self.typeOfReminderTextField resignFirstResponder];
    [self.dateTextField resignFirstResponder];
    [self.noteTextField resignFirstResponder];
    [self.tap setEnabled:NO];
}


#pragma mark - Action methods
- (IBAction)typeOfReminderButtonPressed:(UIButton *)sender {
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:self.pickTypeOfReminderArray
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           self.typeOfReminderTextField.text = (NSString*)selectedValue;
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                                                            }
                                          origin:sender];
    
}


- (IBAction)dateButtonPressed:(UIButton *)sender {

    NSDate *minDate = [NSDate date];
    
    ActionSheetDatePicker* actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:minDate
                                                                                minimumDate:minDate
                                                                                maximumDate:nil
                                                                                     target:self action:@selector(dateWasSelected:element:) origin:sender];

    actionSheetPicker.hideCancel = NO;
    [actionSheetPicker showActionSheetPicker];

}

- (IBAction)addNewReminderButtonPressed:(UIButton *)sender {
    [self addReminderToCalendarAppWithTitle:self.titleTextField.text withDate:self.selectedDate withNotes:self.noteTextField.text WithType:self.typeOfReminderTextField.text];
    NSError *error = nil;
    
    //    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
//    Reminder *reminder = [NSEntityDescription insertNewObjectForEntityForName:@"Reminder" inManagedObjectContext:self.appDelegate.managedObjectContext];
//    reminder.type = self.typeOfReminderTextField.text;
//    reminder.date = self.selectedDate;
//    reminder.registration = self.registrationPlateTextField.text;s
//    
//    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.appDelegate.managedObjectContext];
//    user.username = self.usernameTextField.text;
//    user.email = self.emailTextField.text;
//    user.password = self.passwordTextField.text;
//    
//    [user addHasCarRelationshipObject:reminder];
//    
//    if (![self.appDelegate.managedObjectContext save:&error]) {
//        NSLog(@"Great, error while fixing error; couldn't save: %@", [error localizedDescription]);
//    } else {
//        NSLog(@"User and car saved");
//        [DataController sharedInstance].carInfo = reminder;
//        UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainTabBar"];
//        tabBarController.selectedIndex=0;
//        UINavigationController *nav = [tabBarController.viewControllers objectAtIndex:0];
//        ParkingViewController *parkingVC = (ParkingViewController*) [nav.viewControllers objectAtIndex:0];
//        parkingVC.car = car;
//        [self presentViewController:tabBarController animated:YES completion:nil];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedIn"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }

        
}

-(void)addReminderToCalendarAppWithTitle:(NSString*)title withDate:(NSDate*)date withNotes:(NSString*)notes WithType:(NSString*)type{
    
    [[CalendarService sharedInstance] addEventWithTitle:(([title isEqualToString:@""]) ? type : title) andWithStartDate:date andWithEndDate:date andWithNotes:([notes isEqualToString:@""]) ? type : notes andWithIdentifier:type accessDenied:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Unable to add to calendar");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Kalendar permisije su isključene za Moj Automobil aplikaciju. Uključite ih u Privacy Settings." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        });
    } accessGranted:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Day  added to calendar");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Podsetnik je uspešno sačuvan u kalendaru!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        });
        
    }];
    
}


- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.selectedDate = selectedDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:self.selectedDate];
    [self.dateTextField setText:dateString];
    //    [self.dateOfBirthButton setTitle:dateString forState:UIControlStateNormal];
    //    [self.dateOfBirthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}




@end

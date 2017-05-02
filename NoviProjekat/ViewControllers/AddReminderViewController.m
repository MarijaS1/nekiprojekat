//
//  AddReminderViewController.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 5/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "AddReminderViewController.h"
#import "ActionSheetPicker.h"




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
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
//    [minimumDateComponents setYear:1900];
//    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *minDate = [NSDate date];
    
    ActionSheetDatePicker* actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:minDate
                                                                                minimumDate:minDate
                                                                                maximumDate:nil
                                                                                     target:self action:@selector(dateWasSelected:element:) origin:sender];

    actionSheetPicker.hideCancel = NO;
    [actionSheetPicker showActionSheetPicker];

}

- (IBAction)addNewReminderButtonPressed:(UIButton *)sender {
    
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

//
//  FirstViewController.m
//  NoviProjekat
//
//  Created by Admin on 10/12/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ReminderViewController.h"
#import "CalendarService.h"
#import "AddReminderViewController.h"


@interface ReminderViewController ()

@end

@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGui];
}

#pragma mark - Private methods

-(void)initGui {
    self.view.backgroundColor = [UIColor getDarkGreyColor];
    self.navigationController.title = @"Podsetnik";
}


- (IBAction)addReminderButtonPressed:(UIButton *)sender {
   AddReminderViewController *addReminderVC = (AddReminderViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"addReminderViewController"];
    [self.navigationController pushViewController:addReminderVC animated:YES];
}

-(void)addNewReminder {
//    [[CalendarService sharedInstance] addEventWithTitle:title andWithStartDate:startDate andWithEndDate:endDate andWithNotes:notes  andWithIdentifier:identifier accessDenied: ^() {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"Unable to add to calendar");
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Calendar permission is disabled for Stynt app. You can enable it in privacy settings." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alertView show];
//        });
//    } accessGranted: ^() {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"Day at index %ld added to calendar",(long)dayIndex);
//            if (dayIndex+1>=self.engagement.days.count) {
//                [self manageCalendarEventsForDay:dayIndex+1 isCompleted:YES isAddAction:YES];
//            }else{
//                [self manageCalendarEventsForDay:dayIndex+1 isCompleted:NO isAddAction:YES];
//            }
//        });
//    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

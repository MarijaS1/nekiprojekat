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
#import "ReminderTableViewCell.h"
#import <EventKit/EventKit.h>

@interface ReminderViewController ()

@property (strong, nonatomic) NSMutableArray* eventsArray;
//@property (strong, nonatomic) NSMutableArray* filteredEventsArray;
@property (strong, nonatomic) NSDateFormatter *formatter;

@end

@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ReminderTableViewCell" bundle:nil] forCellReuseIdentifier:REMINDER_TABEL_VIEW_CELL_IDENTIFIER];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    [self initGui];
    self.formatter = [[NSDateFormatter alloc] init];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self addNotifications];
    self.eventsArray = [[NSMutableArray alloc]init];
//    self.filteredEventsArray = [[NSMutableArray alloc]init];
    self.emptyView.hidden = YES;
    self.viewTable.hidden = YES;
    
    [self addNotifications];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showProgressWithInfoMessage:@"Please wait..."];
    });
    
           [[CalendarService sharedInstance] getAllCalendarEvents];
        
        //    for (EKEvent *event in self.eventsArray) {
        //        if ( ([event. isEqualToString:@"Vozacka dozvola"] || [event.title isEqualToString:@"Godisnji servis"] || [event.title isEqualToString:@"Registracija"])) {
        //            [self.filteredEventsArray addObject:event];
        //        }
        //    }
    
    
//    self.eventsArray = [[CalendarService sharedInstance] getAllCalendarEvents];
//    
////    for (EKEvent *event in self.eventsArray) {
////        if ( ([event. isEqualToString:@"Vozacka dozvola"] || [event.title isEqualToString:@"Godisnji servis"] || [event.title isEqualToString:@"Registracija"])) {
////            [self.filteredEventsArray addObject:event];
////        }
////    }
//    [self hideProgressAndMessage];
//    if (self.eventsArray.count != 0) {
//        [self showTableView];
//    }else{
//        [self showEmptyView];
//    }
}


-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeNotifications];
}
#pragma mark - Private methods

-(void)initGui {
    self.view.backgroundColor = [UIColor getDarkGreyColor];
    self.navigationController.title = @"Podsetnik";
}


-(void)showEmptyView {
    [self.emptyView setHidden:NO];
    [self.viewTable setHidden:YES];
}

-(void)showTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.emptyView setHidden:YES];
     [self.viewTable setHidden:NO];
    [self.tableView reloadData];
    });
}

-(void)addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allEventsReceived:) name:@"ALL_EVENTS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventsReceived:) name:@"NOTIF_CALENDAR" object:nil];

}

-(void)removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:@"ALL_EVENTS"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"NOTIF_CALENDAR"];

}

-(void)allEventsReceived:(NSNotification *)infoNotification{
//    self.eventsArray = [infoNotification.userInfo objectForKey:@"events"];
//    for (EKEvent *event in self.eventsArray) {
//        if (event.hasNotes && ![event.title isEqualToString:@""] && ([event.title isEqualToString:@"Vozacka dozvola"] || [event.title isEqualToString:@"Godisnji servis"] || [event.title isEqualToString:@"Registracija"])) {
//            [self.filteredEventsArray addObject:event];
//        }
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//    [self hideProgressAndMessage];
//    });
//    if (self.filteredEventsArray.count == 0) {
//        [self showEmptyView];
//    }else {
//        [self showTableView];
//    }
}


-(void)eventsReceived:(NSNotification *)infoNotification{
        self.eventsArray = [infoNotification.userInfo objectForKey:@"calendar"];
    
        dispatch_async(dispatch_get_main_queue(), ^{
        [self hideProgressAndMessage];
        });
//    [self hideProgressAndMessage];
    if (self.eventsArray.count != 0) {
        [self showTableView];
    }else{
        [self showEmptyView];
    }
}



#pragma mark - Action methods


- (IBAction)addReminderButtonPressed:(UIButton *)sender {
   AddReminderViewController *addReminderVC = (AddReminderViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"addReminderViewController"];
    [self.navigationController pushViewController:addReminderVC animated:YES];
}


#pragma mark - UITableViewDelegate


#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( self.eventsArray.count != 0) {
        return self.eventsArray.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        
        ReminderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REMINDER_TABEL_VIEW_CELL_IDENTIFIER forIndexPath:indexPath];
        EKEvent *event = [self.eventsArray objectAtIndex:indexPath.row];
        
        [self.formatter setDateFormat:@"dd-MM-yyyy"];
        NSString *stringFromDate = [self.formatter stringFromDate:event.startDate];

        cell.titleLabel.text = event.title;
        cell.dateLabel.text = stringFromDate;
        cell.noteLabel.text = event.notes;
        
        return cell;
    }
    
    return [UITableViewCell new];
}



@end

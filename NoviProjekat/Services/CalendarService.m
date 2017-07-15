//
//  CalendarService.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 5/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "CalendarService.h"
#import <EventKit/EventKit.h>

#define ONE_HOUR 60 * (-60)
#define ONE_DAY  60 * (-24) * 60
#define CALENDAR_EVENTS_KEY @"calendarEvents"
#define DRIVER_LICENCE_KEY @"Vozacka dozvola"
#define SERVICE_KEY @"Godisnji servis"
#define REGISTRATION_KEY @"Registracija"

@interface CalendarService ()

@property (strong, nonatomic) EKEventStore *eventStore;
@property (strong, nonatomic) NSMutableArray *calendarEvents;

- (EKEvent *)createEventWithTitle:(NSString *)title
                 andWithStartDate:(NSDate *)startDate
                   andWithEndDate:(NSDate *)endDate
                     andWithNotes:(NSString *)notes;

- (EKReminder *)createReminderWithTitle:(NSString *)title
                       andWithStartDate:(NSDate *)startDate
                           andWithNotes:(NSString *)notes;

- (void)saveEvent:(EKEvent *)event;

- (EKAlarm *)createAlarmWithRelativeOffset:(NSInteger)relativeOffset;

- (void)deleteEvent:(EKEvent *)event;

- (void)saveReminder:(EKReminder *)reminder;

- (void)storeEventWithIdentifier:(NSString *)identifier
          andWithEventIdentifier:(NSString *)eventIdentifier
       andWithReminderIdentifier:(NSString *)reminderIdentifier;

- (void)deleteReminder:(EKReminder *)reminder;

- (void)removeEventWithKey:(NSString *)key;

- (void)addEventWithTitle:(NSString *)title
         andWithStartDate:(NSDate *)startDate
           andWithEndDate:(NSDate *)endDate
             andWithNotes:(NSString *)notes
               andWithKey:(NSString *)key;

- (void)storeValue:(NSString *)value forKey:(NSString *)key;
- (id)getValueForKey:(NSString *)key;
- (void)removeValueForKey:(NSString *)key;

@end

@implementation CalendarService

static CalendarService *shared = nil;

#pragma mark - Public methods

- (id)init {
    self = [super init];
    if (self) {
        self.eventStore = [[EKEventStore alloc] init];
    }
    return self;
}

+ (CalendarService *)sharedInstance {
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        shared = [[CalendarService alloc] init];
    });
    
    return shared;
}

- (void)addEventWithTitle:(NSString *)title
           andWithStartDate:(NSDate *)startDate
           andWithEndDate:(NSDate *)endDate
             andWithNotes:(NSString *)notes
        andWithIdentifier:(NSString *)identifier accessDenied:(void (^)(void))accessDenied accessGranted:(void (^)(void))accessGranted {
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion: ^(BOOL granted, NSError *error)
     {
         if (granted) {
             [self addEventWithTitle:title andWithStartDate:startDate andWithEndDate:endDate andWithNotes:notes andWithKey:identifier];
             accessGranted();
         }
         else {
             accessDenied();
         }
     }];
}

- (void)removeEvent:(NSString *)identifier accessDenied:(void (^)(void))accessDenied accessGranted:(void (^)(void))accessGranted;
{
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent | EKEntityTypeReminder completion: ^(BOOL granted, NSError *error)
     {
         if (granted) {
             [self removeEventWithKey:identifier];
             accessGranted();
         }
         else {
             accessDenied();
         }
     }];
}

- (BOOL)isEventAvailableForId:(NSString *)identifier {
    BOOL available = YES;
    
    if ([self getValueForKey:identifier]) {
        available = NO;
    }
    
    return available;
}


-(void)getAllCalendarEvents{
    
    // Get the appropriate calendar
//    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    
    if ([self.eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        /* iOS Settings > Privacy > Calendars > MY APP > ENABLE | DISABLE */
        [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
         {
             if ( granted )
             {
                 NSLog(@"User has granted permission!");
                 // Get the appropriate calendar
                 NSCalendar *calendar = [NSCalendar currentCalendar];
                 
                 // Create the start date components
                 NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
                 oneDayAgoComponents.day = -1;
                 NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                               toDate:[NSDate date]
                                                              options:0];
                 
                 // Create the end date components
                 NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
                 oneYearFromNowComponents.year = 3;
                 NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                                    toDate:[NSDate date]
                                                                   options:0];
                 
                 // Create the predicate from the event store's instance method
                 NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:oneDayAgo
                                                                         endDate:oneYearFromNow
                                                                       calendars:nil];
                 
                 self.calendarEvents  = [[NSMutableArray alloc]init];
                 
                 // Fetch all events that match the predicate
//
                    NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
                 
                 for(EKEvent *event in events) {
                     NSLog(@"Event Title:%@", event.title);
                     if ([event.title isEqualToString:@"Vozacka dozvola"]){
                         [self.calendarEvents addObject:event];
                     }else if([event.title isEqualToString:@"Registracija"]){
                        [self.calendarEvents addObject:event];
                     }else if([event.title isEqualToString:@"Godisnji servis"]){
                        [self.calendarEvents addObject:event];
                     }
                 }
                 
                 if (self.calendarEvents != nil) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIF_CALENDAR" object:nil userInfo:[NSDictionary dictionaryWithObject:self.calendarEvents forKey:@"calendar"]];
                 }else{
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIF_CALENDAR" object:nil userInfo:nil];
                 }

             }else {
                 NSLog(@"User has not granted permission!");
             }
         }];
    }
    
    
//    return self.calendarEvents;
   
}

#pragma mark - Private methods

- (EKEvent *)createEventWithTitle:(NSString *)title
                 andWithStartDate:(NSDate *)startDate
                   andWithEndDate:(NSDate *)endDate
                     andWithNotes:(NSString *)notes {
    EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
    event.title = title;
    event.startDate = startDate;
    event.endDate = endDate;
    event.notes = notes;
    
    NSArray *alarms = [NSArray arrayWithObjects:[self createAlarmWithRelativeOffset:ONE_DAY], [self createAlarmWithRelativeOffset:ONE_HOUR], nil];
    [event setAlarms:alarms];
    
    return event;
}

- (void)saveEvent:(EKEvent *)event {
    NSError *error = nil;
    [self.eventStore saveEvent:event span:EKSpanThisEvent error:&error];
    
    if (error) {
        NSLog(@"Error saving event");
    }
}

- (EKAlarm *)createAlarmWithRelativeOffset:(NSInteger)relativeOffset {
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:relativeOffset];
    return alarm;
}

- (void)deleteEvent:(EKEvent *)event {
    NSError *error = nil;
    [self.eventStore removeEvent:event span:EKSpanThisEvent error:&error];
    
    if (error) {
        NSLog(@"Error deleting event");
    }
}

- (EKReminder *)createReminderWithTitle:(NSString *)title
                       andWithStartDate:(NSDate *)startDate
                           andWithNotes:(NSString *)notes{
    EKReminder *reminder = [EKReminder
                            reminderWithEventStore:self.eventStore];
    reminder.title = title;
    reminder.notes = notes;
    reminder.startDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:startDate];
    
    NSArray *alarms = [NSArray arrayWithObjects:[self createAlarmWithRelativeOffset:ONE_DAY], [self createAlarmWithRelativeOffset:ONE_HOUR], nil];
    [reminder setAlarms:alarms];
    
    return reminder;
}

- (void)saveReminder:(EKReminder *)reminder {
    NSError *error = nil;
    [self.eventStore saveReminder:reminder commit:YES error:&error];
    
    if (error) {
        NSLog(@"Error saving reminder");
    }
}


- (void)storeEventWithIdentifier:(NSString *)identifier
          andWithEventIdentifier:(NSString *)eventIdentifier
       andWithReminderIdentifier:(NSString *)reminderIdentifier {
    NSString *key = identifier;
    NSString *value = [NSString stringWithFormat:@"%@,%@", eventIdentifier, reminderIdentifier];
    
    if (![self getValueForKey:key]) {
        [self storeValue:value forKey:key];
    }
}

- (void)deleteReminder:(EKReminder *)reminder {
    NSError *error = nil;
    [self.eventStore removeReminder:reminder commit:YES error:&error];
    
    if (error) {
        NSLog(@"Error deleting reminder");
    }
}

- (void)removeEventWithKey:(NSString *)key {
    NSString *value = [self getValueForKey:key];
    
    if (value) {
        NSArray *identifierList = [value componentsSeparatedByString:@","];
        NSString *eventIdentifier = [identifierList objectAtIndex:0];
        NSString *reminderIdentifier = [identifierList objectAtIndex:1];
        
        EKEvent *event = [self.eventStore eventWithIdentifier:eventIdentifier];
        [self deleteEvent:event];
        
        EKReminder *reminder = (EKReminder *)[self.eventStore calendarItemWithIdentifier:reminderIdentifier];
        [self deleteReminder:reminder];
        
        [self removeValueForKey:key];
    }
}

- (void)addEventWithTitle:(NSString *)title
         andWithStartDate:(NSDate *)startDate
           andWithEndDate:(NSDate *)endDate
             andWithNotes:(NSString *)notes
               andWithKey:(NSString *)key {
    EKEvent *event = [self createEventWithTitle:title  andWithStartDate:startDate andWithEndDate:endDate andWithNotes:notes];
    [event setCalendar:[self.eventStore defaultCalendarForNewEvents]];
    [self saveEvent:event];
    
    EKReminder *reminder = [self createReminderWithTitle:title andWithStartDate:startDate andWithNotes:notes];
    [reminder setCalendar:[self.eventStore defaultCalendarForNewReminders]];
    [self saveReminder:reminder];
    
    [self storeEventWithIdentifier:key andWithEventIdentifier:event.eventIdentifier andWithReminderIdentifier:reminder.calendarItemIdentifier];
}

- (void)storeValue:(NSString *)value forKey:(NSString *)key {
    NSMutableDictionary *mutableEventDictionary = nil;
    
    NSDictionary *imutableEventDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:CALENDAR_EVENTS_KEY];
    
    if (imutableEventDictionary) {
        mutableEventDictionary = [imutableEventDictionary mutableCopy];
    }
    else {
        mutableEventDictionary = [[NSMutableDictionary alloc] init];
    }
    
    [mutableEventDictionary setValue:value forKey:key];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableEventDictionary forKey:CALENDAR_EVENTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)getValueForKey:(NSString *)key {
    NSDictionary *imutableEventDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:CALENDAR_EVENTS_KEY];
    return [imutableEventDictionary valueForKey:key];
}

- (void)removeValueForKey:(NSString *)key {
    NSMutableDictionary *mutableEventDictionary = nil;
    
    NSDictionary *imutableEventDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:CALENDAR_EVENTS_KEY];
    
    if (imutableEventDictionary) {
        mutableEventDictionary = [imutableEventDictionary mutableCopy];
    }
    else {
        mutableEventDictionary = [[NSMutableDictionary alloc] init];
    }
    
    [mutableEventDictionary removeObjectForKey:key];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableEventDictionary forKey:CALENDAR_EVENTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end

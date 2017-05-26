//
//  CalendarService.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 5/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarService : NSObject

+ (CalendarService *)sharedInstance;

- (void)addEventWithTitle:(NSString *)title
         andWithStartDate:(NSDate *)startDate
           andWithEndDate:(NSDate *)endDate
             andWithNotes:(NSString *)notes
        andWithIdentifier:(NSString *)identifier accessDenied:(void (^)(void))accessDenied accessGranted:(void (^)(void))accessGranted;

- (void)removeEvent:(NSString *)identifier accessDenied:(void (^)(void))accessDenied accessGranted:(void (^)(void))accessGranted;

- (BOOL)isEventAvailableForId:(NSString *)identifier;

-(NSMutableArray *)getAllCalendarEvents;

@end

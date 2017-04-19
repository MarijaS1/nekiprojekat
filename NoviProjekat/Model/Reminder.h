//
//  Reminder.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 4/17/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car;

NS_ASSUME_NONNULL_BEGIN

@interface Reminder : NSManagedObject

@property (nonatomic) int32_t reminderID;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *message;
@property (nullable, nonatomic, retain) Car *hasCarRelationship;
@end

NS_ASSUME_NONNULL_END

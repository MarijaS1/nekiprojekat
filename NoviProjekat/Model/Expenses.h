//
//  Expenses.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 4/17/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car;

NS_ASSUME_NONNULL_BEGIN

@interface Expenses : NSManagedObject

@property (nonatomic) int32_t expensesID;
@property (nullable, nonatomic, copy) NSString *purpose;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nonatomic) double amount;
@property (nullable, nonatomic, retain) Car *hasCarRelationship;

@end


NS_ASSUME_NONNULL_END

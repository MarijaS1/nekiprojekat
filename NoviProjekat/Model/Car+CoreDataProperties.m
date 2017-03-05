//
//  Car+CoreDataProperties.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 3/5/17.
//  Copyright © 2017 Admin. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Car+CoreDataProperties.h"

@implementation Car (CoreDataProperties)

+ (NSFetchRequest<Car *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Car"];
}

@dynamic carID;
@dynamic registration;
@dynamic type;
@dynamic brandName;
@dynamic hasOwnerRelationship;
@dynamic hasReminderRelationship;
@dynamic hasExpensesRelationship;

@end

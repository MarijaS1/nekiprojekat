//
//  Expenses+CoreDataProperties.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 3/5/17.
//  Copyright © 2017 Admin. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Expenses+CoreDataProperties.h"

@implementation Expenses (CoreDataProperties)

+ (NSFetchRequest<Expenses *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Expenses"];
}

@dynamic expensesID;
@dynamic purpose;
@dynamic date;
@dynamic amount;
@dynamic hasCarRelationship;

@end

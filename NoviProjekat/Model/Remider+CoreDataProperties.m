//
//  Remider+CoreDataProperties.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 3/5/17.
//  Copyright © 2017 Admin. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Remider+CoreDataProperties.h"

@implementation Remider (CoreDataProperties)

+ (NSFetchRequest<Remider *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Remider"];
}

@dynamic reminderID;
@dynamic date;
@dynamic type;
@dynamic message;
@dynamic hasCarRelationship;

@end

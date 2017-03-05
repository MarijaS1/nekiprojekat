//
//  Expenses+CoreDataProperties.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 3/5/17.
//  Copyright © 2017 Admin. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Expenses+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Expenses (CoreDataProperties)

+ (NSFetchRequest<Expenses *> *)fetchRequest;

@property (nonatomic) int32_t expensesID;
@property (nullable, nonatomic, copy) NSString *purpose;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nonatomic) double amount;
@property (nullable, nonatomic, retain) Car *hasCarRelationship;

@end

NS_ASSUME_NONNULL_END

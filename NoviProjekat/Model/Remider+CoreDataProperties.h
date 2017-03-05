//
//  Remider+CoreDataProperties.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 3/5/17.
//  Copyright © 2017 Admin. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Remider+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Remider (CoreDataProperties)

+ (NSFetchRequest<Remider *> *)fetchRequest;

@property (nonatomic) int32_t reminderID;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *message;
@property (nullable, nonatomic, retain) Car *hasCarRelationship;

@end

NS_ASSUME_NONNULL_END

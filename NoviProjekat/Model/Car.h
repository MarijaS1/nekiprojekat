//
//  Car.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 4/17/17.
//  Copyright © 2017 Admin. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Expenses, Remider, User;

NS_ASSUME_NONNULL_BEGIN

@interface Car : NSManagedObject

@property (nonatomic) int32_t carID;
@property (nullable, nonatomic, copy) NSString *registration;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *brandName;
@property (nullable, nonatomic, copy) NSData *image;
@property (nullable, nonatomic, retain) User *hasOwnerRelationship;
@property (nullable, nonatomic, retain) NSOrderedSet<Remider *> *hasReminderRelationship;
@property (nullable, nonatomic, retain) NSOrderedSet<Expenses *> *hasExpensesRelationship;
@end

@interface Car (CoreDataGeneratedAccessors)

- (void)insertObject:(Remider *)value inHasReminderRelationshipAtIndex:(NSUInteger)idx;
- (void)removeObjectFromHasReminderRelationshipAtIndex:(NSUInteger)idx;
- (void)insertHasReminderRelationship:(NSArray<Remider *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeHasReminderRelationshipAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInHasReminderRelationshipAtIndex:(NSUInteger)idx withObject:(Remider *)value;
- (void)replaceHasReminderRelationshipAtIndexes:(NSIndexSet *)indexes withHasReminderRelationship:(NSArray<Remider *> *)values;
- (void)addHasReminderRelationshipObject:(Remider *)value;
- (void)removeHasReminderRelationshipObject:(Remider *)value;
- (void)addHasReminderRelationship:(NSOrderedSet<Remider *> *)values;
- (void)removeHasReminderRelationship:(NSOrderedSet<Remider *> *)values;

- (void)insertObject:(Expenses *)value inHasExpensesRelationshipAtIndex:(NSUInteger)idx;
- (void)removeObjectFromHasExpensesRelationshipAtIndex:(NSUInteger)idx;
- (void)insertHasExpensesRelationship:(NSArray<Expenses *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeHasExpensesRelationshipAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInHasExpensesRelationshipAtIndex:(NSUInteger)idx withObject:(Expenses *)value;
- (void)replaceHasExpensesRelationshipAtIndexes:(NSIndexSet *)indexes withHasExpensesRelationship:(NSArray<Expenses *> *)values;
- (void)addHasExpensesRelationshipObject:(Expenses *)value;
- (void)removeHasExpensesRelationshipObject:(Expenses *)value;
- (void)addHasExpensesRelationship:(NSOrderedSet<Expenses *> *)values;
- (void)removeHasExpensesRelationship:(NSOrderedSet<Expenses *> *)values;

@end

NS_ASSUME_NONNULL_END

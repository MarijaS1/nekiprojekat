//
//  User.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 4/17/17.
//  Copyright © 2017 Admin. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car;

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

@property (nonatomic) int32_t userID;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, retain) NSOrderedSet<Car *> *hasCarRelationship;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)insertObject:(Car *)value inHasCarRelationshipAtIndex:(NSUInteger)idx;
- (void)removeObjectFromHasCarRelationshipAtIndex:(NSUInteger)idx;
- (void)insertHasCarRelationship:(NSArray<Car *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeHasCarRelationshipAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInHasCarRelationshipAtIndex:(NSUInteger)idx withObject:(Car *)value;
- (void)replaceHasCarRelationshipAtIndexes:(NSIndexSet *)indexes withHasCarRelationship:(NSArray<Car *> *)values;
- (void)addHasCarRelationshipObject:(Car *)value;
- (void)removeHasCarRelationshipObject:(Car *)value;
- (void)addHasCarRelationship:(NSOrderedSet<Car *> *)values;
- (void)removeHasCarRelationship:(NSOrderedSet<Car *> *)values;

@end


NS_ASSUME_NONNULL_END

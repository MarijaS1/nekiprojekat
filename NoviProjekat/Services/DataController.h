//
//  DataController.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 4/17/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Car.h"
#import "User.h"

@interface DataController : NSObject

@property (strong, nonatomic) Car *carInfo;
@property (strong, nonatomic) User *userInfo;
@property (strong, nonatomic) NSNumber *userId;
@property (nonatomic) BOOL isLoggedIn;

+ (DataController *)sharedInstance;

- (User *)getUserInfo;
- (void)setUserInfo:(User *)userInfo;
- (void)clearUserInfo;
- (void) saveUserId: (NSNumber *) userId;
- (NSNumber*) getUserId;
- (void) clearUserId;


@end

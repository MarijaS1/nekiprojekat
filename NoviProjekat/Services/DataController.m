//
//  DataController.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 4/17/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "DataController.h"


@implementation DataController

static DataController *sharedDataController = nil;

+ (DataController *)sharedInstance
{
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^
                  {
                      sharedDataController = [[DataController alloc] init];
                  });
    return sharedDataController;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        self.isLoggedIn = NO;
        
        
    }
    return self;
}

#pragma mark - Public methods

- (void)clearUserInfo
{
    [self setUserInfo:nil];
}

- (User *)getUserInfo
{
    return _userInfo;
}

- (void)setUserInfo:(User *)userInfo
{
    _userInfo = userInfo;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:userInfo] forKey:@"userInfo"];
    [defaults synchronize];
}

- (NSNumber*) getUserId
{
    return self.userId;
}

- (void) saveUserId: (NSNumber *) userId
{
    self.userId = userId;
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) clearUserId
{
    [self saveUserId:nil];
}


@end


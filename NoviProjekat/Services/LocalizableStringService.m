//
//  LocalizableStringService.m
//  Undecided
//
//  Created by Petar on 5/19/16.
//  Copyright © 2016 Petar Glisovic. All rights reserved.
//

#import "LocalizableStringService.h"

@implementation LocalizableStringService

static LocalizableStringService *shared = nil;

+ (LocalizableStringService *)sharedInstance {
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        shared = [[LocalizableStringService alloc] init];
    });
    
    return shared;
}

-(NSString *) getLocalizableStringForType:(NSString *) type
                               andSybtype:(NSString *)subtype
                                andSuffix:(NSString *)suffix {
    
    NSString *string = nil;
    
    NSMutableString *mKey = [NSMutableString stringWithString:@""];
    if ([type length]) {
        [mKey appendString:type];
    }
    
    if ([subtype length]) {
        [mKey appendString:[NSString stringWithFormat:@"_%@", subtype]];
    }
    
    if ([suffix length]) {
        [mKey appendString:[NSString stringWithFormat:@"_%@", suffix]];
    }
    NSString *key = [NSString stringWithString:mKey];
    
    string = NSLocalizedString(key, nil);
    
    return string;
}

@end

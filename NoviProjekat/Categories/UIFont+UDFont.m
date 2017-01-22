//
//  UIFont+UDFont.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 1/22/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "UIFont+UDFont.h"

@implementation UIFont (UDFont)

+ (UIFont *)getRegularFontForSize:(CGFloat) fSize {
    return [UIFont fontWithName:@"HelveticaNeue" size:fSize];
}

+ (UIFont *)getItalicFontForSize:(CGFloat) fSize {
    return [UIFont fontWithName:@"HelveticaNeue-Italic" size:fSize];
}

+ (UIFont *)getBoldFontForSize:(CGFloat) fSize {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:fSize];
}

@end

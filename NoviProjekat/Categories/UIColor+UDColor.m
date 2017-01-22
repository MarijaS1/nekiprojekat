//
//  UIColor+UDColor.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 1/22/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "UIColor+UDColor.h"

#define ALPHA_1                   1.0

@implementation UIColor (UDColor)

+ (UIColor *)getPinkColor {
    return [UIColor colorWithRed:238/255.0 green:0/255.0 blue:139/255.0 alpha:ALPHA_1];
}

+ (UIColor *)getVeryDarkGreyColor {
    return [UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:ALPHA_1];
}

+ (UIColor *)getDarkGreyColor {
    return [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:ALPHA_1];
}

+ (UIColor *)getGreyColor {
    return [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:ALPHA_1];
}

+ (UIColor *)getMidGreyColor {
    return [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:ALPHA_1];
}

+ (UIColor *)getLightGreyColor {
    return [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:ALPHA_1];
}

+ (UIColor *)getVeryLightGreyColor {
    return [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:ALPHA_1];
}

+ (UIColor *)getWhiteColor {
    return [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:ALPHA_1];
}

+ (UIColor *)getFBBlueColor {
    return [UIColor colorWithRed:59/255.0 green:89/255.0 blue:152/255.0 alpha:ALPHA_1];
}

@end

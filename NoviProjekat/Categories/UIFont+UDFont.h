//
//  UIFont+UDFont.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 1/22/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (UDFont)

/*
 *This method return regular HelveticaNeue font for certain font size
 */
+ (UIFont *)getRegularFontForSize:(CGFloat) fSize;

/*
 *This method return italic HelveticaNeue font for certain font size
 */
+ (UIFont *)getItalicFontForSize:(CGFloat) fSize;

/*
 *This method return bold HelveticaNeue font for certain font size
 */
+ (UIFont *)getBoldFontForSize:(CGFloat) fSize;

@end

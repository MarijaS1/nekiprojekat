//
//  BasicViewController.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 1/22/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#define WARNING_TOAST                       0
#define INFO_TOAST                          1
#define ERROR_TOAST                         2

@interface BasicViewController : UIViewController
- (void) showProgressWithInfoMessage:(NSString *)message;
- (void) showProgressWithInfoMessage:(NSString *)message withTimeoutInterval:(float)timeout;
- (void) showTemporaryInfoMessage:(NSString *)message;
- (void) showTemporaryInfoMessage:(NSString *)message
                     withDuration:(NSTimeInterval) duration;
- (void) updateProgressWithInfoMessage :(NSString *) message;
- (void) hideProgressAndMessage;

/**
 This method shows toast message on top of the screen
 */
- (void) showToastViewWithMesage:(NSString *)message forType:(int) type;

/**
 This method shows alert message on top of the screen
 param: warning title and text
 */
- (void) showAlertPopupWithWarning:(NSString *)warning;

/**
 This method shows alert message on top of the screen
 param: message text
 */
- (void) showAlertPopupWithMessage:(NSString *)text;

/**
 This method shows error alert message on top of the screen
 */
- (void) showErrorAlertPopupWithWarning:(NSString *)warning;


@end

//
//  BasicViewController.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 1/22/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "BasicViewController.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "LocalizableStringService.h"


#define  MIN_TOAST_HEIGHT                   62.0

@interface BasicViewController ()

@property (strong, nonatomic) NSTimer *timerProgress;
@property (nonatomic) BOOL isProgressViewShown;
@property (nonatomic) float timeoutInterval;

@end

@implementation BasicViewController {
    
    CSToastStyle *myStyle;
}

static MBProgressHUD *mbProgressHud;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self initializeGui];
    
    myStyle = [[CSToastStyle alloc] initWithDefaultStyle];
    myStyle.messageFont =[UIFont getRegularFontForSize:14];
    myStyle.messageColor = [UIColor blackColor];
    myStyle.messageAlignment = NSTextAlignmentLeft;
    myStyle.backgroundColor = [UIColor whiteColor];
    myStyle.cornerRadius = 10;
    myStyle.displayShadow = YES;
    myStyle.imageSize = CGSizeMake(35.0, 35.0);
    //    myStyle.verticalPadding = 5.0;
    
    [CSToastManager setSharedStyle:myStyle];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:33/255.0 green:126/255.0 blue:99/255.0 alpha:1];
}

- (void) initializeGui {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    if (!mbProgressHud) {
        mbProgressHud = [[MBProgressHUD alloc] initWithView:appDelegate.window];
    }
    
    self.isProgressViewShown = NO;
}

- (void) showProgressWithInfoMessage:(NSString *)message withTimeoutInterval:(float)timeout{
    self.timeoutInterval = timeout>0?timeout:30.0;
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.appDelegate.window addSubview:mbProgressHud];
    mbProgressHud.mode = MBProgressHUDModeIndeterminate;
    mbProgressHud.label.text = @"";
    mbProgressHud.detailsLabel.text = message;
    self.isProgressViewShown = YES;
    
    [self startTimer];
    
    [mbProgressHud showAnimated:YES];
}

- (void) showProgressWithInfoMessage:(NSString *)message
{
    [self showProgressWithInfoMessage:message withTimeoutInterval:30.0];
}

- (void) showTemporaryInfoMessage:(NSString *)message {
    [self showTemporaryInfoMessage:message withDuration:2];
}


- (void) showTemporaryInfoMessage:(NSString *)message
                     withDuration:(NSTimeInterval) duration
{
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.appDelegate.window addSubview:mbProgressHud];
    mbProgressHud.customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 1)];
    mbProgressHud.customView.backgroundColor = [UIColor clearColor];
    mbProgressHud.mode = MBProgressHUDModeCustomView;
    [mbProgressHud showAnimated:YES];
    mbProgressHud.label.text = @"";
    mbProgressHud.detailsLabel.text = message;
    self.isProgressViewShown = YES;
    [self killTimer];
    [mbProgressHud hideAnimated:YES afterDelay:duration];
}

- (void) updateProgressWithInfoMessage :(NSString *) message
{
    mbProgressHud.label.text = @"";
    mbProgressHud.detailsLabel.text = message;
}

- (void) hideProgressAndMessage
{
    self.isProgressViewShown = NO;
    [mbProgressHud hideAnimated:YES];
    [mbProgressHud removeFromSuperview];
    [self killTimer];
}

/*--------------------------------------------------------------
 * Timer for Spinner
 *-------------------------------------------------------------*/

- (void) killTimer
{
    [self clearTimeProgress];
}

- (void) stopTimer
{
    [self clearTimeProgress];
    
    if (self.isProgressViewShown)
    {
        [self showTemporaryInfoMessage:[[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_ALERT andSybtype:SUBTYPE_MESSAGE andSuffix:@"servicetimeout"]];
    }
    
    
}

- (void) startTimer
{
    [self clearTimeProgress];
    
    @synchronized (self)
    {
        self.timerProgress = [NSTimer scheduledTimerWithTimeInterval:self.timeoutInterval
                                                              target:self
                                                            selector:@selector(stopTimer)
                                                            userInfo:nil
                                                             repeats:NO];
    }
}

- (void) clearTimeProgress
{
    @synchronized (self)
    {
        if (self.timerProgress)
        {
            [self.timerProgress invalidate];
            self.timerProgress = nil;
        }
    }
}

- (void) showToastViewWithMesage:(NSString *)message forType:(int) type {
    
    [self hideProgressAndMessage];
    
    UIImage *image;
    float heightText = [message boundingRectWithSize:CGSizeMake(self.view.frame.size.width-107, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont getRegularFontForSize:12] } context:nil].size.height;
    
    
    // Show a custom view as toast
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-40, (ceilf(heightText) < MIN_TOAST_HEIGHT) ? MIN_TOAST_HEIGHT : 20+ ceilf(heightText))];
    [customView setBackgroundColor:[UIColor getWhiteColor]];
    
    [[customView layer] setBorderColor:[[UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1.0] CGColor]];
    [[customView layer] setBorderWidth:.4];
    [[customView layer] setCornerRadius:8.0f];
    
    customView.layer.masksToBounds = NO;
    customView.layer.shadowOffset = CGSizeMake(0, 2);
    customView.layer.shadowRadius = 5;
    customView.layer.shadowOpacity = 0.2;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (ceilf(heightText) < MIN_TOAST_HEIGHT) ? 20 : (20+ceilf(heightText)-22)/2, 22, 22)];
    [iconImageView setBackgroundColor:[UIColor clearColor]];
    [customView addSubview:iconImageView];
    
    if (type == ERROR_TOAST) {
        image = [UIImage imageNamed:@"icon_error"];
    }
    else if (type == WARNING_TOAST) {
        image = [UIImage imageNamed:@"icon_warning"];
    }
    else if (type == INFO_TOAST) {
        image = [UIImage imageNamed:@"icon_information"];
        
    }
    [iconImageView setImage:image];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, (ceilf(heightText) < MIN_TOAST_HEIGHT) ? (MIN_TOAST_HEIGHT-ceilf(heightText))/2 : 10, self.view.frame.size.width-107, ceilf(heightText))];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [messageLabel setTextColor:[UIColor getDarkGreyColor]];
    [messageLabel setTextAlignment:NSTextAlignmentLeft];
    [messageLabel setFont:[UIFont getRegularFontForSize:12]];
    [messageLabel setNumberOfLines:0];
    [messageLabel setText:message];
    [customView addSubview:messageLabel];
    
    [self.view.window showToast:customView duration:3.0 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, 130)] completion:nil];
    
}

- (void) showAlertPopupWithTitle:(NSString *)title
                      andMessage:(NSString *)message
                  andButtonTitle:(NSString *)buttonTitle {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction
                             actionWithTitle:buttonTitle
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void) showAlertPopupWithWarning:(NSString *)warning {
    [self hideProgressAndMessage];
    
    NSString* title = [[[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_ALERT andSybtype:SUBTYPE_TITLE andSuffix:warning] length] ? [[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_ALERT andSybtype:SUBTYPE_TITLE andSuffix:warning] : @"";
    NSString* message = [[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_ALERT andSybtype:SUBTYPE_MESSAGE andSuffix:warning];
    NSString* buttontitle = [[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_ALERT andSybtype:SUBTYPE_BUTTONTITLE andSuffix:warning];
    
    [self showAlertPopupWithTitle:title andMessage:message andButtonTitle:buttontitle];
    
}

- (void) showAlertPopupWithMessage:(NSString *)text {
    [self hideProgressAndMessage];
    
    NSString* title = [[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_ALERT andSybtype:SUBTYPE_TITLE andSuffix:@"error"];
    NSString* message = text;
    NSString* buttontitle = [[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_ALERT andSybtype:SUBTYPE_BUTTONTITLE andSuffix:@"warning"];
    
    [self showAlertPopupWithTitle:title andMessage:message andButtonTitle:buttontitle];
    
}

- (void) showErrorAlertPopupWithWarning:(NSString *)warning {
    [self hideProgressAndMessage];
    
    NSString* title = [[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_REST andSybtype:SUBTYPE_TITLE andSuffix:nil];
    NSString* buttontitle = [[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_REST andSybtype:SUBTYPE_BUTTONTITLE andSuffix:nil];
    
    [self showAlertPopupWithTitle:title andMessage:warning andButtonTitle:buttontitle];
    
}


@end

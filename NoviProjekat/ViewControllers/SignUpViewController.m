//
//  SignUpViewController.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 3/21/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "SignUpViewController.h"
#import "User.h"
#import "Car.h"
#import "AppDelegate.h"
#import "ParkingViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGui];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

-(void)initGui {
//    UIImage *leftImage = [UIImage imageNamed:@"icon_pinkback"];
    [self.navigationController.navigationBar setHidden:NO];
    
    
//    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
}

- (IBAction)registerButtonPressed:(id)sender {
    NSError *error = nil;
    
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    Car *car = [NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:self.appDelegate.managedObjectContext];
    car.type = self.typeOfCarTextField.text;
    car.brandName = self.brandNameTextField.text;
    car.registration = self.registrationPlateTextField.text;
    
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.appDelegate.managedObjectContext];
    user.username = self.usernameTextField.text;
    user.email = self.emailTextField.text;
    user.password = self.passwordTextField.text;
    
    [user addHasCarRelationshipObject:car];
    
    if (![self.appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Great, error while fixing error; couldn't save: %@", [error localizedDescription]);
    } else {
        NSLog(@"User and car saved");
        [DataController sharedInstance].carInfo = car;
        UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainTabBar"];
        tabBarController.selectedIndex=0;
        UINavigationController *nav = [tabBarController.viewControllers objectAtIndex:0];
        ParkingViewController *parkingVC = (ParkingViewController*) [nav.viewControllers objectAtIndex:0];
        parkingVC.car = car;
        [self presentViewController:tabBarController animated:YES completion:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

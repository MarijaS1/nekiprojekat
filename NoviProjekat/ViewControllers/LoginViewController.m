//
//  LoginViewController.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 3/21/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "User.h"
#import "ParkingViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signInButtonPressed:(UIButton *)sender {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"username" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"username = %@", self.emailTextField.text];
    NSError *error = nil;
    NSArray *matches = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    if (!matches || error || (matches.count > 1)) {
        NSLog(@"Error while getting users");
    }else if([matches count] == 0){
        [self showTemporaryInfoMessage:@"Korisnik ne postoji!"];
    }else if ([matches count] == 1){
        User *user = [matches lastObject];
        [DataController sharedInstance].userInfo = user;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Car"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"brandName" ascending:NO]];
        [request setReturnsObjectsAsFaults:NO];
        request.predicate = [NSPredicate predicateWithFormat:@"hasOwnerRelationship = %@", user.objectID];
        NSError *error = nil;
        NSArray *matches = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
        if (!matches || error || (matches.count > 1)) {
            NSLog(@"Error while getting car");
        }else if ([matches count] == 1){
            Car *car = [matches lastObject];
            [DataController sharedInstance].carInfo = car;
            UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainTabBar"];
            tabBarController.selectedIndex=0;
            UINavigationController *nav = [tabBarController.viewControllers objectAtIndex:1];
            ParkingViewController *parkingVC = (ParkingViewController*) [nav.viewControllers objectAtIndex:0];
            parkingVC.car = car;
            [self presentViewController:tabBarController animated:YES completion:nil];
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedIn"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (IBAction)registerButtonPressed:(UIButton *)sender {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    SignUpViewController *signUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"signUpViewController"];
     [self.navigationController pushViewController:signUpViewController animated:YES];
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

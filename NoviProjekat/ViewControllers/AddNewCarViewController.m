//
//  AddNewCarViewController.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 7/22/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "AddNewCarViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "AppDelegate.h"

@interface AddNewCarViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UITextField *carPlateTextField;
@property (weak, nonatomic) IBOutlet UITextField *carBrandtextField;
@property (weak, nonatomic) IBOutlet UITextField *carTypeTextField;
@property (weak, nonatomic) IBOutlet UIButton *addCarButton;

@end

@implementation AddNewCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGui];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initGui {
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (self.carImageView.frame.size.width), (self.carImageView.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setBorderWidth:1.0f];
    [borderLayer setBorderColor:[[UIColor getGreyColor] CGColor]];
    [self.carImageView.layer addSublayer:borderLayer];
}
- (IBAction)addCarButtonPressed:(UIButton *)sender {
    NSError *error = nil;
    
    Car *car = [NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:self.appDelegate.managedObjectContext];
    car.type = self.carTypeTextField.text;
    car.brandName = self.carBrandtextField.text;
    car.registration = self.carPlateTextField.text;
    car.hasOwnerRelationship = [DataController sharedInstance].userInfo;
//     [[DataController sharedInstance].userInfo addHasCarRelationshipObject:car];
    
    
    if (![self.appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Great, error while fixing error; couldn't save: %@", [error localizedDescription]);
    } else {
        NSLog(@"Car saved");
//        [DataController sharedInstance].userInfo = user;
//        [DataController sharedInstance].carInfo = car;
//        UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainTabBar"];
//        tabBarController.selectedIndex=0;
//        UINavigationController *nav = [tabBarController.viewControllers objectAtIndex:1];
//        ParkingViewController *parkingVC = (ParkingViewController*) [nav.viewControllers objectAtIndex:0];
//        parkingVC.car = car;
//        [self presentViewController:tabBarController animated:YES completion:nil];
//        //        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedIn"];
//        //        [[NSUserDefaults standardUserDefaults] synchronize];
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

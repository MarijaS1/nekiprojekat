//
//  SecondViewController.h
//  NoviProjekat
//
//  Created by Admin on 10/12/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "Car.h"

@interface ParkingViewController : BasicViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *registrationPlatesLabel;

@property (strong, nonatomic) Car *car;

@end


//
//  AutoViewController.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 5/16/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"

@interface AutoViewController : BasicViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addCarBarButtonItem;

@end

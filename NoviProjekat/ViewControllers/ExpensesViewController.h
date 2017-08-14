//
//  ExpensesViewController.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 8/9/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpensesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControll;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PieChartView *pieChartView;
@property (weak, nonatomic) IBOutlet BarChartView *barChartView;

@property (weak, nonatomic) IBOutlet UIView *wholeTableView;
@property (weak, nonatomic) IBOutlet UIView *chartsView;

@end

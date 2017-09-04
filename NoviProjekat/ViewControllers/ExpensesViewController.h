//
//  ExpensesViewController.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 8/9/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"

@interface ExpensesViewController : BasicViewController <UITableViewDelegate, UITableViewDataSource, ChartViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControll;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PieChartView *pieChartView;
@property (weak, nonatomic) IBOutlet BarChartView *barChartView;

@property (weak, nonatomic) IBOutlet UIView *wholeTableView;
@property (weak, nonatomic) IBOutlet UIView *chartsView;
    @property (weak, nonatomic) IBOutlet UILabel *sumAmountLabel;

@end

//
//  ExpensesViewController.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 8/9/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "ExpensesViewController.h"
#import "AddNewExpenseViewController.h"

@interface ExpensesViewController ()

@end

@implementation ExpensesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   self.view.backgroundColor = [UIColor getDarkGreyColor];
    self.wholeTableView.alpha = 1;
    self.chartsView.alpha = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addExpenses:(UIBarButtonItem *)sender {
    AddNewExpenseViewController *addNewExpensesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewExpenseViewController"];
     [self.navigationController pushViewController:addNewExpensesVC animated:YES];
}

- (IBAction)changeView:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self showTableView];
            break;
        case 1:
            [self showCharts];
            break;
            
        default:
            break;
    }
}

-(void)showTableView {
    self.tableView.alpha = 0;
    self.chartsView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.alpha = 1;
    }];
}


-(void)showCharts {
    self.tableView.alpha = 0;
    self.chartsView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.chartsView.alpha = 1;
    }];
}


#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
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

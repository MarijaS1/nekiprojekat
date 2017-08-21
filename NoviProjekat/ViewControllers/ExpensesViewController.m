//
//  ExpensesViewController.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 8/9/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "ExpensesViewController.h"
#import "AddNewExpenseViewController.h"
#import "ExpensesTableViewCell.h"
#import "Expenses.h"
#import "Car.h"
#import "GroupedExpenses.h"
#import  <Charts/Charts-Swift.h>


@interface ExpensesViewController ()

@property (strong, nonatomic) NSMutableArray *expensesArray;
@property (strong, nonatomic) NSMutableArray *groupedArray;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation ExpensesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.expensesArray = [[NSMutableArray alloc]init];
     self.groupedArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
   self.view.backgroundColor = [UIColor getDarkGreyColor];
    self.wholeTableView.alpha = 1;
    self.chartsView.alpha = 0;
    self.dateFormatter = [[NSDateFormatter alloc]init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupPieChart];
    [self setupBarChart];
    [self getData];
    [self getGroupedExpenses];
}



-(void)getData {
    NSError *error = nil;
    //Get expenses
    
    NSFetchRequest *requestExpense = [NSFetchRequest fetchRequestWithEntityName:@"Expenses"];
    requestExpense.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    [requestExpense setReturnsObjectsAsFaults:NO];
    
    NSArray *matchesExpense = [self.appDelegate.managedObjectContext executeFetchRequest:requestExpense error:&error];
    if (!matchesExpense || error ) {
        NSLog(@"Error while getting expenses");
    }else if ([matchesExpense count]){
        self.expensesArray = [matchesExpense mutableCopy];
        [self.tableView reloadData];
    }
    

}

-(void)getGroupedExpenses {
    NSError *error = nil;
    //Get expenses
    
    NSFetchRequest *requestExpense = [NSFetchRequest fetchRequestWithEntityName:@"Expenses"];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expenses" inManagedObjectContext:self.appDelegate.managedObjectContext];
    requestExpense.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    [requestExpense setReturnsObjectsAsFaults:NO];
     NSAttributeDescription* purposeDesc = [entity.attributesByName objectForKey:@"purpose"];
    NSAttributeDescription* amountDesc = [entity.attributesByName objectForKey:@"amount"];
     [requestExpense setPropertiesToGroupBy:[NSArray arrayWithObjects:purposeDesc, amountDesc, nil]];
      [requestExpense setPropertiesToFetch:[NSArray arrayWithObjects:purposeDesc, amountDesc, nil]];
    [requestExpense setResultType:NSDictionaryResultType];
    NSArray *matchesExpense = [self.appDelegate.managedObjectContext executeFetchRequest:requestExpense error:&error];
    if (!matchesExpense || error ) {
        NSLog(@"Error while getting expenses");
    }else if ([matchesExpense count]){
        self.groupedArray = [matchesExpense mutableCopy];
        [self updateChartData];
        
//        [self.tableView reloadData];
    }
    
    
}

-(void)setupPieChart{
   
        self.pieChartView.usePercentValuesEnabled = YES;
        self.pieChartView.drawSlicesUnderHoleEnabled = NO;
        self.pieChartView.holeRadiusPercent = 0.33;
        self.pieChartView.transparentCircleRadiusPercent = 0;
        self.pieChartView.chartDescription.enabled = NO;
        [self.pieChartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
        
        self.pieChartView.drawCenterTextEnabled = NO;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = NSTextAlignmentCenter;
    
        
        self.pieChartView.drawHoleEnabled = YES;
        self.pieChartView.rotationAngle = 0.0;
        self.pieChartView.rotationEnabled = YES;
        self.pieChartView.highlightPerTapEnabled = YES;
        
        ChartLegend *l = self.pieChartView.legend;
        l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
        l.verticalAlignment = ChartLegendVerticalAlignmentTop;
        l.orientation = ChartLegendOrientationHorizontal;
        l.drawInside = YES;
        l.xEntrySpace = 0.0;
        l.yEntrySpace = 1.0;
        l.yOffset = 0.0;
    
    
    _pieChartView.delegate = self;

    
    // entry label styling
    _pieChartView.entryLabelColor = UIColor.whiteColor;
    _pieChartView.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
//    
//   
//    [self slidersValueChanged:nil];
    [self updateChartData];
    
    [_pieChartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
}

-(void)setupBarChart{
    self.barChartView.chartDescription.enabled = NO;
    
    self.barChartView.drawGridBackgroundEnabled = NO;
    
    self.barChartView.dragEnabled = YES;
    [self.barChartView setScaleEnabled:YES];
    self.barChartView.pinchZoomEnabled = NO;
    
    // ChartYAxis *leftAxis = chartView.leftAxis;
    
    
    
    self.barChartView.rightAxis.enabled = NO;

    
    self.barChartView.delegate = self;
    
    self.barChartView.drawBarShadowEnabled = NO;
    self.barChartView.drawValueAboveBarEnabled = YES;
    
    self.barChartView.maxVisibleCount = 60;
    
    ChartXAxis *xAxis = self.barChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.granularity = 1.0; // only intervals of 1 day
    xAxis.labelCount = 7;
//    xAxis.valueFormatter = [[DayAxisValueFormatter alloc] initForChart:self.barChartView];
    
    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
    leftAxisFormatter.minimumFractionDigits = 0;
    leftAxisFormatter.maximumFractionDigits = 1;
    leftAxisFormatter.negativeSuffix = @" $";
    leftAxisFormatter.positiveSuffix = @" $";
    
    ChartYAxis *leftAxis = self.barChartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.labelCount = 8;
    leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.spaceTop = 0.15;
    leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartYAxis *rightAxis = self.barChartView.rightAxis;
    rightAxis.enabled = YES;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
    rightAxis.labelCount = 8;
    rightAxis.valueFormatter = leftAxis.valueFormatter;
    rightAxis.spaceTop = 0.15;
    rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartLegend *l = self.barChartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    l.form = ChartLegendFormSquare;
    l.formSize = 9.0;
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    l.xEntrySpace = 4.0;
    
//    XYMarkerView *marker = [[XYMarkerView alloc]
//                            initWithColor: [UIColor colorWithWhite:180/255. alpha:1.0]
//                            font: [UIFont systemFontOfSize:12.0]
//                            textColor: UIColor.whiteColor
//                            insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)
//                            xAxisValueFormatter: _chartView.xAxis.valueFormatter];
//    marker.chartView = self.barChartView;
//    marker.minimumSize = CGSizeMake(80.f, 40.f);
//    self.barChartView.marker = marker;
    

}

- (void)updateChartData
{
    
    [self setDataCount:(int)self.groupedArray.count range:(int)self.expensesArray.count];
}

- (void)setDataCount:(int)count range:(double)range
{
    double mult = range;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        
       
        [values addObject:[[PieChartDataEntry alloc] initWithValue:((NSString*)[((NSDictionary*)self.groupedArray[i]) valueForKey:@"amount"]).doubleValue label: [((NSDictionary*)self.groupedArray[i]) valueForKey:@"purpose"]]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values ];
    
//    BarChartDataSet *barDataSet = [[BarChartDataSet alloc] initWithValues:values];
    
    dataSet.drawValuesEnabled = YES;
//    barDataSet.drawValuesEnabled = YES;
    
    dataSet.sliceSpace = 1.0;
//    dataSet.iconsOffset = CGPointMake(0, 40);
    
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.getDarkGreyColor];
    
    self.pieChartView.data = data;
    [self.pieChartView highlightValues:nil];
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
    return self.expensesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExpensesTableViewCell *cell= (ExpensesTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"ExpensesTableViewCell" forIndexPath:indexPath];
    Expenses *expense = ((Expenses*)self.expensesArray[indexPath.row]);
    cell.amountLabel.text = [NSString stringWithFormat:@"%2.f", expense.amount] ;
    cell.purposeLabel.text = expense.purpose;
    self.dateFormatter.dateFormat = @"dd/MM/yyyy";
    cell.dateLabel.text = [self.dateFormatter stringFromDate:expense.date];
    Car *car = expense.hasCarRelationship;
    cell.carLabel.text = [NSString stringWithFormat:@"%@ %@", car.brandName, car.type];
    
    if ([expense.purpose isEqualToString:@"Gorivo"]) {
        cell.expenseImageView.image = [UIImage imageNamed:@"fuel"];
        cell.expenseImageView.backgroundColor = UIColor.getGreenColor;
    }else if ([expense.purpose isEqualToString:@"Pranje automobila"]) {
        cell.expenseImageView.image = [UIImage imageNamed:@"car_wash"];
        cell.expenseImageView.backgroundColor = UIColor.getGreenColor;
    }else if ([expense.purpose isEqualToString:@"Popravka"]) {
        cell.expenseImageView.image = [UIImage imageNamed:@"repair"];
        cell.expenseImageView.backgroundColor = UIColor.clearColor;
    }else if ([expense.purpose isEqualToString:@"Auto delovi"]) {
        cell.expenseImageView.image = [UIImage imageNamed:@"battery"];
        cell.expenseImageView.backgroundColor = UIColor.getGreenColor;
    }else if ([expense.purpose isEqualToString:@"Registracija"]) {
        cell.expenseImageView.image = [UIImage imageNamed:@"card"];
        cell.expenseImageView.backgroundColor = UIColor.clearColor;
    }else if ([expense.purpose isEqualToString:@"Ostalo"]) {
        cell.expenseImageView.image = [UIImage imageNamed:@"write"];
        cell.expenseImageView.backgroundColor = UIColor.clearColor;
    }
    
    
    return  cell;
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

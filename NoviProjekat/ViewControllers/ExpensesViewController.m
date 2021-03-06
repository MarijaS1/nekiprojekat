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
#import "LabelChartValueFormatter.h"


@interface ExpensesViewController () <FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance,UIGestureRecognizerDelegate>
    {
        void * _KVOContext;
    }

@property (strong, nonatomic) NSMutableArray *expensesArray;
@property (strong, nonatomic) NSMutableArray *groupedArray;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;

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
    
    if ([[UIDevice currentDevice].model hasPrefix:@"iPad"]) {
        self.calendarHeightConstraint.constant = 400;
    }
    
    [self.calendar selectDate:[NSDate date] scrollToDate:YES];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 2;
    [self.view addGestureRecognizer:panGesture];
    self.scopeGesture = panGesture;
    
    // While the scope gesture begin, the pan gesture of tableView should cancel.
    [self.tableView.panGestureRecognizer requireGestureRecognizerToFail:panGesture];
    
    [self.calendar addObserver:self forKeyPath:@"scope" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_KVOContext];
    
    self.calendar.scope = FSCalendarScopeWeek;
    self.calendar.appearance.headerTitleColor = [UIColor getGreenColor];
    self.calendar.appearance.weekdayTextColor = [UIColor blackColor];
    self.calendar.backgroundColor = [UIColor getGreyColor];
    self.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"sr"];
    self.emptyView.hidden = YES;
}
    
    

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getDataWithDate:nil];
    [self getGroupedExpenses];
    
}



    -(void)getDataWithDate:(NSDate*)date {
    NSError *error = nil;
   

    NSFetchRequest *requestExpense = [NSFetchRequest fetchRequestWithEntityName:@"Expenses"];
    requestExpense.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        if (date != nil) {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth  | NSCalendarUnitDay) fromDate:date];
            //create a date with these components
            NSDate *startDate = [calendar dateFromComponents:components];
            [components setMonth:0];
            [components setDay:1]; //reset the other components
            [components setYear:0]; //reset the other components
            NSDate *endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
           
            requestExpense.predicate = [NSPredicate predicateWithFormat:@"((date >= %@) AND (date <= %@)) || (date = nil)",startDate,endDate];


        }
    [requestExpense setReturnsObjectsAsFaults:NO];
    
    NSArray *matchesExpense = [self.appDelegate.managedObjectContext executeFetchRequest:requestExpense error:&error];
    if (!matchesExpense || error ) {
        NSLog(@"Error while getting expenses");
        self.emptyView.hidden = YES;
    }else if ([matchesExpense count]){
        [self.expensesArray removeAllObjects];
        self.expensesArray = [matchesExpense mutableCopy];
        [self.tableView reloadData];
        self.emptyView.hidden = YES;
    }else{
        self.emptyView.hidden = NO;
    }
    
    
}
    

-(void)getGroupedExpenses {
    NSError *error = nil;
    //Get expenses
    
    NSFetchRequest *requestExpense = [NSFetchRequest fetchRequestWithEntityName:@"Expenses"];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expenses" inManagedObjectContext:self.appDelegate.managedObjectContext];
    requestExpense.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    [requestExpense setReturnsObjectsAsFaults:NO];
    NSExpressionDescription* amountDesc = [[NSExpressionDescription alloc] init];
    [amountDesc setExpression:[NSExpression expressionWithFormat:@"@sum.amount"]];
    [amountDesc setExpressionResultType:NSDecimalAttributeType];
    [amountDesc setName:@"amount"];
    
    NSAttributeDescription* purposeDesc = [entity.attributesByName objectForKey:@"purpose"];
//    NSAttributeDescription* amountDesc = [entity.attributesByName objectForKey:@"amount"];
    [requestExpense setPropertiesToGroupBy:[NSArray arrayWithObjects:purposeDesc, nil]];
    [requestExpense setPropertiesToFetch:[NSArray arrayWithObjects:purposeDesc, amountDesc, nil]];
    [requestExpense setResultType:NSDictionaryResultType];
    NSArray *matchesExpense = [self.appDelegate.managedObjectContext executeFetchRequest:requestExpense error:&error];
    if (!matchesExpense || error ) {
        NSLog(@"Error while getting expenses");
    }else if ([matchesExpense count]){
        [self.groupedArray removeAllObjects];
        self.groupedArray = [matchesExpense mutableCopy];
        double sumAmount = 0.00;
        for (NSDictionary *amountDict in self.groupedArray) {
            sumAmount += ((NSString*)[amountDict valueForKey:@"amount"]).doubleValue;
        }
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setGroupingSize:3];
        [numberFormatter setCurrencySymbol:@""];
        [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"sr"]];
        [numberFormatter setMaximumFractionDigits:2];
        
       
        self.sumAmountLabel.text =  [numberFormatter stringFromNumber:[NSNumber numberWithDouble:sumAmount]];
        [self setupPieChart];
        [self setupBarChart];
        [self updateChartData];
        [self updateBarChartData];
        
        //        [self.tableView reloadData];
    }
    
    
}

-(void)setupPieChart{
    
    self.pieChartView.usePercentValuesEnabled = YES;
    self.pieChartView.drawSlicesUnderHoleEnabled = NO;
    self.pieChartView.holeRadiusPercent = 0.33;
    self.pieChartView.transparentCircleRadiusPercent = 0;
    self.pieChartView.chartDescription.enabled = NO;
    //        [self.pieChartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
    
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
    self.barChartView.rightAxis.enabled = NO;
    
    self.barChartView.delegate = self;
    
    self.barChartView.drawBarShadowEnabled = NO;
    self.barChartView.drawValueAboveBarEnabled = YES;
    
    ChartXAxis *xAxis = self.barChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.granularity = 1.0; // only intervals of 1 day
    xAxis.labelCount = 20;
    xAxis.wordWrapEnabled = YES;
    
    NSMutableArray *purposeArray = [[NSMutableArray alloc]init];
    for (int i=0; i<self.groupedArray.count; i++) {
        [purposeArray addObject:[((NSDictionary*)self.groupedArray[i]) valueForKey:@"purpose"]];
    }
    xAxis.valueFormatter = [[LabelChartValueFormatter alloc] initForChart:self.barChartView withArray:purposeArray];
    
    
    
    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
    leftAxisFormatter.minimumFractionDigits = 0;
    leftAxisFormatter.maximumFractionDigits = 1;
    leftAxisFormatter.negativeSuffix = @" RSD";
    leftAxisFormatter.positiveSuffix = @" RSD";
    
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
    
}

- (void)updateChartData
{
    
    [self setDataCount:(int)self.groupedArray.count range:(int)self.expensesArray.count];
}

-(void)updateBarChartData {
    [self setBarDataCount:(int)self.groupedArray.count range:(int)self.expensesArray.count];
}


- (void)setBarDataCount:(int)count range:(double)range{
    double start = 1.0;
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = start; i <  count + start ; i++)
    {
        //        double mult = (range + 1);
        //        double val = (double) (arc4random_uniform(mult));
        
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:((NSString*)[((NSDictionary*)self.groupedArray[i-1]) valueForKey:@"amount"]).doubleValue]];
        
    }
    
    BarChartDataSet *set1 = nil;
    if (self.barChartView.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)self.barChartView.data.dataSets[0];
        set1.values = yVals;
        [self.barChartView.data notifyDataChanged];
        [self.barChartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[BarChartDataSet alloc] initWithValues:yVals label:@""];
        [set1 setColors:ChartColorTemplates.material];
        set1.drawValuesEnabled = YES;
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
        
        data.barWidth = 0.9f;
        
        self.barChartView.data = data;
    }
    
}

- (void)setDataCount:(int)count range:(double)range
{
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++){
        
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


-(void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight{
    
    [((NSDictionary*)self.groupedArray[(int)entry.x-1]) valueForKey:@"purpose"];
    chartView.drawMarkers = YES;
    
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

#pragma mark - KVO
    
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
    {
        if (context == _KVOContext) {
            FSCalendarScope oldScope = [change[NSKeyValueChangeOldKey] unsignedIntegerValue];
            FSCalendarScope newScope = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
            NSLog(@"From %@ to %@",(oldScope==FSCalendarScopeWeek?@"week":@"month"),(newScope==FSCalendarScopeWeek?@"week":@"month"));
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    
#pragma mark - <UIGestureRecognizerDelegate>
    
    // Whether scope gesture should begin
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
    {
        BOOL shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top;
        if (shouldBegin) {
            CGPoint velocity = [self.scopeGesture velocityInView:self.view];
            switch (self.calendar.scope) {
                case FSCalendarScopeMonth:
                return velocity.y < 0;
                case FSCalendarScopeWeek:
                return velocity.y > 0;
            }
        }
        return shouldBegin;
    }
    
#pragma mark - <FSCalendarDelegate>
    
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
    {
        //    NSLog(@"%@",(calendar.scope==FSCalendarScopeWeek?@"week":@"month"));
        _calendarHeightConstraint.constant = CGRectGetHeight(bounds);
        [self.view layoutIfNeeded];
    }
    
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
        NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    
       [self getDataWithDate:date];
        NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
        [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [selectedDates addObject:[self.dateFormatter stringFromDate:obj]];
        }];
        NSLog(@"selected dates is %@",selectedDates);
        if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
            [calendar setCurrentPage:date animated:YES];
        }
}
    
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar{
        NSLog(@"%s %@", __FUNCTION__, [self.dateFormatter stringFromDate:calendar.currentPage]);
}
    


-(UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date{
     return [UIColor getGreenColor];
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
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setCurrencySymbol:@""];
    [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"sr"]];
    [numberFormatter setMaximumFractionDigits:2];
    cell.amountLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:expense.amount]];
    
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
         
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

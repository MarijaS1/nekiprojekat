//
//  AutoViewController.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 5/16/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "AutoViewController.h"
#import "AutoTableViewCell.h"

@interface AutoViewController ()

@property (strong, nonatomic) NSMutableArray *carArray;

@end

@implementation AutoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"AutoTableViewCell" bundle:nil] forCellReuseIdentifier:AUTO_TABLE_VIEW_CELL_IDENTIFIER];
    self.carArray = [[NSMutableArray alloc]init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
   
}

-(void)viewWillAppear:(BOOL)animated{
    User *user = [DataController sharedInstance].userInfo;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Car"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"brandName" ascending:NO]];
    [request setReturnsObjectsAsFaults:NO];
    request.predicate = [NSPredicate predicateWithFormat:@"hasOwnerRelationship = %@", user.objectID];
    NSError *error = nil;
    NSArray *matches = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (!matches || error ) {
        NSLog(@"Error while getting car");
    }else if ([matches count]){
        self.carArray = [matches mutableCopy];
    }
}


#pragma mark - UITableViewDelegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 91;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( self.carArray.count != 0) {
        return self.carArray.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        
        AutoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AUTO_TABLE_VIEW_CELL_IDENTIFIER forIndexPath:indexPath];
        Car *car = [self.carArray objectAtIndex:indexPath.row];
        
        cell.brandNameLabel.text = car.brandName;
        cell.typeOfCarLabel.text = car.type;
        cell.registrationPlateLabel.text = car.registration;
        
        return cell;
    }
    
    return [UITableViewCell new];
}




- (IBAction)addCarButtonPressed:(UIBarButtonItem *)sender {
}

@end

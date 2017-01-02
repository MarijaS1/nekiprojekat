//
//  SecondViewController.m
//  NoviProjekat
//
//  Created by Admin on 10/12/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ParkingViewController.h"
#import "ParkingTableViewCell.h"


@interface ParkingViewController ()
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSArray *thumbnails;
@end

@implementation ParkingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ParkingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:PARKING_TABLE_VIEW_CELL_IDENTIFIER];
    [self initGui];
}

-(void)initGui{
    self.tableData = [NSArray arrayWithObjects:@"String1",@"String2",@"String3",@"String4",@"String5", nil];
    self.thumbnails = [NSArray arrayWithObjects:@"car",@"car",@"car",@"car",@"car",nil];
}


#pragma mark - UITableViewControllerDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = PARKING_TABLE_VIEW_CELL_IDENTIFIER;
    
   
    ParkingTableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[ParkingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
//    cell.delegate = self;
    cell.descriptionLabel.text = [self.tableData objectAtIndex:indexPath.row];
    cell.thumbnailImage.image = [UIImage imageNamed:[self.thumbnails objectAtIndex:indexPath.row]];
    return cell;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}



@end

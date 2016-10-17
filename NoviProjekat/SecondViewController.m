//
//  SecondViewController.m
//  NoviProjekat
//
//  Created by Admin on 10/12/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "SecondViewController.h"
#import "ParkingTableViewCell.h"

@interface SecondViewController ()
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSArray *thumbnails;
@end

@implementation SecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initGui];
}

-(void)initGui{
    self.tableData = [NSArray arrayWithObjects:@"String1",@"String2",@"String3",@"String4",@"String5", nil];
    self.thumbnails = [NSArray arrayWithObjects:@"car",@"car",@"car",@"car",@"car",nil];
}


#pragma mark - UITableViewControllerDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"parkingTableViewCell";
    
    ParkingTableViewCell *cell = (ParkingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ParkingTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
     
    
    }
    
    cell.descriptionLabel.text = [self.tableData objectAtIndex:indexPath.row];
    cell.thumbnailImage.image = [UIImage imageNamed:[self.thumbnails objectAtIndex:indexPath.row]];
    return cell;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}



@end

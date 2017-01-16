//
//  SecondViewController.m
//  NoviProjekat
//
//  Created by Admin on 10/12/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ParkingViewController.h"
#import "ParkingTableViewCell.h"
#import "LocalizableStringService.h"


@interface ParkingViewController ()

@end

@implementation ParkingViewController

#pragma mark - Lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ParkingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:PARKING_TABLE_VIEW_CELL_IDENTIFIER];
    
    
    [self initGui];
    

}


-(void)initGui{
    
    
    UIView *tableViewBackground = [[UIView alloc] init];
    tableViewBackground.frame = self.view.frame;
    tableViewBackground.backgroundColor= [UIColor colorWithRed:124/255.0 green:128/255.0 blue:135/255.0 alpha:1.0];
    
    [self.view insertSubview:tableViewBackground belowSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
//
//    UILabel *registrationPlatesLabel = [[UILabel alloc]initWithFrame:self.registrationPlatesLabel.frame];
//     registrationPlatesLabel.text = @"Registration Plates";
//    registrationPlatesLabel.textAlignment = NSTextAlignmentCenter;
//       registrationPlatesLabel.textColor = [UIColor whiteColor];
//    [self.view insertSubview:registrationPlatesLabel aboveSubview:self.tableView];
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
    
    [cell adjustCellForIndexPath:indexPath];
//    cell.delegate = self;
    return cell;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *smsNumber = @"";
    
    switch (indexPath.row) {
        case 0:
            smsNumber = @"9111";
            break;
            
        case 1:
            smsNumber = @"9112";
            break;
        case 2:
            smsNumber = @"9113";
            break;
        case 3:
            smsNumber = @"9119";
            break;
        case 4:
            smsNumber = @"9118";
            break;
        default:
            break;
    }
   
      UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Pošsalji SMS" message:[NSString stringWithFormat:@"Na broj: %@ Sadržaj: Broj tablice", smsNumber ] preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_ALERT andSybtype:SUBTYPE_TEXT andSuffix:@"cancel"]  style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        

        [alertView dismissViewControllerAnimated:YES completion:nil];

    }];
    [alertView addAction:cancelAction];
    
    UIAlertAction *sendAction = [UIAlertAction actionWithTitle:[[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_ALERT andSybtype:SUBTYPE_TEXT andSuffix:@"send"]  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        
        [alertView dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [alertView addAction:sendAction];
    
    [self presentViewController:alertView animated:YES completion:nil];

}




@end

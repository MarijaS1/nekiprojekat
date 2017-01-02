//
//  ParkingTableViewCell.h
//  NoviProjekat
//
//  Created by Admin on 10/17/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PARKING_TABLE_VIEW_CELL_IDENTIFIER  @"parkingTableViewCell"

@interface ParkingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) NSArray *titleData;
@property (nonatomic, strong) NSArray *descriptionData;
@property (nonatomic, strong) NSArray *thumbnails;

-(void)adjustCellForIndexPath: (NSIndexPath*)indexPath;

@end

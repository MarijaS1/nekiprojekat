//
//  ParkingTableViewCell.m
//  NoviProjekat
//
//  Created by Admin on 10/17/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ParkingTableViewCell.h"
#import "LocalizableStringService.h"



@implementation ParkingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)adjustCellForIndexPath: (NSIndexPath*)indexPath{
    self.titleData = [NSArray arrayWithObjects:[[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_LABEL andSybtype:SUBTYPE_TITLE andSuffix:@"zona1"], [[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_LABEL andSybtype:SUBTYPE_TITLE andSuffix:@"zona2"], [[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_LABEL andSybtype:SUBTYPE_TITLE andSuffix:@"zona3"], [[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_LABEL andSybtype:SUBTYPE_TITLE andSuffix:@"nolimit"], [[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_LABEL andSybtype:SUBTYPE_TITLE andSuffix:@"dailyticket"], nil ];
    self.descriptionData = [NSArray arrayWithObjects:[[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_LABEL andSybtype:SUBTYPE_TITLE andSuffix:@"zona1text"], [[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_LABEL andSybtype:SUBTYPE_TITLE andSuffix:@"zona2text"], [[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_LABEL andSybtype:SUBTYPE_TITLE andSuffix:@"zona3text"], [[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_LABEL andSybtype:SUBTYPE_TITLE andSuffix:@"nolimittext"], [[LocalizableStringService sharedInstance] getLocalizableStringForType:TYPE_LABEL andSybtype:SUBTYPE_TITLE andSuffix:@"dailytickettext"], nil ];
    self.thumbnails = [NSArray arrayWithObjects:@"car",@"car",@"car",@"car",@"car",nil];
    
    
    self.titleLabel.text = [self.titleData objectAtIndex:indexPath.row];
    self.descriptionLabel.text = [self.descriptionData objectAtIndex:indexPath.row];
    self.thumbnailImage.image = [UIImage imageNamed:[self.thumbnails objectAtIndex:indexPath.row]];
    

    
}

@end

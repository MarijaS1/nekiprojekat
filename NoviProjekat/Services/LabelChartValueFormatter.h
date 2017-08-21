//
//  LabelChartValueFormatter.h
//  NoviProjekat
//
//  Created by Marija Sumakovic on 8/21/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LabelChartValueFormatter : NSObject <IChartAxisValueFormatter>

- (id)initForChart:(BarLineChartViewBase *)chart withArray:(NSArray*)purpose;


@end

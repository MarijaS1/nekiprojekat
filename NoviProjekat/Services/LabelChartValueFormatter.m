//
//  LabelChartValueFormatter.m
//  NoviProjekat
//
//  Created by Marija Sumakovic on 8/21/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "LabelChartValueFormatter.h"

@implementation LabelChartValueFormatter


{
    NSArray *_purpose;
    __weak BarLineChartViewBase *_chart;
    
}
- (id)initForChart:(BarLineChartViewBase *)chart withArray:(NSArray *)purpose
{
    self = [super init];
    if (self)
    {
        self->_chart = chart;
        
       self->_purpose = purpose;
    }
    return self;
}

-(NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis{
    int index = (int)value;
    
    
    NSString *purposeName = _purpose[index-1];
        return purposeName;
}

@end



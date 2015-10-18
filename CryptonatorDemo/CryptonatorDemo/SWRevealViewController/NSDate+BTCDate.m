//
//  NSDate+BTCDate.m
//  CryptonatorDemo
//
//  Created by Z on 10/18/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "NSDate+BTCDate.h"

@implementation NSDate (BTCDate)

-(NSString *)stringFromDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss MM/dd/YYYY"];
    NSString *dateString = [dateFormatter stringFromDate:self];
    return dateString;
}

-(NSTimeInterval)timeToTargetDate{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeToTargetDate = [currentDate timeIntervalSinceDate:self];
    return timeToTargetDate;
}

typedef NS_ENUM(NSInteger, PredictionType) {
    Year,
    Month,
    Day,
    Hour,
    Minute,
    Second,
    Millisecond,
    Poop
};



@end

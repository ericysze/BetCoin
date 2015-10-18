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
    [dateFormatter setDateFormat:@"MM-dd-YYYY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:self];
    return dateString;
}

@end

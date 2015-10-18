//
//  PlayerDataModel.h
//  CryptonatorDemo
//
//  Created by Z on 10/12/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BitcoinPrediction.h"
#import <Parse/Parse.h>

@interface PlayerDataModel : PFObject <PFSubclassing>

@property (nonatomic) NSNumber *wins;
@property (nonatomic) NSNumber *losses;
@property (nonatomic) NSMutableArray *predictions;

+ (NSString *)parseClassName;

@end

//
//  BitcoinPrediction.h
//  CryptonatorDemo
//
//  Created by Z on 10/12/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface BitcoinPrediction : PFObject <PFSubclassing>

typedef NS_ENUM(NSInteger, PredictionType) {
    BTCHighPrediction,
    BTCLowPrediction,
};

typedef NS_ENUM(NSInteger, PredictionOutcome) {
    BTCCorrect,
    BTCIncorrect,
    BTCUndecided
};

@property (nonatomic) NSNumber *priceAtInstantOfPrediction;
@property (nonatomic) PredictionType type;
@property (nonatomic) NSDate *targetDate;
@property (nonatomic) NSString *journalEntry;
@property (nonatomic) PredictionOutcome outcome;

@end



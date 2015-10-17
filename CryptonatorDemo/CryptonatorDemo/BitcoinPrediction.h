//
//  BitcoinPrediction.h
//  CryptonatorDemo
//
//  Created by Z on 10/12/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BitcoinPrediction : NSObject

typedef NS_ENUM(NSInteger, PredictionType) {
    BTCHighPrediction,
    BTCLowPrediction,
};

typedef NS_ENUM(NSInteger, PredictionOutcome) {
    BTCCorrect,
    BTCIncorrect,
    BTCUndecided
};

@property (nonatomic) double priceAtInstantOfPrediction;
@property (nonatomic) PredictionType type;
@property (nonatomic) NSDate *targetDate;
@property (nonatomic) NSString *journalEntry;

-(PredictionOutcome)outcome:(double)targetPrice;

@end



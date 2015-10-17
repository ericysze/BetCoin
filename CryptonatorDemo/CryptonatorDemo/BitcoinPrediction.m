//
//  BitcoinPrediction.m
//  CryptonatorDemo
//
//  Created by Z on 10/12/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "BitcoinPrediction.h"
#import <Parse/Parse.h>

@implementation BitcoinPrediction

-(PredictionOutcome)outcome:(double)priceAtTargetDate{
    NSDate *currentDate = [NSDate date];
    
    //target date has yet to occur
    if ([currentDate timeIntervalSince1970] < [self.targetDate timeIntervalSince1970]) {
        return BTCUndecided;
    }
    
    //low prediction check
    if (self.type == BTCLowPrediction) {
        if (self.priceAtInstantOfPrediction > priceAtTargetDate) {
            return BTCCorrect;
        }
        else{
            return BTCIncorrect;
        }
    }
    
    //high prediction check
    else if (self.type == BTCHighPrediction){
        if (self.priceAtInstantOfPrediction < priceAtTargetDate) {
            return BTCCorrect;
        }
        else{
            return BTCIncorrect;
        }
    }
    
    return BTCUndecided;
}

@end

//
//  BitcoinPrediction.h
//  CryptonatorDemo
//
//  Created by Z on 10/12/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BitcoinPrediction : NSObject

typedef NS_ENUM(NSInteger, Prediction) {
    HighPrediction,
    LowPrediction,
};

@property (nonatomic) double priceAtInstantOfPrediction;
@property (nonatomic) Prediction PredictionType;

@property (nonatomic) NSDate *dateAtInstantOfPrediction;
@property (nonatomic) NSDate *targetDate;

@end



//
//  PlayerDataModel.h
//  CryptonatorDemo
//
//  Created by Z on 10/12/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BitcoinPrediction.h"

@interface PlayerDataModel : NSObject

@property (nonatomic) NSInteger *wins;
@property (nonatomic) NSInteger *losses;
@property (nonatomic) NSArray *predictions;

@end

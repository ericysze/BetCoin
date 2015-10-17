//
//  PlayerDataModel.m
//  CryptonatorDemo
//
//  Created by Z on 10/12/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "PlayerDataModel.h"

@implementation PlayerDataModel: PFObject

@dynamic wins;
@dynamic losses;
@dynamic predictions;

//-(PFObject*)PFObject{
//    PFObject *playerData = [PFObject objectWithClassName:@"PlayerData"];
//    playerData[@"wins"] = [NSNumber numberWithInteger:self.wins];
//    playerData[@"losses"] = [NSNumber numberWithInteger:self.losses];
//    playerData[@"predictions"] = self.predictions;
//    return playerData;
//}

- (NSInteger)wins:(double)priceAtTargetDate {
    NSInteger count = 0;
    for (BitcoinPrediction *prediction in self.predictions) {
        if ([prediction outcome:priceAtTargetDate] == BTCCorrect) {
            count += 1;
        }
    }
    return count;
}

- (NSInteger)losses:(double)priceAtTargetDate {
    NSInteger count = 0;
    for (BitcoinPrediction *prediction in self.predictions) {
        if ([prediction outcome:priceAtTargetDate] == BTCIncorrect) {
            count += 1;
        }
    }
    return count;
}


@end

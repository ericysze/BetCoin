//
//  CryptonatorTickerManager.h
//  CryptonatorDemo
//
//  Created by Z on 10/10/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BitcoinTicker.h"

@interface CryptonatorTickerManager : NSObject

@property (nonatomic) BitcoinTicker *bitcoinTicker;

+ (id)sharedManager;
-(void)getBitcoinTickerUpdateWithCallbackBlock:(void(^)())block;
-(double)getCurrentBitcoinPrice;

@end

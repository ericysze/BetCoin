//
//  BitcoinTicker.m
//  CryptonatorDemo
//
//  Created by Z on 10/10/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "BitcoinTicker.h"

@implementation BitcoinTicker

-(instancetype)initWithBitcoinJSON:(NSDictionary *)bitcoinJSON{
    self = [super init];
    if ([[bitcoinJSON objectForKey:@"success"] intValue] == 1) {
        self.change = [[[bitcoinJSON objectForKey:@"ticker"] objectForKey:@"change"] doubleValue];
        self.price = [[[bitcoinJSON objectForKey:@"ticker"] objectForKey:@"price"] doubleValue];
        self.volume = [[[bitcoinJSON objectForKey:@"ticker"] objectForKey:@"volume"] doubleValue];
        self.timestamp = [NSDate dateWithTimeIntervalSince1970:[[bitcoinJSON objectForKey:@"timestamp"] doubleValue]];
    }
    return self;
}

@end

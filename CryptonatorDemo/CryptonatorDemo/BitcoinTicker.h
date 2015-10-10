//
//  BitcoinTicker.h
//  CryptonatorDemo
//
//  Created by Z on 10/10/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BitcoinTicker : NSObject

@property (nonatomic) double change;
@property (nonatomic) double price;
@property (nonatomic) double volume;
@property (nonatomic) NSDate *timestamp;

-(instancetype)initWithBitcoinJSON:(NSDictionary *)bitcoinJSON;

@end

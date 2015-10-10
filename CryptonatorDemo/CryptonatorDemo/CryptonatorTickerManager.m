//
//  CryptonatorTickerManager.m
//  CryptonatorDemo
//
//  Created by Z on 10/10/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "CryptonatorTickerManager.h"
#import <AFNetworking/AFNetworking.h>
#import "BitcoinTicker.h"

@implementation CryptonatorTickerManager

+ (id)sharedManager {
    static CryptonatorTickerManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)getBitcoinTickerUpdateWithCallbackBlock:(void(^)())block{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://www.cryptonator.com/api/ticker/btc-usd" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *bitcoinJSON = [NSDictionary dictionaryWithDictionary:responseObject];
        
        self.bitcoinTicker = [[BitcoinTicker alloc] initWithBitcoinJSON:bitcoinJSON];
        
        //call block
        block();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(double)getCurrentBitcoinPrice{ //will return the price of last update
    [self getBitcoinTickerUpdateWithCallbackBlock:^{}];
    return self.bitcoinTicker.price;
}

@end

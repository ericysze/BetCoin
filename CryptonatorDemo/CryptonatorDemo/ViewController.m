//
//  ViewController.m
//  CryptonatorDemo
//
//  Created by Z on 10/10/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "CryptonatorTickerManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CryptonatorTickerManager *manager = [CryptonatorTickerManager sharedManager];
    [manager getBitcoinTickerUpdateWithCallbackBlock:^{
        NSLog(@"%f",manager.bitcoinTicker.price);
    }];
}

@end

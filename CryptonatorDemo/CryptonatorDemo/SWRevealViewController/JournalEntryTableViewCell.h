//
//  JournalEntryTableViewCell.h
//  CryptonatorDemo
//
//  Created by Eric Sze on 10/19/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BitcoinPrediction.h"

@interface JournalEntryTableViewCell : UITableViewCell

@property (nonatomic) BitcoinPrediction *prediction;

@property (weak, nonatomic) IBOutlet UILabel *journalEntryLabel;

+ (NSString *)reuseIdentifier;

@end

//
//  PredictionTableViewCell.m
//  CryptonatorDemo
//
//  Created by Z on 10/11/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "PredictionTableViewCell.h"
#import "NSDate+BTCDate.h"

@implementation PredictionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //update user date input
    
    self.priceAtInstantOfPredictionLabel.text = [NSString stringWithFormat:@"%@",self.prediction.priceAtInstantOfPrediction];
    self.userDateInput.text = [self.prediction.targetDate stringFromDate];
    self.timeToTargetDateLabel.text =[NSString stringWithFormat:@"%f", [self timeToTargetDate:self.prediction.targetDate]];
    
    if (self.prediction.type == BTCHighPrediction) {
        self.imageView.image = [UIImage imageNamed:@"uparrow"];
    }
    else if (self.prediction.type == BTCLowPrediction){
        self.imageView.image = [UIImage imageNamed:@"downarrow"];
    }
}

-(NSTimeInterval)timeToTargetDate:(NSDate*)targetDate{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeToTargetDate = [targetDate timeIntervalSinceDate:currentDate];
    return timeToTargetDate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier {
    return @"PredictionIdentifier";
}

@end

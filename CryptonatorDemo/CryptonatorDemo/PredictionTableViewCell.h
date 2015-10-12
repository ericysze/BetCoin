//
//  PredictionTableViewCell.h
//  CryptonatorDemo
//
//  Created by Z on 10/11/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PredictionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

+ (NSString *)reuseIdentifier;

@end

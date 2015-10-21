//
//  JournalEntryTableViewCell.m
//  CryptonatorDemo
//
//  Created by Eric Sze on 10/19/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "JournalEntryTableViewCell.h"

@implementation JournalEntryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier {
    return @"JournalCellIdentifier";
}


@end

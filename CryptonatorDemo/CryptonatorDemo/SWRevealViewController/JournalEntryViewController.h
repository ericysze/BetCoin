//
//  JournalEntryViewController.h
//  CryptonatorDemo
//
//  Created by Z on 10/13/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JournalEntryViewControllerDelegate <NSObject>

- (void)updateTableViewDataSourceWithString:(NSString *)string;
- (void)updateTableViewDataSourceWithDate:(NSString *)logDate;

@end

@interface JournalEntryViewController : UIViewController

@property (nonatomic) NSString *upOrDown;
@property (nonatomic, weak) id <JournalEntryViewControllerDelegate> delegate;

@end

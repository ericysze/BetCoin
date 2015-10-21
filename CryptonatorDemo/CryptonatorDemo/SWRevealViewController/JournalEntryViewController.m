//
//  JournalEntryViewController.m
//  CryptonatorDemo
//
//  Created by Z on 10/13/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "JournalEntryViewController.h"
#import <Social/Social.h>
#import "Reachability.h"
#import "BitcoinPrediction.h"
#import "CryptonatorTickerManager.h"

@interface JournalEntryViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tickerPriceLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *predictionButton;

@property (nonatomic) NSString *dateString;
@property (nonatomic) Reachability *internetReachableFoo;

@end

@implementation JournalEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateBTCTickerLabel];
    
    [self.predictionButton setBackgroundImage:[UIImage imageNamed:([self.upOrDown isEqualToString:@"up"] ? @"orangeuparrow" : @"orangedownarrow")] forState:UIControlStateNormal];
    [self textViewAdjustments];
    self.internetReachableFoo = [Reachability reachabilityForInternetConnection];
    [self datePickerSettings];
    
//    self.datePicker.backgroundColor = [UIColor colorWithRed:100.0 green:153.0 blue:0.0 alpha:1];
    
    [self.datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
}

-(void)updateBTCTickerLabel{
    CryptonatorTickerManager *manager = [CryptonatorTickerManager sharedManager];
    [manager getBitcoinTickerUpdateWithCallbackBlock:^{
        self.tickerPriceLabel.text = [@"BTC: $" stringByAppendingString:[NSString stringWithFormat:@"%.2f",manager.bitcoinTicker.price]];
    }];
}

#pragma mark - IBActions

- (IBAction)tweetButtonTapped:(id)sender
{
    NSLog(@"%d", [self.internetReachableFoo isReachable] ? 1 : 0);
    
    BOOL hasTwitterAccount = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
    BOOL hasInternet = [self.internetReachableFoo isReachable];
    
    if (!hasInternet) {
        [self alertHasNoInternet];
    } else {
        if (hasTwitterAccount) {
            [self showTwitterShareSheet];
        } else {
            [self alertHasNoTwitterAccount];
        }
    }
}

- (IBAction)postButtonTapped:(id)sender
{
    if ([self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        //Do something
    }
    else{
        
        [self makePrediction];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

-(void)makePrediction{
    BitcoinPrediction *prediction = [[BitcoinPrediction alloc] init];
    
    //set price at instant of prediction
    CryptonatorTickerManager *manager = [CryptonatorTickerManager sharedManager];
    prediction.priceAtInstantOfPrediction = [NSNumber numberWithDouble:manager.bitcoinTicker.price];
    
    //set prediction type
    if ([self.upOrDown isEqualToString: @"up"]) {
        prediction.type = BTCHighPrediction;
    }
    else if ([self.upOrDown isEqualToString:@"down"]){
        prediction.type = BTCLowPrediction;
    }
    
    //set target date
    prediction.targetDate = self.datePicker.date;
    
    //set joural entry
    prediction.journalEntry = self.textView.text;
    
    //save prediction to parse
    [prediction saveInBackground];
}

#pragma mark - Functions

- (void)datePickerSettings {
    [self.datePicker setMinimumDate:self.datePicker.date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MM-dd-YYYY HH:mm:ss"];
    [dateFormatter setDateFormat:@"MM-dd-YYY hh:mm a"];
//    NSString* dateString = [dateFormatter stringFromDate:date];
    self.dateString = [dateFormatter stringFromDate:self.datePicker.date];
    
    
    NSLog(@"The Date: %@", self.dateString);
}

- (void)alertHasNoInternet
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cellular Data is Turned Off"
                                                                   message:@"Turn on cellular data or use Wi-Fi to access data." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Settings"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action)
                                     {
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                     }];
    
    [alert addAction:settingsAction];
    [alert addAction:dismissAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)showTwitterShareSheet
{
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:self.textView.text];
    [self presentViewController:tweetSheet animated:YES completion:nil];
}


- (void)alertHasNoTwitterAccount
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry"
                                                                   message:@"You need at least one Twitter account in Settings->Twitter"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Settings"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action)
                                     
                                     {
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                     }];
    
    [alert addAction:settingsAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - View Layout

- (void)textViewAdjustments {
    UIColor *borderColor = [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:0.0/255.0 alpha:1.0];
    
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.layer.borderColor = borderColor.CGColor;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.cornerRadius = 5.0;
}


@end


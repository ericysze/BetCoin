//
//  JournalViewController.m
//  CryptonatorDemo
//
//  Created by Z on 10/13/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "JournalViewController.h"
#import "SWRevealViewController.h"
#import "JournalEntryTableViewCell.h"
#import "BitcoinPrediction.h"
#import <Parse/Parse.h>

@interface JournalViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *predictions;

@end

@implementation JournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //setup RevealViewController functionality
    if (self.revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JournalEntryTableViewCell" bundle:nil] forCellReuseIdentifier:[JournalEntryTableViewCell reuseIdentifier]];
    
    [self.tableView reloadData];
    
    [self getBitcoinPredicitonsFromParse];
    
}



-(void)getBitcoinPredicitonsFromParse{
    PFQuery *query = [PFQuery queryWithClassName:@"BitcoinPrediction"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        NSArray *parseObjects = [NSArray arrayWithArray:objects];
        
        self.predictions = [[NSMutableArray alloc] init];
        
        for (PFObject *parseObject in parseObjects) {
            BitcoinPrediction *prediction= [[BitcoinPrediction alloc] init];
//            prediction.targetDate = [parseObject objectForKey:@"targetDate"];
//            prediction.type = [[parseObject objectForKey:@"type"] integerValue];
//            prediction.priceAtInstantOfPrediction = [parseObject objectForKey:@"priceAtInstantOfPrediction"];
            prediction.journalEntry = [parseObject objectForKey:@"journalEntry"];
            [self.predictions addObject:prediction];
            NSLog(@"%@", self.predictions);
        }
        
        [self.tableView reloadData];
    }];
}







#pragma mark - TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.predictions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JournalEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[JournalEntryTableViewCell reuseIdentifier]forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[JournalEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[JournalEntryTableViewCell reuseIdentifier]];
    }
    
    cell.journalEntryLabel.text = cell.prediction.journalEntry;


    return cell;
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    PredictionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PredictionTableViewCell reuseIdentifier]forIndexPath:indexPath];
//    
//    if (cell == nil) {
//        cell = [[PredictionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PredictionTableViewCell reuseIdentifier]];
//    }
//    //    cell.userLogInput.text = self.userPrediction[[self.userPrediction count] -1 - indexPath.row];
//    //    cell.userDateInput.text = self.targetPredicationDate[[self.targetPredicationDate count] -1 - indexPath.row];
//    
//    //give the cell a prediction
//    cell.prediction = [self.predictions objectAtIndex:indexPath.row];
//    
//    //set price at instant of prediction
//    cell.priceAtInstantOfPredictionLabel.text = [NSString stringWithFormat:@"$%.2f",[cell.prediction.priceAtInstantOfPrediction doubleValue]];
//    //cell.userDateInput.text = [cell.prediction.targetDate stringFromDate];
//    
//    //set time to target date
//    //TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
//    //cell.timeToTargetDateLabel.text =  [timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:cell.prediction.targetDate];
//    
//    cell.timeToTargetDateLabel.text = cell.prediction.journalEntry;
//    
//    
//    //set image
//    if (cell.prediction.type == BTCHighPrediction) {
//        cell.predictionArrowImage.image = [UIImage imageNamed:@"uparrow"];
//    }
//    else if (cell.prediction.type == BTCLowPrediction){
//        cell.predictionArrowImage.image = [UIImage imageNamed:@"downarrow"];
//    }
//    return cell;
//}

@end

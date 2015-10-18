//
//  TickerViewController.m
//  CryptonatorDemo
//
//  Created by Z on 10/11/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "TickerViewController.h"
#import "SWRevealViewController.h"
#import "CryptonatorTickerManager.h"
#import "PredictionTableViewCell.h"
#import "JournalEntryViewController.h"
#import "PlayerDataModel.h"

#import <ABPadLockScreen/ABPadLockScreenSetupViewController.h>
#import <ABPadLockScreen/ABPadLockScreenViewController.h>

#import <POP/POP.h>
#import <Parse/Parse.h>

#import "NSDate+BTCDate.h"

#import "TTTTimeIntervalFormatter.h"

@interface TickerViewController ()
<UITableViewDataSource,
UITableViewDelegate,
ABPadLockScreenSetupViewControllerDelegate,
ABPadLockScreenViewControllerDelegate,
JournalEntryViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *tickerPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;

@property (nonatomic) NSMutableArray <NSString *> *userPrediction;
@property (nonatomic) NSMutableArray <NSString *> *targetPredicationDate;

@property (nonatomic) NSMutableArray *predictions;

@end

//static variable persists on class
static BOOL BTCpasscodeViewControllerHasBeenShown = NO;

@implementation TickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    CryptonatorTickerManager *manager = [CryptonatorTickerManager sharedManager];
    
    //get latest BTC price from Cryptonator API every 30 seconds
    [manager getBitcoinTickerUpdateWithCallbackBlock:^{
        self.tickerPriceLabel.text = [@"BTC: $" stringByAppendingString:[NSString stringWithFormat:@"%.2f",manager.bitcoinTicker.price]];
    }];
    
    //setup RevealViewController functionality
    if (self.revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    //UITableView Protocol
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.userPrediction = [NSMutableArray new];
    self.targetPredicationDate = [NSMutableArray new];
    
    //Register Nib for Cell Reuse Identifier
    [self.tableView registerNib:[UINib nibWithNibName:@"PredictionTableViewCell" bundle:nil] forCellReuseIdentifier:[PredictionTableViewCell reuseIdentifier]];
    
//    BitcoinPrediction *prediction = [[BitcoinPrediction alloc] init];
//    prediction.priceAtInstantOfPrediction = @4121.12;
//    prediction.type = BTCLowPrediction;
//    prediction.targetDate = [NSDate date];
//    prediction.journalEntry = @"tHOLE";
//    prediction.outcome = BTCIncorrect;
//    //[prediction saveInBackground];
//    
//    PlayerDataModel *playerDataModel = [[PlayerDataModel alloc] init];
//    playerDataModel.wins = @9991;
//    playerDataModel.losses = @13;
//    playerDataModel.predictions = [[NSMutableArray alloc] initWithObjects:prediction, nil];
//    [playerDataModel saveInBackground];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    if (BTCpasscodeViewControllerHasBeenShown == NO) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pin"] == nil){
            [self presentABPadLockScreenSetupViewController];
        }
        else{
            [self presentABPadLockScreenViewController];
        }
    }
    BTCpasscodeViewControllerHasBeenShown = YES;
    
    [self getBitcoinPredicitonsFromParse];
}

#pragma mark - Parse

-(void)getBitcoinPredicitonsFromParse{
    PFQuery *query = [PFQuery queryWithClassName:@"BitcoinPrediction"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        NSArray *parseObjects = [NSArray arrayWithArray:objects];
        
        self.predictions = [[NSMutableArray alloc] init];
        
        for (PFObject *parseObject in parseObjects) {
            BitcoinPrediction *prediction= [[BitcoinPrediction alloc] init];
            prediction.targetDate = [parseObject objectForKey:@"targetDate"];
            prediction.type = [[parseObject objectForKey:@"type"] integerValue];
            prediction.priceAtInstantOfPrediction = [parseObject objectForKey:@"priceAtInstantOfPrediction"];
            prediction.journalEntry = [parseObject objectForKey:@"journalEntry"];
            [self.predictions addObject:prediction];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PredictionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PredictionTableViewCell reuseIdentifier]forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[PredictionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PredictionTableViewCell reuseIdentifier]];
    }
//    cell.userLogInput.text = self.userPrediction[[self.userPrediction count] -1 - indexPath.row];
//    cell.userDateInput.text = self.targetPredicationDate[[self.targetPredicationDate count] -1 - indexPath.row];
    
    //give the cell a prediction
    cell.prediction = [self.predictions objectAtIndex:indexPath.row];
    
    //set price at instant of prediction
    cell.priceAtInstantOfPredictionLabel.text = [NSString stringWithFormat:@"$%.2f",[cell.prediction.priceAtInstantOfPrediction doubleValue]];
    cell.userDateInput.text = [cell.prediction.targetDate stringFromDate];
    
    //set time to target date
    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    cell.timeToTargetDateLabel.text =  [timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:cell.prediction.targetDate];
    
    //set image
    if (cell.prediction.type == BTCHighPrediction) {
        cell.predictionArrowImage.image = [UIImage imageNamed:@"uparrow"];
    }
    else if (cell.prediction.type == BTCLowPrediction){
        cell.predictionArrowImage.image = [UIImage imageNamed:@"downarrow"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(PredictionTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark - pop button methods
- (IBAction)upArrowButtonTouched:(UIButton *)sender {
    [sender setImage:[UIImage imageNamed:@"orangeuparrow"] forState:UIControlStateNormal];
    [self addPopAnimationToButton:sender];
    
    JournalEntryViewController *journalEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PredictionViewController"];
    journalEntryVC.upOrDown = @"up";
    
    journalEntryVC.delegate = self;
    [self presentViewController:journalEntryVC animated:YES completion:nil];
}

- (IBAction)downArrowButtonTouched:(UIButton *)sender {
    [sender setImage:[UIImage imageNamed:@"orangedownarrow"] forState:UIControlStateNormal];
    [self addPopAnimationToButton:sender];
    
    JournalEntryViewController *journalEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PredictionViewController"];
    journalEntryVC.upOrDown = @"down";
    
    journalEntryVC.delegate = self;
    [self presentViewController:journalEntryVC animated:YES completion:nil];
}


-(void)addPopAnimationToButton:(UIButton*)button{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.5, 1.5)];
    scaleAnimation.springBounciness = 25.f;
    scaleAnimation.springSpeed = 80;
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
    };
    scaleAnimation.removedOnCompletion = YES;
    [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
}

#pragma mark - present methods
-(void)presentABPadLockScreenSetupViewController{
    ABPadLockScreenSetupViewController *lockScreen = [[ABPadLockScreenSetupViewController alloc] initWithDelegate:self complexPin:NO subtitleLabelText:@"Please set your pin"];
    
    lockScreen.modalPresentationStyle = UIModalPresentationFullScreen;
    lockScreen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:lockScreen animated:YES completion:nil];
}

-(void)presentABPadLockScreenViewController{
    ABPadLockScreenViewController *lockScreen = [[ABPadLockScreenViewController alloc] initWithDelegate:self complexPin:NO];
    [lockScreen setAllowedAttempts:5];
    
    lockScreen.modalPresentationStyle = UIModalPresentationFullScreen;
    lockScreen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:lockScreen animated:YES completion:nil];
}

//-(void)presentJournalEntryViewController{
//    [self performSegueWithIdentifier:@"PredictionViewController" sender:self];
//}

#pragma mark - push view controller methods

-(void)pushRevealViewController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWRevealViewController *revealViewController = [storyboard instantiateViewControllerWithIdentifier:@"RevealViewControllerIdentifier"];
    [self.navigationController pushViewController:revealViewController animated:YES];
}

-(void)pushTickerViewController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TickerViewController *tickerViewController = [storyboard instantiateViewControllerWithIdentifier:@"TickerViewControllerIdentifier"];
    [self.navigationController pushViewController:tickerViewController animated:YES];
}

#pragma mark - ABPadLockScreenSetupViewControllerDelegate methods
- (void)pinSet:(NSString *)pin padLockScreenSetupViewController:(ABPadLockScreenSetupViewController *)padLockScreenViewController{
    [[NSUserDefaults standardUserDefaults] setObject:pin forKey:@"pin"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ABPadLockScreenViewControllerDelegate methods

- (BOOL)padLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController validatePin:(NSString*)pin{
    if (pin == [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"]) {
        return YES;
    }
    return NO;
}

- (void)unlockWasSuccessfulForPadLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)unlockWasUnsuccessful:(NSString *)falsePin afterAttemptNumber:(NSInteger)attemptNumber padLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController{
}

- (void)unlockWasCancelledForPadLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController{
}

#pragma storyboard
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"prepare for seguee");
}

#pragma mark - ViewControllerDelegate Methods

- (void)updateTableViewDataSourceWithString:(NSString *)string
{
    [self.userPrediction addObject:string];
    [self.tableView reloadData];
}

- (void)updateTableViewDataSourceWithDate:(NSString *)logDate
{
    [self.targetPredicationDate addObject:logDate];
    [self.tableView reloadData];
    
}

#pragma mark - helper methods

-(NSTimeInterval)timeToTargetDate:(NSDate*)targetDate{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeToTargetDate = [targetDate timeIntervalSinceDate:currentDate];

    
    return timeToTargetDate;
}

@end

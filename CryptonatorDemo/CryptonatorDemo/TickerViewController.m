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
#import <POP/POP.h>

#import <ABPadLockScreen/ABPadLockScreenSetupViewController.h>
#import <ABPadLockScreen/ABPadLockScreenViewController.h>

@interface TickerViewController ()
<UITableViewDataSource,
UITableViewDelegate,
ABPadLockScreenSetupViewControllerDelegate,
ABPadLockScreenViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *tickerPriceLabel;
@end

//static variable persists through app
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
    
    //Register Nib for Cell Reuse Identifier
    [self.tableView registerNib:[UINib nibWithNibName:@"PredictionTableViewCell" bundle:nil] forCellReuseIdentifier:[PredictionTableViewCell reuseIdentifier]];
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
}


#pragma mark - TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PredictionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PredictionTableViewCell reuseIdentifier]forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[PredictionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PredictionTableViewCell reuseIdentifier]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(PredictionTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark - button methods

- (IBAction)arrowButtonTouched:(UIButton *)sender {
    [self addPopAnimationToButton:sender];
}

-(void)addPopAnimationToButton:(UIButton*)button{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.5, 1.5)];
    scaleAnimation.springBounciness = 20.f;
    [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
}
-(void)removePopAnimationToButton:(UIButton*)button{
    [button.layer pop_removeAnimationForKey:@"scaleAnim"];
}

#pragma mark - ABPadLockScreen present methods
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
//    [self pushTickerViewController];
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
//    [self pushRevealViewController];
}

- (void)unlockWasUnsuccessful:(NSString *)falsePin afterAttemptNumber:(NSInteger)attemptNumber padLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController{
    
}

- (void)unlockWasCancelledForPadLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController{
    
}


@end

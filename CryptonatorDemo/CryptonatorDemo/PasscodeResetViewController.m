//
//  PasscodeResetViewController.m
//  CryptonatorDemo
//
//  Created by Z on 10/13/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "PasscodeResetViewController.h"
#import <ABPadLockScreen/ABPadLockScreenSetupViewController.h>
#import <ABPadLockScreen/ABPadLockScreenViewController.h>
#import "SWRevealViewController.h"

@interface PasscodeResetViewController ()
<ABPadLockScreenSetupViewControllerDelegate,
ABPadLockScreenViewControllerDelegate>

@property (nonatomic) BOOL passcodeViewControllerHasBeenShown;

@end

@implementation PasscodeResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setup RevealViewController functionality
    if (self.revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (IBAction)resetPasscodeButtonTouched:(UIButton *)sender {
    [self presentABPadLockScreenViewController];
}

-(void)showPasscodeWasSuccessfullyResetAlertView{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                   message:@"Passcode was reset."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
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

#pragma mark - ABPadLockScreenSetupViewControllerDelegate methods
- (void)pinSet:(NSString *)pin padLockScreenSetupViewController:(ABPadLockScreenSetupViewController *)padLockScreenViewController{
    
    [[NSUserDefaults standardUserDefaults] setObject:pin forKey:@"pin"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self showPasscodeWasSuccessfullyResetAlertView];
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
    [self presentABPadLockScreenSetupViewController];
}

- (void)unlockWasUnsuccessful:(NSString *)falsePin afterAttemptNumber:(NSInteger)attemptNumber padLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController{
    
}

- (void)unlockWasCancelledForPadLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController{
    
}


@end

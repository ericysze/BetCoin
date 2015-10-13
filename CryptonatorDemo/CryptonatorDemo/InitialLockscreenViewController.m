//
//  InitialLockscreenViewController.m
//  CryptonatorDemo
//
//  Created by Z on 10/13/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "InitialLockscreenViewController.h"
#import <ABPadLockScreen/ABPadLockScreenSetupViewController.h>
#import <ABPadLockScreen/ABPadLockScreenViewController.h>
#import "SWRevealViewController.h"

@interface InitialLockscreenViewController ()
<ABPadLockScreenSetupViewControllerDelegate,
ABPadLockScreenViewControllerDelegate>

@property (nonatomic) BOOL passcodeViewControllerHasBeenShown;

@end

@implementation InitialLockscreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    animated = YES;
    
    if (self.passcodeViewControllerHasBeenShown == NO) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pin"] == nil){
            [self presentABPadLockScreenSetupViewController];
            
        } else{
            [self presentABPadLockScreenViewController];
        }
    }
    self.passcodeViewControllerHasBeenShown = YES;
}

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

-(void)pushRevealViewController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWRevealViewController *revealViewController = [storyboard instantiateViewControllerWithIdentifier:@"RevealViewControllerIdentifier"];
    [self.navigationController pushViewController:revealViewController animated:YES];
    
}

#pragma mark - ABPadLockScreenSetupViewControllerDelegate methods
- (void)pinSet:(NSString *)pin padLockScreenSetupViewController:(ABPadLockScreenSetupViewController *)padLockScreenViewController{

    [[NSUserDefaults standardUserDefaults] setObject:pin forKey:@"pin"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self pushRevealViewController];
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
    [self pushRevealViewController];
}

- (void)unlockWasUnsuccessful:(NSString *)falsePin afterAttemptNumber:(NSInteger)attemptNumber padLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController{
    
}

- (void)unlockWasCancelledForPadLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController{
    
}

@end

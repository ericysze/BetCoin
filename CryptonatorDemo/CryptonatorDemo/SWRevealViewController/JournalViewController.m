//
//  JournalViewController.m
//  CryptonatorDemo
//
//  Created by Z on 10/13/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "JournalViewController.h"
#import "SWRevealViewController.h"

@interface JournalViewController ()

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
}

@end

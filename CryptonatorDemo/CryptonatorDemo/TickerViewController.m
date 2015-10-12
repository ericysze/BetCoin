//
//  TickerViewController.m
//  CryptonatorDemo
//
//  Created by Z on 10/11/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "TickerViewController.h"
#import "SWRevealViewController.h"
#import "PredictionTableViewCell.h"

@interface TickerViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setup RevealViewController functionality
    if (self.revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    //UITableViewProtocol
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //Register Nib for Cell Reuse Identifier
    [self.tableView registerNib:[UINib nibWithNibName:@"PredictionTableViewCell" bundle:nil] forCellReuseIdentifier:[PredictionTableViewCell reuseIdentifier]];
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
    cell.leftLabel.text = @"pooop";
    NSLog(@"%@",cell.leftLabel.text);
}


@end
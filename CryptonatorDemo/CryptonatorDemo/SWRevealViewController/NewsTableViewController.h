//
//  NewsTableViewController.h
//  CryptonatorDemo
//
//  Created by Z on 10/17/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic) NSMutableArray *articles;


@end

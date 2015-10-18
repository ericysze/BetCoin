//
//  NewsTableViewController.m
//  CryptonatorDemo
//
//  Created by Z on 10/17/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

#import "NewsTableViewController.h"
#import "SWRevealViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "NYTArticle.h"
#import "NYTTableViewCell.h"

@interface NewsTableViewController ()

@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.articles = [[NSMutableArray alloc] init];
    
    //setup RevealViewController functionality
    if (self.revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    animated = YES;
    
    [self getNYTNewsArticlesWithCallbackBlock:^{
        [self.tableView reloadData];
    }];
}

-(void)getNYTNewsArticlesWithCallbackBlock:(void(^)())block{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    for (int i = 0; i<3; i++) {
        NSString *pageString = [@"&page=" stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
        NSString * getString = [@"http://api.nytimes.com/svc/search/v2/articlesearch.json?q=bitcoin&sort=newest&fq=headline.search:(%E2%80%9Cbitcoin%E2%80%9D)&api-key=6f6473f77c32f533ec0e8c7ed0f81177:18:73240506" stringByAppendingString:pageString];
        
        [manager GET:getString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary *results = responseObject[@"response"][@"docs"];
            
            for (NSDictionary *result in results) {
                NYTArticle *article = [[NYTArticle alloc] init];
                article.headline = result[@"headline"][@"main"];
                article.url = result[@"web_url"];
                [self.articles addObject:article];
            }
            
            if (i == 2) {
                block();
            }
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {}];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu",(unsigned long)self.articles.count);
    return self.articles.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NYTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsIdentifier" forIndexPath:indexPath];
    NYTArticle *article = self.articles[indexPath.row];
    cell.headlineLabel.text = article.headline;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NYTArticle *article = self.articles[indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:article.url]];
}

@end

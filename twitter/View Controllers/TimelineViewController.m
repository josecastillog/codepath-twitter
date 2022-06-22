//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Tweet.h"
#include "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.arrayOfTweets = [[NSMutableArray alloc] init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
//            for (NSDictionary *dictionary in tweets) {
//                NSString *text = dictionary[@"text"];
//                NSLog(@"%@", text);
//            }
            self.arrayOfTweets = [NSMutableArray arrayWithArray:tweets];
            
            for (Tweet *tweet in self.arrayOfTweets){
                NSLog(@"%@", tweet.text);
            }
            
            [self.tableView reloadData];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapLogout:(id)sender {
    // TimelineViewController.m
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"
                                                                 forIndexPath:indexPath];
    
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    // NSData *urlData = [NSData dataWithContentsOfURL:url];
    [cell.profileView setImageWithURL:url]; // TODO: Figure out how to use urlData
    
    [cell.replyButton setTitle:@"" forState:UIControlStateNormal];
    [cell.retweetbutton setTitle:@"" forState:UIControlStateNormal];
    [cell.likeButton setTitle:@"" forState:UIControlStateNormal];
    [cell.messageButton setTitle:@"" forState:UIControlStateNormal];
    
    NSMutableString *userWithAt = [NSMutableString stringWithString:[@"@" stringByAppendingString:tweet.user.screenName]];
    
    cell.userLabel.text = userWithAt;
    cell.nameLabel.text = tweet.user.name; // TODO: Change label names
    cell.tweetLabel.text = tweet.text;
    cell.profileView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    cell.profileView.layer.cornerRadius = cell.profileView.frame.size.height/2;
    cell.profileView.layer.borderWidth = 0;
    cell.profileView.clipsToBounds = YES;
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end

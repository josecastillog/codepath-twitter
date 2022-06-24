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
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"
#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ComposeViewControllerDelegate, DetailsViewControllerDelegate, ProfileViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL isMoreDataLoading;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.arrayOfTweets = [[NSMutableArray alloc] init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = [NSMutableArray arrayWithArray:tweets];
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)didTapLogout:(id)sender {
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
    cell.tweet = tweet;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row + 1 == [self.arrayOfTweets count]){
        [self loadMoreData: (int)self.arrayOfTweets.count + 20];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading) {
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            [self loadMoreData: (int)self.arrayOfTweets.count + 20];
        }
    }
}

-(void)loadMoreData:(int)count {
    // Get timeline
    if (self.isMoreDataLoading == false) {
        [[APIManager shared] getHomeTimelineWithMoreTweets:(count) completion:^(NSArray *tweets, NSError *error) {
            if (tweets) {
                self.isMoreDataLoading = false;
                self.arrayOfTweets = [NSMutableArray arrayWithArray:tweets];
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = [NSMutableArray arrayWithArray:tweets];
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        }
    }];
}

- (void)didTweet:(Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

-(void)didFavorite {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = [NSMutableArray arrayWithArray:tweets];
            [self.tableView reloadData];
        }
    }];
}

-(void)didRetweet {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = [NSMutableArray arrayWithArray:tweets];
            [self.tableView reloadData];
        }
    }];
}

- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"compose"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    if ([[segue identifier] isEqualToString:@"details"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        DetailsViewController *detailsController = (DetailsViewController*)navigationController.topViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Tweet *dataToPass = self.arrayOfTweets[indexPath.row];
        detailsController.tweet = dataToPass;
        detailsController.delegate = self;
    }
    if ([[segue identifier] isEqualToString:@"profileSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ProfileViewController *profileController = (ProfileViewController*)navigationController.topViewController;
        User *dataToPass = sender;
        profileController.user = dataToPass;
        profileController.delegate = self;
    }
}

@end

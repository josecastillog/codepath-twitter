//
//  ProfileViewController.m
//  twitter
//
//  Created by Jose Castillo Guajardo on 6/24/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *profileInfo;
@property (strong, nonatomic) NSArray *arrayOfTweets;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [[APIManager shared] getProfileData:(self.user) completion:^(NSArray *userData, NSError *error) {
        if (userData) {
            NSDictionary *dictionary = userData[0];
            self.profileInfo = dictionary[@"user"];
            NSMutableArray *tweets = [Tweet tweetsWithArray:userData];
            self.arrayOfTweets = [NSArray arrayWithArray:tweets];
            [self loadProfile];
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting user data: %@", error.localizedDescription);
        }
    }];
}

-(void)loadProfile {
    self.followersCountLabel.text = [NSString stringWithFormat:@"%@", self.profileInfo[@"followers_count"]];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%@", self.profileInfo[@"friends_count"]];
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height/2;
    self.profileView.layer.borderWidth = 0;
    self.profileView.clipsToBounds = YES;
    NSString *URLString = self.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    [self.profileView setImageWithURL:url];
    NSMutableString *userWithAt = [NSMutableString stringWithString:[@"@" stringByAppendingString:self.user.screenName]];
    self.userNameLabel.text = userWithAt;
    self.screenNameLabel.text = self.user.name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"
                                                                 forIndexPath:indexPath];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    cell.tweet = tweet;
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

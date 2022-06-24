//
//  DetailsViewController.m
//  twitter
//
//  Created by Jose Castillo Guajardo on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#include "APIManager.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    
    if (_tweet.favorited == YES) {
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    }
    if (_tweet.retweeted == YES) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    }
    
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    
    [self.profileView setImageWithURL:url];
    [self.replyButton setTitle:@"" forState:UIControlStateNormal];
    [self.retweetButton setTitle:@"" forState:UIControlStateNormal];
    [self.likeButton setTitle:@"" forState:UIControlStateNormal];
    [self.messageButton setTitle:@"" forState:UIControlStateNormal];
    
    NSMutableString *userWithAt = [NSMutableString stringWithString:[@"@" stringByAppendingString:self.tweet.user.screenName]];
    
    self.userLabel.text = userWithAt;
    self.nameLabel.text = self.tweet.user.name; // TODO: Change label names
    self.tweetLabel.text = self.tweet.text;
    self.retweetLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.likesLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.profileView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height/2;
    self.profileView.layer.borderWidth = 0;
    self.profileView.clipsToBounds = YES;
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted == NO) {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(!error){
                 [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
                 [self refreshData];
                 [self.delegate didRetweet];
             }
         }];
    } else {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(!error){
                 [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
                 [self refreshData];
                 [self.delegate didRetweet];
             }
         }];
    }
}

- (IBAction)didTapFavorite:(id)sender {
    if (self.tweet.favorited == NO) {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(!error){
                 [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
                 [self refreshData];
                 [self.delegate didFavorite];
             }
         }];
    } else {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(!error){
                 [self.likeButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
                 [self refreshData];
                 [self.delegate didFavorite];
             }
         }];
    }
}

- (void)refreshData {
    self.retweetLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.likesLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
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

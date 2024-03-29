//
//  TweetCell.m
//  twitter
//
//  Created by Jose Castillo Guajardo on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "DateTools.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profileView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileView setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *) tweet {
    _tweet = tweet;
    
    if (self.tweet.favorited == YES) {
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    }
    
    if (self.tweet.retweeted == YES) {
        [self.retweetbutton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    } else {
        [self.retweetbutton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    }
    
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    [self.profileView setImageWithURL:url];
    [self.replyButton setTitle:@"" forState:UIControlStateNormal];
    [self.retweetbutton setTitle:@"" forState:UIControlStateNormal];
    [self.likeButton setTitle:@"" forState:UIControlStateNormal];
    [self.messageButton setTitle:@"" forState:UIControlStateNormal];
    NSMutableString *userWithAt = [NSMutableString stringWithString:[@"@" stringByAppendingString:tweet.user.screenName]];
    self.userLabel.text = userWithAt;
    self.nameLabel.text = tweet.user.name;
    self.tweetLabel.text = tweet.text;
    self.dateLabel.text = [NSDate shortTimeAgoSinceDate:tweet.createdAt]; // TODO: Date Label Not Working
    self.profileView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height/2;
    self.profileView.layer.borderWidth = 0;
    self.profileView.clipsToBounds = YES;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.locale = [NSLocale currentLocale];// this ensures the right separator behavior
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%@", [numberFormatter stringForObjectValue:[NSNumber numberWithInt:tweet.retweetCount]]];
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@", [numberFormatter stringForObjectValue:[NSNumber numberWithInt:tweet.favoriteCount]]];
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate tweetCell:self didTap:self.tweet.user];
}

- (IBAction)didTapFavorite:(id)sender {
    
    if (self.tweet.favorited == NO) {
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(!error){
                 [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
                 self.tweet.favorited = YES;
                 self.tweet.favoriteCount += 1;
                 [self refreshData];
             }
         }];
    } else {
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(!error){
                 [self.likeButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
                 self.tweet.favorited = NO;
                 self.tweet.favoriteCount -= 1;
                 [self refreshData];
             }
         }];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted == NO) {
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(!error){
                 [self.retweetbutton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
                 self.tweet.retweeted = YES;
                 self.tweet.retweetCount += 1;
                 [self refreshData];
             }
         }];
    } else {
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(!error){
                 [self.retweetbutton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
                 self.tweet.retweeted = NO;
                 self.tweet.retweetCount -= 1;
                 [self refreshData];
             }
         }];
    }
}

- (void)refreshData {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.locale = [NSLocale currentLocale];// this ensures the right separator behavior
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%@", [numberFormatter stringForObjectValue:[NSNumber numberWithInt:self.tweet.retweetCount]]];
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@", [numberFormatter stringForObjectValue:[NSNumber numberWithInt:self.tweet.favoriteCount]]];
}

@end

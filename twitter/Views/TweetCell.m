//
//  TweetCell.m
//  twitter
//
//  Created by Jose Castillo Guajardo on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *) _tweet {
    Tweet *tweet = _tweet;
    
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    
    [self.profileView setImageWithURL:url]; // TODO: Figure out how to use urlData
    [self.replyButton setTitle:@"" forState:UIControlStateNormal];
    [self.retweetbutton setTitle:@"" forState:UIControlStateNormal];
    [self.likeButton setTitle:@"" forState:UIControlStateNormal];
    [self.messageButton setTitle:@"" forState:UIControlStateNormal];
    
    NSMutableString *userWithAt = [NSMutableString stringWithString:[@"@" stringByAppendingString:tweet.user.screenName]];
    
    self.userLabel.text = userWithAt;
    self.nameLabel.text = tweet.user.name; // TODO: Change label names
    self.tweetLabel.text = tweet.text;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    self.profileView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height/2;
    self.profileView.layer.borderWidth = 0;
    self.profileView.clipsToBounds = YES;
}

@end

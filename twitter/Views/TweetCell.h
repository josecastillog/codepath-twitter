//
//  TweetCell.h
//  twitter
//
//  Created by Jose Castillo Guajardo on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TweetCellDelegate;

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetbutton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) id<TweetCellDelegate> delegate;
@property (strong, nonatomic) Tweet *tweet;

// Methods
- (void)setTweet:(Tweet *) tweet;

@end

@protocol TweetCellDelegate
- (void)tweetCell:(TweetCell *) tweetCell didTap: (User *)user;
@end

NS_ASSUME_NONNULL_END

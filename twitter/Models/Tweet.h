//
//  Tweet.h
//  twitter
//
//  Created by Jose Castillo Guajardo on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tweet : NSObject

// MARK: Properties

@property (strong, nonatomic) NSString *idStr; // For favoriting, retweeting & replying
@property (strong, nonatomic) NSString *text; // Text content of tweet
@property (strong, nonatomic) User *user; // Contains Tweet author's name, screenname, etc.
@property (strong, nonatomic) NSString *createdAtString; // Display date
@property (strong, nonatomic) NSDate *createdAt;
@property (nonatomic) int favoriteCount; // Update favorite count label
@property (nonatomic) BOOL favorited; // Configure favorite button
@property (nonatomic) int retweetCount; // Update favorite count label
@property (nonatomic) BOOL retweeted; // Configure retweet button

// For Retweets
@property (nonatomic, strong) User *retweetedByUser;  // If the tweet is a retweet, this will be the user who retweeted

// MARK: Methods

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END

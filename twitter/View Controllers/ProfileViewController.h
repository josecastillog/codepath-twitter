//
//  ProfileViewController.h
//  twitter
//
//  Created by Jose Castillo Guajardo on 6/24/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProfileViewControllerDelegate

@end

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) Tweet *tweet;
@property (strong, nonatomic) User *user;
@property (weak, nonatomic) id<ProfileViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

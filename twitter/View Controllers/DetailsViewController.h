//
//  DetailsViewController.h
//  twitter
//
//  Created by Jose Castillo Guajardo on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DetailsViewControllerDelegate
- (void)didFavorite;
- (void)didRetweet;
@end

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) id<DetailsViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

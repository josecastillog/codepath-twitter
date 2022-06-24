//
//  ComposeViewController.m
//  twitter
//
//  Created by Jose Castillo Guajardo on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (strong, nonatomic) NSString *profilePicUrl;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    // Do any additional setup after loading the view.
    [[APIManager shared] getProfilePicture:^(NSString *profilePicUrl, NSError *error) {
        if (profilePicUrl) {
            NSLog(@"%@", profilePicUrl);
            NSString *URLString = profilePicUrl;
            NSURL *url = [NSURL URLWithString:URLString];
            self.profileView.layer.backgroundColor=[[UIColor clearColor] CGColor];
            self.profileView.layer.cornerRadius = self.profileView.frame.size.height/2;
            self.profileView.layer.borderWidth = 0;
            self.profileView.clipsToBounds = YES;
            [self.profileView setImageWithURL:url];
        } else {
            NSLog(@"😫😫😫 Error getting profile pic: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.textField.text = @"";
    self.textField.textColor = [UIColor blackColor];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set the max character limit
    int characterLimit = 20;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.textField.text stringByReplacingCharactersInRange:range withString:text];

    // TODO: Update character count label
    self.characterCountLabel.text = [NSString stringWithFormat:@"%@/%@", [NSString stringWithFormat:@"%lu", (unsigned long)newText.length], @"280"];

    // Should the new text should be allowed? True/False
    return newText.length < characterLimit;
}

- (IBAction)tweet:(id)sender {
    NSString *composedTweet = self.textField.text;
    [[APIManager shared] postStatusWithText:(composedTweet) completion:^(Tweet *tweet, NSError *error) {
        if(error){
                NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
        }
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    
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

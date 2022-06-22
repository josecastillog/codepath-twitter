//
//  ComposeViewController.m
//  twitter
//
//  Created by Jose Castillo Guajardo on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textField;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)tweet:(id)sender {
    NSString *composedTweet = self.textField.text;
    NSLog(@"%@", composedTweet);
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

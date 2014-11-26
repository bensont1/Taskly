//
//  SettingsViewController.m
//  Taskly
//
//  Created by Miles Laff on 10/20/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
- (IBAction)logoutPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profImage;

@end

@implementation SettingsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self getFBProfilePic];
    [self.logoutButton setTintColor:[UIColor blueColor]];

}

- (IBAction)logoutPressed:(id)sender {
    
    [PFUser logOut];
}


-(void)getFBProfilePic {
    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:@"facebookId"]]];
    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
    NSLog(@"FACEBOOK ID: %@",[[PFUser currentUser] objectForKey:@"facebookId"]);
    [NSURLConnection sendAsynchronousRequest:profilePictureURLRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError) {
                               UIImage *profile = [UIImage imageWithData:data];
                               [self.profImage setImage:profile];
                           }];
}


@end

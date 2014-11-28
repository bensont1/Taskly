//
//  SettingsViewController.m
//  Taskly
//
//  Created by Miles Laff on 10/20/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "SettingsViewController.h"
#import "Utilities.h"

@interface SettingsViewController ()
- (IBAction)logoutPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profImage;

@end

@implementation SettingsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
     self.nameLabel.text = [[PFUser currentUser] objectForKey:@"fullName"];
    [self getFBProfilePic];
    [self.logoutButton setTintColor:[UIColor orangeColor]];

}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)logoutPressed:(id)sender {
    [PFUser logOut];
    [self.parentViewController.tabBarController setSelectedIndex:0];

}


-(void)getFBProfilePic {
    if([[PFUser currentUser] objectForKey:@"facebookId"] != nil) {
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:@"facebookId"]]];
        NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
        [NSURLConnection sendAsynchronousRequest:profilePictureURLRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data,
                                                   NSError *connectionError) {
                                   UIImage *profile = [UIImage imageWithData:data];
                                    [self.profImage setImage:[Utilities getRoundedRectImageFromImage:profile onReferenceView:self.profImage withCornerRadius:self.profImage.frame.size.width/2]];
                               }];
    }
    else {
        UIImage *profile = [UIImage imageNamed:@"placeholder_image.png"];
        [self.profImage setImage:[Utilities getRoundedRectImageFromImage:profile onReferenceView:self.profImage withCornerRadius:self.profImage.frame.size.width/2]];
    }

}



@end

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

@end

@implementation SettingsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.logoutButton setTintColor:[UIColor blueColor]];
}

- (IBAction)logoutPressed:(id)sender {
    
    [PFUser logOut];
}
@end

//
//  SettingsViewController.m
//  Taskly
//
//  Created by Miles Laff on 10/20/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.userLabel.text = [[PFUser currentUser] objectForKey:@"fullName"];
}

- (IBAction)performLogout:(id)sender {
    [PFUser logOut];
}
@end

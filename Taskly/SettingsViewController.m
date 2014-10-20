//
//  SettingsViewController.m
//  Taskly
//
//  Created by Miles Laff on 10/20/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

- (IBAction)performLogout:(id)sender {
    [PFUser logOut];
}
@end

//
//  SettingsViewController.h
//  Taskly
//
//  Created by Miles Laff on 10/20/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SettingsViewController : UIViewController

- (IBAction)performLogout:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@end

//
//  RespondToTaskViewController.m
//  Taskly
//
//  Created by Miles Laff on 10/27/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "RespondToTaskViewController.h"

@interface RespondToTaskViewController ()

@end

@implementation RespondToTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Submit"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(submitResponse)];
    self.navigationItem.rightBarButtonItem = submitButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

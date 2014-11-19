//
//  MainTaskPageCell.h
//  Taskly
//
//  Created by Miles Laff on 11/19/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTaskPageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profImage;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellDetails;
@property (weak, nonatomic) IBOutlet UILabel *cellPrice;

@end

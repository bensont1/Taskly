//
//  TaskTabViewController.m
//  Taskly
//
//  Created by Miles Laff on 10/13/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "TaskTabViewController.h"
#import "TaskDetailViewController.h"
#import "TaskManager.h"
#import "Task.h"

@interface TaskTabViewController ()

@end

@implementation TaskTabViewController {
    NSMutableArray *tasks;
    Task *selectedTask;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO; //removes weird space above first cell
    
    Task *task1 = [[Task alloc] init];
    task1.title = @"TASK";
    task1.detailedInfo = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam";
    
    Task *task2 = [[Task alloc] init];
    task2.title = @"TASK";
    task2.detailedInfo = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam";
    
    Task *task3 = [[Task alloc] init];
    task3.title = @"TASK";
    task3.detailedInfo = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam";
    
    Task *task4 = [[Task alloc] init];
    task4.title = @"TASK";
    task4.detailedInfo = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam";
    
    Task *task5 = [[Task alloc] init];
    task5.title = @"TASK";
    task5.detailedInfo = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam";
    tasks = [[NSMutableArray alloc] initWithObjects:task1, task2, task3, task4, task5, nil];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tasks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    Task *currentTask = tasks[indexPath.row];
    
    cell.textLabel.text = currentTask.title;
    cell.detailTextLabel.text = currentTask.detailedInfo;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedTask = tasks[indexPath.row];
    [self performSegueWithIdentifier:@"segueToTaskDetail" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TaskDetailViewController *destination = segue.destinationViewController;
    destination.task = selectedTask;
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

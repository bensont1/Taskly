//
//  AppDelegate.m
//  Taskly
//
//  Created by Miles Laff on 10/12/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

// Below are listed in our REQUIREMENTS doc, for grading purposes

// Below are nice features to add
#warning TODO: implement more Facebook stuff, get profile picture, email, phone number to use somewhere
#warning TODO: fill out email field when responding to task automaticlaly with email stored on Parse
#warning TODO: create custom row view, to display facebook profile image, task title and details, and price, time
#warning TODO: create real time countdown timer on task
#warning TODO: allow users to search by task given location
#warning TODO: create negotiation process, ask task originator for said price
#warning TODO: use previous completed task history to give user tasks from the same person
#warning TODO: create a rating mechanism for trusted task do-ers, increase as more tasks are marked complete and task originator has marked success/good job done

#warning TODO: Allow useres to use Phone Number to login, instead of Facebook
#warning TODO: Allow Points of Interest search on maps, currently only citys are searched, example: Safeway, Frys
#warning TODO: Push notifications to users/filler when job has been accepted/completed

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"9JS0rzJTC9cCKVLZx2atJmLrZcwuVhCOa8kLq5Q0"
                  clientKey:@"2tuVaLZ9AT7pVFXHRFqO5JzKSoic9UbuT4NGpZWj"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Initialize FacebookUtils
    [PFFacebookUtils initializeFacebook];
    
    //set UI options//button color changes something in here
    self.window.tintColor = [UIColor colorWithRed:255.0f/255.0f
                                            green:255.0f/255.0f
                                             blue:255.0f/255.0f
                                            alpha:1.0f];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:21.0f/255.0f
                                                    green:189.0f/255.0f
                                                    blue:170.0f/255.0f
                                                    alpha:1.0f]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:21.0f/255.0f
                                                           green:189.0f/255.0f
                                                            blue:170.0f/255.0f
                                                           alpha:1.0f]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
            [UIColor colorWithRed:255.0/255.0f
                            green:255.0/255.0f
                             blue:255.0/255.0f
                             alpha:1.0],
    UITextAttributeTextColor, nil]];

    //color: 57,129,125
    return YES;
}

// Facebook Setup Method
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Facebook Setup
    // Logs 'install' and 'app activate' App Events.
    [FBAppEvents activateApp];
    
    // Get Session from Facebook
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // Close Facebook connection
    [[PFFacebookUtils session] close];
}

@end

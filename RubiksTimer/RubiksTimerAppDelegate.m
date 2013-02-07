//
//  RubiksTimerAppDelegate.m
//  RubiksTimer
//
//  Created by Jichao Li on 5/21/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import "RubiksTimerAppDelegate.h"
#import "RubiksTimerOneStat.h"
#import "RubiksTimerStatsViewController.h"
#import "RubiksTimerMoreViewController.h"

#define sinaAppKey @"3485861470"
#define sinaAppSecret @"84628316a02f82a8a26090300b6c5414"
#define fbAppKey @"325743574177915"
#define fbAddSecret @"4be20a4afe82b03fd136d0636adf2ddf"


@implementation RubiksTimerAppDelegate {
    NSMutableArray *myStats;
}
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    myStats = [NSMutableArray arrayWithCapacity:20];
    RubiksTimerOneStat *numOfSolves = [[RubiksTimerOneStat alloc] init];
    numOfSolves.statType = @"Number of solves";
    numOfSolves.statValue = @"0";
    [myStats addObject:numOfSolves];
    
    RubiksTimerOneStat *bestTime = [[RubiksTimerOneStat alloc] init];
    bestTime.statType = @"Best time";
    bestTime.statValue = @"DNF";
    [myStats addObject:bestTime];
    
    RubiksTimerOneStat *worstTime = [[RubiksTimerOneStat alloc] init];
    worstTime.statType = @"Worst time";
    worstTime.statValue = @"DNF";
    [myStats addObject:worstTime];
    
    RubiksTimerOneStat *current5 = [[RubiksTimerOneStat alloc] init];
    current5.statType = @"Current average of 5";
    current5.statValue = @"DNF";
    [myStats addObject:current5];
    
    RubiksTimerOneStat *best5 = [[RubiksTimerOneStat alloc] init];
    best5.statType = @"Best average of 5";
    best5.statValue = @"DNF";
    [myStats addObject:best5];
    
    RubiksTimerOneStat *current12 = [[RubiksTimerOneStat alloc] init];
    current12.statType = @"Current average of 12";
    current12.statValue = @"DNF";
    [myStats addObject:current12];
    
    RubiksTimerOneStat *best12 = [[RubiksTimerOneStat alloc] init];
    best12.statType = @"Best average of 12";
    best12.statValue = @"DNF";
    [myStats addObject:best12];
    
    RubiksTimerOneStat *current100 = [[RubiksTimerOneStat alloc] init];
    current100.statType = @"Current average of 100";
    current100.statValue = @"DNF";
    [myStats addObject:current100];
    
    RubiksTimerOneStat *best100 = [[RubiksTimerOneStat alloc] init];
    best100.statType = @"Best average of 100";
    best100.statValue = @"DNF";
    [myStats addObject:best100];
    
    RubiksTimerOneStat *sessionAvg = [[RubiksTimerOneStat alloc] init];
    sessionAvg.statType = @"Session Average";
    sessionAvg.statValue = @"DNF";
    [myStats addObject:sessionAvg];
    
    RubiksTimerOneStat *sessionMean = [[RubiksTimerOneStat alloc] init];
    sessionMean.statType = @"Session Mean";
    sessionMean.statValue = @"DNF";
    [myStats addObject:sessionMean];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UINavigationController *navigationController = [[tabBarController viewControllers] objectAtIndex:1];
    RubiksTimerStatsViewController *statsViewController = [[navigationController viewControllers] objectAtIndex:0];
    statsViewController.stats = myStats;
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *who = [defaults objectForKey:@"whoStartFBLogin"];
    if ([who isEqualToString:@"moreViewController"]) {
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        UINavigationController *navigationController = [[tabBarController viewControllers] objectAtIndex:3];
        RubiksTimerMoreViewController *moreViewController = [[navigationController viewControllers] objectAtIndex:0];
        return [moreViewController.facebook handleOpenURL:url];
    } else {
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        UINavigationController *navigationController = [[tabBarController viewControllers] objectAtIndex:1];
        RubiksTimerStatsViewController *statsViewController = [[navigationController viewControllers] objectAtIndex:0];
        return [statsViewController.facebook handleOpenURL:url];
    }
     
}
/*
- (void)fbDidLogin {
    NSLog(@"%@", @"did login");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UINavigationController *navigationController = [[tabBarController viewControllers] objectAtIndex:3];
    RubiksTimerMoreViewController *moreViewController = [[navigationController viewControllers] objectAtIndex:0];
    moreViewController.isFBIn = YES;
    [moreViewController.tableView reloadData];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"http://itunes.apple.com/us/app/chaotimer/id537516001?ls=1&mt=8", @"link",
                                   @"it is fun", @"description",
                                   @"ChaoTimer", @"name",nil];
    [facebook dialog:@"feed" andParams:params andDelegate:self];
}
*/

@end

//
//  RubiksTimerMoreViewController.m
//  ChaoTimer
//
//  Created by Jichao Li on 6/24/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import "RubiksTimerMoreViewController.h"
#import <MessageUI/MessageUI.h>
#import "WBEngine.h"
#import "FBConnect.h"
#import "RubiksTimerSettingViewController.h"

#define sinaAppKey @"3485861470"
#define sinaAppSecret @"84628316a02f82a8a26090300b6c5414"
#define fbAppKey @"325743574177915"
#define fbAddSecret @"4be20a4afe82b03fd136d0636adf2ddf"

@interface RubiksTimerMoreViewController ()
@end

@implementation RubiksTimerMoreViewController

@synthesize weiBoEngine;
@synthesize facebook;
@synthesize renren;
@synthesize rows = _rows;
@synthesize isWeiboIn;
@synthesize isFBIn;
@synthesize isRRIn;

- (NSArray *)rows {
    if (!_rows) {
        _rows = [[NSArray alloc] initWithObjects: NSLocalizedString(@"version", NULL), NSLocalizedString(@"rate", NULL), NSLocalizedString(@"send feedback", NULL), NSLocalizedString(@"tell friends", NULL), nil];
    }
    return _rows;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.title = NSLocalizedString(@"More", NULL);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    if ( [[UIDevice currentDevice].systemVersion doubleValue] >= 6.0f) {
        titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:22.0f];
    } else {
        titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    }
    [titleLabel setShadowColor:[UIColor darkGrayColor]];
    [titleLabel setShadowOffset:CGSizeMake(0, -1)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"More", NULL);
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.1f green:0.5f blue:0.75f alpha:1]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:0.2f green:0.6f blue:0.8f alpha:1]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        isFBIn = YES;
    } else {
        isFBIn = NO;
    }
    if ([defaults objectForKey:@"WeiboAccessTokenKey"]) {
        isWeiboIn = YES;
    } else {
        isWeiboIn = NO;
    }
    if ([defaults objectForKey:@"RenrenAccessTokenKey"]) {
        isRRIn = YES;
    } else {
        isRRIn = NO;
    }
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // sinaweibo
    WBEngine *engine = [[WBEngine alloc] initWithAppKey:sinaAppKey appSecret:sinaAppSecret];  
    [engine setRootViewController:self];  
    [engine setDelegate:self];  
    [engine setRedirectURI:@"http://"];  
    [engine setIsUserExclusive:NO];  
    self.weiBoEngine = engine;
    // facebook
    facebook = [[Facebook alloc] initWithAppId:fbAppKey andDelegate:self];
    renren = [Renren sharedRenren];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 2;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    //NSString *appVersion = [NSString stringWithFormat:@"v%@ (Build %@)", version, build];
    NSString *appVersion = [NSString stringWithFormat:@"%@", version];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        isFBIn = YES;
    }
    if ([defaults objectForKey:@"WeiboAccessTokenKey"]) {
        isWeiboIn = YES;
    }
    if ([defaults objectForKey:@"RRAccessTokenKey"]) {
        isRRIn = YES;
    }
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    switch ([indexPath indexAtPosition:0]) {
        case 0:
            switch ([indexPath indexAtPosition:1]) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"version", NULL);
                    cell.detailTextLabel.text = appVersion;
                    cell.imageView.image = [UIImage imageNamed:@"version.png"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch ([indexPath indexAtPosition:1]) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"setting", NULL);
                    cell.detailTextLabel.text = @"";
                    cell.imageView.image = [UIImage imageNamed:@"setting.png"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch ([indexPath indexAtPosition:1]) {
                case 0:
                    if (isWeiboIn) {
                        cell.textLabel.text = NSLocalizedString(@"weibo logout", NULL);
                        cell.detailTextLabel.text = @"";
                        cell.imageView.image = [UIImage imageNamed:@"sina.png"];
                        break;
                    } else {
                        cell.textLabel.text = NSLocalizedString(@"weibo login", NULL);
                        cell.detailTextLabel.text = @"";
                        cell.imageView.image = [UIImage imageNamed:@"sinaOut.png"];
                        break;
                    }
                case 1:
                    if (isFBIn) {
                        cell.textLabel.text = NSLocalizedString(@"facebook logout", NULL);
                        cell.detailTextLabel.text = @"";
                        cell.imageView.image = [UIImage imageNamed:@"facebook.png"];
                        break;
                    } else {
                        cell.textLabel.text = NSLocalizedString(@"facebook login", NULL);
                        cell.detailTextLabel.text = @"";
                        cell.imageView.image = [UIImage imageNamed:@"facebookOut.png"];
                        break;
                    }
                case 2:
                    if (isRRIn) {
                        cell.textLabel.text = NSLocalizedString(@"renren logout", NULL);
                        cell.detailTextLabel.text = @"";
                        cell.imageView.image = [UIImage imageNamed:@"renren.png"];
                        break;
                    } else {
                        cell.textLabel.text = NSLocalizedString(@"renren login", NULL);
                        cell.detailTextLabel.text = @"";
                        cell.imageView.image = [UIImage imageNamed:@"renrenOut.png"];
                    }
                default:
                    break;
            }
            break;
        case 3:
            switch ([indexPath indexAtPosition:1]) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"rate", NULL);
                    cell.detailTextLabel.text = @"";
                    cell.imageView.image = [UIImage imageNamed:@"rate.png"];
                    break;
                default:
                    break;
            }
            break;
        case 4:
            switch ([indexPath indexAtPosition:1]) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"send feedback", NULL);
                    cell.detailTextLabel.text = @"";
                    cell.imageView.image = [UIImage imageNamed:@"feedback.png"];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"tell friends", NULL);
                    cell.detailTextLabel.text = @"";
                    cell.imageView.image = [UIImage imageNamed:@"tellFriends.png"];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    switch ([indexPath indexAtPosition:0]) {
        case 0:
            switch ([indexPath indexAtPosition:1]) {
                case 0:
                    break;
                default:
                    break;
            }
            break;
        case 1:
            [self pushToSettingView];
            [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
            break;
        case 2:
            switch ([indexPath indexAtPosition:1]) {
                case 0:
                    if (isWeiboIn) {
                        [self weiboLogout];
                        [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
                    } else {
                        [self weiboLogin];
                        [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
                    }
                    break;
                case 1:
                    if (isFBIn) {
                        [self FBLogout];
                        [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
                    } else {
                        [self FBLogin];
                        [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
                    }
                    break;
                case 2:
                    if (isRRIn) {
                        [self renrenLogout];
                        [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
                    } else {
                        [self renrenLogin];
                        [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
                    }
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch ([indexPath indexAtPosition:1]) {
                case 0:
                    [self rateForApp];
                    [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
                    break;
                default:
                    break;
            }
            break;
        case 4:
            switch ([indexPath indexAtPosition:1]) {
                case 0:
                    [self sendFeedback];
                    [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
                    break;
                case 1:
                    [self tellFriends];
                    [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }

    
}

- (IBAction) pushToSettingView {
    RubiksTimerSettingViewController *settingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"setting"];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

- (IBAction) tellFriends {
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init]; 
    mc.mailComposeDelegate = self;
    [mc.navigationBar setTintColor:[UIColor colorWithRed:0.1f green:0.5f blue:0.75f alpha:1]];
    [mc setSubject:NSLocalizedString(@"mailSubject", NULL)];
    [mc setMessageBody:NSLocalizedString(@"mailBody", NULL) isHTML:YES];
    [mc setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:mc animated:YES completion:nil];
}

- (IBAction) sendFeedback {
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init]; 
    mc.mailComposeDelegate = self;
    [mc.navigationBar setTintColor:[UIColor colorWithRed:0.1f green:0.5f blue:0.75f alpha:1]];
    [mc setSubject:@"Feedback of ChaoTimer"];
    [mc setToRecipients:[NSArray arrayWithObjects:@"nijixuchao@gmail.com", nil]];
    [mc setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:mc animated:YES completion:nil];
}


- (IBAction)rateForApp {
    NSLog(@"===== openURL! =====");
    NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d", 537516001];  
    NSLog(@"URL string:%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(IBAction) weiboLogin{
    [weiBoEngine logOut];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [weiBoEngine logIn]; 
    [self.tableView reloadData];
}

-(IBAction) weiboLogout {
    [weiBoEngine logOut];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"WeiboAccessTokenKey"];
    [defaults removeObjectForKey:@"WeiboExpireTimeKey"];
    [defaults synchronize];
    isWeiboIn = NO;
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"Successfully logout", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];
    [alertView show];
    [self.tableView reloadData];
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:engine.accessToken forKey:@"WeiboAccessTokenKey"];
    [defaults setInteger:engine.expireTime forKey:@"WeiboExpirationDateKey"];
    isWeiboIn = YES;
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"Successfully login", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];
	[alertView show];
    [self.tableView reloadData];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"WeiboAccessTokenKey"]) {
        [defaults removeObjectForKey:@"WeiboAccessTokenKey"];
        [defaults removeObjectForKey:@"WeiboExpireTimeKey"];
        [defaults synchronize];
    }
    isWeiboIn = NO;
    NSLog(@"didFailToLogInWithError: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"Fail to login", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];	
    [alertView show];
    
    [self.tableView reloadData];
}

-(IBAction) FBLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"moreViewController" forKey:@"whoStartFBLogin"];
    [defaults synchronize];
    facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
    facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    NSLog(@"AT:%@", facebook.accessToken);
    NSLog(@"EXD:%@", facebook.expirationDate);
    /*if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    */
    if (![facebook isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream", 
                                nil];
        [facebook authorize:permissions];
    }
    [self.tableView reloadData];
}

-(IBAction)FBLogout{
    [facebook logout];
}

- (void)fbDidLogin {
    NSLog(@"%@", @"did login");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    isFBIn = YES;
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"Successfully login", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];
	[alertView show];
    [self.tableView reloadData];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"%@", @"did not login");
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt {
    NSLog(@"%@", @"did extend token");
}


- (void)fbSessionInvalidated{
    NSLog(@"%@", @"session invalidated");
}

- (void) fbDidLogout {
    NSLog(@"%@", @"did logout");
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        NSLog(@"%@", @"remove");
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
    isFBIn = NO;
    [self.tableView reloadData];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"Successfully logout", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];
    [alertView show];
}

-(IBAction) renrenLogin{
    [renren logout:self];
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_feed", 
                                nil];
    [renren authorizationWithPermisson:permissions andDelegate:self];
    [self.tableView reloadData];
}

- (void)renrenDidLogin:(Renren *)renren {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.renren.accessToken forKey:@"RenrenAccessTokenKey"];
    [defaults setObject:self.renren.expirationDate forKey:@"RenrenExpirationDateKey"];
    isRRIn = YES;
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"Successfully login", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];
	[alertView show];
    [self.tableView reloadData];
}


-(IBAction) renrenLogout {
    [renren logout:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"RenrenAccessTokenKey"];
    [defaults removeObjectForKey:@"RenrenExpireTimeKey"];
    [defaults synchronize];
    isRRIn = NO;
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"Successfully logout", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];
    [alertView show];
    [self.tableView reloadData];
}

- (void)renrenDidLogout:(Renren *)renren {
    NSLog(@"%@", @"renren did logout");
}

- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"RenrenAccessTokenKey"]) {
        [defaults removeObjectForKey:@"RenrenAccessTokenKey"];
        [defaults removeObjectForKey:@"RenrenExpireTimeKey"];
        [defaults synchronize];
    }
    isRRIn = NO;
    NSLog(@"didFailToLogInWithError: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"Fail to login", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];	
    [alertView show];
    
    [self.tableView reloadData];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller   
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error   
{  
    switch (result)   
    {  
        case MFMailComposeResultCancelled: 
            NSLog(@"Mail send canceled..."); 
            break; 
        case MFMailComposeResultSaved: 
            NSLog(@"Mail saved..."); 
            break; 
        case MFMailComposeResultSent: 
            NSLog(@"Mail sent..."); 
            break; 
        case MFMailComposeResultFailed: 
            NSLog(@"Mail send errored: %@...", [error localizedDescription]); 
            break; 
        default: 
            break;  
    }  
    [self.tableView reloadData];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}  

@end

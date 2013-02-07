//
//  RubiksTimerStatsViewController.m
//  RubiksTimer
//
//  Created by Jichao Li on 5/26/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import "RubiksTimerStatsViewController.h"
#import "RubiksTimerOneStat.h"
#import "RubiksTimerDataProcessing.h"
#import "RubiksTimerTimeObj.h"
#import "RubiksTimerStatDetailViewController.h"
#import "RubiksTimerSolveDetailViewController.h"
#import "RubiksTimerSessionViewController.h"
#import "RubiksTimerSessionManager.h"
#import "WBEngine.h"
#import "Twitter/Twitter.h"

#define sinaAppKey @"3485861470"
#define sinaAppSecret @"84628316a02f82a8a26090300b6c5414"
#define fbAppKey @"325743574177915"
#define fbAddSecret @"4be20a4afe82b03fd136d0636adf2ddf"
#define renrenAppKey @"406457ad9904400eaf76e92958dd9658"
#define renrenAppSecret @"8923341e62814acfb37dd54ab99c1f30"

@interface RubiksTimerStatsViewController ()
@property (nonatomic, strong) RubiksTimerDataProcessing *dataProcessor;
@property (nonatomic, strong) NSString *currentSession;
@end

@implementation RubiksTimerStatsViewController
@synthesize popoverController;
@synthesize stats;
@synthesize weiBoEngine;
@synthesize facebook;
@synthesize renren;
@synthesize dataProcessor = _dataProcessor;
@synthesize currentSession = _currentSession;


BOOL hasPopover = NO;
UIImage *snapshot;

- (RubiksTimerDataProcessing *) dataProcessor {
    if (!_dataProcessor) {
        _dataProcessor = [RubiksTimerDataProcessing initWithName:self.currentSession];
    }
    return _dataProcessor;
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
    NSLog(@"did load");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.currentSession = [defaults stringForKey:@"currentSession"];
    
    self.navigationItem.title = NSLocalizedString(@"Stats", NULL);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    if ( [[UIDevice currentDevice].systemVersion doubleValue] >= 6.0f) {
        titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:22.0f];
    } else {
        titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    }
    [titleLabel setShadowColor:[UIColor darkGrayColor]];
    [titleLabel setShadowOffset:CGSizeMake(0, -1)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"Stats", NULL);
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.1f green:0.5f blue:0.75f alpha:1]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:0.2f green:0.6f blue:0.8f alpha:1]];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        UIImage *image = [UIImage imageNamed:@"navigationBar.png"];
//        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:0];
//    } else {
//        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.1f green:0.5f blue:0.75f alpha:1]];
//    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(displayActionSheet)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_menu_icon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(presentSessionView)];
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Sina Weibo
    WBEngine *engine = [[WBEngine alloc] initWithAppKey:sinaAppKey appSecret:sinaAppSecret];  
    [engine setRootViewController:self];  
    [engine setDelegate:self];  
    [engine setRedirectURI:@"http://"];  
    [engine setIsUserExclusive:YES];  
    self.weiBoEngine = engine;  
    //Facebook
    facebook = [[Facebook alloc] initWithAppId:fbAppKey andDelegate:self];
    renren = [Renren sharedRenren];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"will disappear");
    [self.dataProcessor storeIntoFile];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"did appear");
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //self.currentSession = [defaults stringForKey:@"currentSession"];
    //self.dataProcessor = [RubiksTimerSessionManager getCurrentSessionfromName:self.currentSession];
    [super viewDidAppear:animated];
    //[self performSelectorInBackground:@selector(getScreenShot) withObject:nil];
}

- (void)getScreenShot
{
    NSLog(@"screen shot");
    /*
    UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.bounds.size, YES, 1.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext() ];
    snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();*/
    /*NSLog([@"size" stringByAppendingFormat:@" %f %f", self.tableView.superview.bounds.size.height, self.tableView.superview.bounds.size.width]);
    */
    UIGraphicsBeginImageContext(self.tableView.superview.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.tableView.superview.layer renderInContext:context];
    snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"will appear");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.currentSession = [defaults stringForKey:@"currentSession"];
    //NSLog(self.currentSession);
    /*if (self.currentSession == nil) {
        self.currentSession = @"main session";
        [defaults setObject:self.currentSession forKey:@"currentSession"];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //NSLog(@"Get document path: %@",[path objectAtIndex:0]);
        NSString *fileName = [[path objectAtIndex:0] stringByAppendingPathComponent:@"timeLog"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:fileName];
        if (data) {
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            self.dataProcessor = [unarchiver decodeObjectForKey:@"timeProcessingObj"];
            [unarchiver finishDecoding];
            self.dataProcessor.sessionName = @"main session";
        }
    }else {*/
        self.dataProcessor = [RubiksTimerSessionManager getCurrentSessionfromName:self.currentSession];
    self.dataProcessor.sessionName = self.currentSession;
    //}

    
    [self updateStats];
    //NSLog(@"type get: %@", self.dataProcessor.CurrentType);
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
    
    //return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self.currentSession isEqualToString:@"main session"]) {
        return NSLocalizedString(@"main session", NULL);
    } else
        return self.currentSession;        
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.stats count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
            
    static NSString *CellIdentifier = @"StatsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    RubiksTimerOneStat *oneStats = [self.stats objectAtIndex:indexPath.row];
    cell.textLabel.text = NSLocalizedString(oneStats.statType, NULL);
    cell.detailTextLabel.text = oneStats.statValue;
    if (![cell.textLabel.text isEqualToString:NSLocalizedString(@"Number of solves: ", NULL)]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    // Configure the cell...
    
    return cell;
}

- (void)updateStats{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.currentSession = [defaults stringForKey:@"currentSession"];
    self.dataProcessor = [RubiksTimerDataProcessing getFromFileByName:self.currentSession];
    int numberOfSolves = self.dataProcessor.numberOfSolves;
    [[[[[self tabBarController] tabBar] items] objectAtIndex:0] setBadgeValue:[NSString stringWithFormat:@"%d", [self.dataProcessor numberOfSolves]]];
    [self.stats removeAllObjects];
    RubiksTimerOneStat *numOfSolves = [[RubiksTimerOneStat alloc] init];
    numOfSolves.statType = @"Number of solves: ";
    numOfSolves.statValue = [self.dataProcessor displayNumberOfSolves];
    [self.stats addObject:numOfSolves];
    
    if (numberOfSolves > 0) {
        RubiksTimerOneStat *bestTime = [[RubiksTimerOneStat alloc] init];
        bestTime.statType = @"Best time: ";
        bestTime.statValue = [[self.dataProcessor bestTimeObj] toString];
        
        RubiksTimerOneStat *worstTime = [[RubiksTimerOneStat alloc] init];
        worstTime.statType = @"Worst time: ";
        worstTime.statValue = [[self.dataProcessor worstTimeObj] toString];
        
        RubiksTimerOneStat *sessionAvg = [[RubiksTimerOneStat alloc] init];
        sessionAvg.statType = @"Session Average: ";
        sessionAvg.statValue = [[self.dataProcessor sessionAvgTimeObj] toString];
        
        RubiksTimerOneStat *sessionMean = [[RubiksTimerOneStat alloc] init];
        sessionMean.statType = @"Session Mean: ";
        sessionMean.statValue = [[self.dataProcessor sessionMeanTimeObj] toString];
        
        if (numberOfSolves < 5) {
            [self.stats addObject:bestTime];
            [self.stats addObject:worstTime];
            [self.stats addObject:sessionAvg];
            [self.stats addObject:sessionMean];
        } else if (numberOfSolves < 12) {
            RubiksTimerOneStat *current5 = [[RubiksTimerOneStat alloc] init];
            current5.statType = @"Current average of 5: ";
            current5.statValue = [[self.dataProcessor currentAvgTimeObjOf:5] toString];
            
            RubiksTimerOneStat *best5 = [[RubiksTimerOneStat alloc] init];
            best5.statType = @"Best average of 5: ";
            best5.statValue = [[self.dataProcessor bestAvgTimeObjOf:5] toString];
            
            [self.stats addObject:bestTime];
            [self.stats addObject:worstTime];
            [self.stats addObject:current5];
            [self.stats addObject:best5];
            [self.stats addObject:sessionAvg];
            [self.stats addObject:sessionMean];
        } else if (numberOfSolves < 100) {
            RubiksTimerOneStat *current5 = [[RubiksTimerOneStat alloc] init];
            current5.statType = @"Current average of 5: ";
            current5.statValue = [[self.dataProcessor currentAvgTimeObjOf:5] toString];
            
            RubiksTimerOneStat *best5 = [[RubiksTimerOneStat alloc] init];
            best5.statType = @"Best average of 5: ";
            best5.statValue = [[self.dataProcessor bestAvgTimeObjOf:5] toString];

            RubiksTimerOneStat *current12 = [[RubiksTimerOneStat alloc] init];
            current12.statType = @"Current average of 12: ";
            current12.statValue = [[self.dataProcessor currentAvgTimeObjOf:12] toString];

            RubiksTimerOneStat *best12 = [[RubiksTimerOneStat alloc] init];
            best12.statType = @"Best average of 12: ";
            best12.statValue = [[self.dataProcessor bestAvgTimeObjOf:12] toString];
            [self.stats addObject:bestTime];
            [self.stats addObject:worstTime];
            [self.stats addObject:current5];
            [self.stats addObject:best5];
            [self.stats addObject:current12];
            [self.stats addObject:best12];
            [self.stats addObject:sessionAvg];
            [self.stats addObject:sessionMean];
        } else {
            RubiksTimerOneStat *current5 = [[RubiksTimerOneStat alloc] init];
            current5.statType = @"Current average of 5: ";
            current5.statValue = [[self.dataProcessor currentAvgTimeObjOf:5] toString];
            
            RubiksTimerOneStat *best5 = [[RubiksTimerOneStat alloc] init];
            best5.statType = @"Best average of 5: ";
            best5.statValue = [[self.dataProcessor bestAvgTimeObjOf:5] toString];
            
            RubiksTimerOneStat *current12 = [[RubiksTimerOneStat alloc] init];
            current12.statType = @"Current average of 12: ";
            current12.statValue = [[self.dataProcessor currentAvgTimeObjOf:12] toString];
            
            RubiksTimerOneStat *best12 = [[RubiksTimerOneStat alloc] init];
            best12.statType = @"Best average of 12: ";
            best12.statValue = [[self.dataProcessor bestAvgTimeObjOf:12] toString];
            
            RubiksTimerOneStat *current100 = [[RubiksTimerOneStat alloc] init];
            current100.statType = @"Current average of 100: ";
            current100.statValue = [[self.dataProcessor currentAvgTimeObjOf:100] toString];

            RubiksTimerOneStat *best100 = [[RubiksTimerOneStat alloc] init];
            best100.statType = @"Best average of 100: ";
            best100.statValue = [[self.dataProcessor bestAvgTimeObjOf:100] toString];
            [self.stats addObject:bestTime];
            [self.stats addObject:worstTime];
            [self.stats addObject:current5];
            [self.stats addObject:best5];
            [self.stats addObject:current12];
            [self.stats addObject:best12];
            [self.stats addObject:current100];
            [self.stats addObject:best100];
            [self.stats addObject:sessionAvg];
            [self.stats addObject:sessionMean];
        }
    }
    
}

- (void) displayActionSheet {
    [self performSelector:@selector(getScreenShot) withObject:nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) { 
        if (shareSheet.visible) {  
            [shareSheet dismissWithClickedButtonIndex:-1 animated:YES];  
        } else {
            if ([NSLocalizedString(@"language", NULL) isEqualToString:@"Chinese"]) {
                shareSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Share", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", NULL) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"新浪微博", NULL),NSLocalizedString(@"renren",NULL), @"Facebook", @"Twitter", NSLocalizedString(@"Copy to Pasteboard",NULL), nil];
            } else {
                shareSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Share", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", NULL) destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", NSLocalizedString(@"新浪微博", NULL),NSLocalizedString(@"renren",NULL), NSLocalizedString(@"Copy to Pasteboard",NULL), nil];
            }
            [shareSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
            [shareSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
        }
    } else {
        if ([NSLocalizedString(@"language", NULL) isEqualToString:@"Chinese"]) {
            shareSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Share", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", NULL) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"新浪微博", NULL), NSLocalizedString(@"renren",NULL), @"Facebook", @"Twitter", NSLocalizedString(@"Copy to Pasteboard",NULL), nil];
        } else {
            shareSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Share", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", NULL) destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", NSLocalizedString(@"新浪微博", NULL), NSLocalizedString(@"renren",NULL),NSLocalizedString(@"Copy to Pasteboard",NULL), nil];
        }
        [shareSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        [shareSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            if ([NSLocalizedString(@"language", NULL) isEqualToString:@"Chinese"]) {
                [self shareToSina];
            } else {
                [self shareToFB];
            }
            break;
        case 1:
            if ([NSLocalizedString(@"language", NULL) isEqualToString:@"Chinese"]) {
                [self shareToRenren];
            } else {
                [self shareToTwitter];
            }
            break;
        case 2:
            if ([NSLocalizedString(@"language", NULL) isEqualToString:@"Chinese"]) {
                [self shareToFB];
            } else {
                [self shareToSina];
            }
            break;
        case 3:
            if ([NSLocalizedString(@"language", NULL) isEqualToString:@"Chinese"]) {
                [self shareToTwitter];
            } else {
                [self shareToRenren];
            }
            break;
        case 4:
            [self copyToPaste];
            break;
        default:
            break;
    }
}

- (IBAction)shareToRenren {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];    
    if (![renren isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_feed", 
                                nil];
        [renren authorizationWithPermisson:permissions andDelegate:self];
    } else {
        [self renrenDidLogin:renren];
    }
}

- (void)renrenDidLogin:(Renren *)renren {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.renren.accessToken forKey:@"RenrenAccessTokenKey"];
    [defaults setObject:self.renren.expirationDate forKey:@"RenrenExpirationDateKey"];
    NSString *textToShare = @"";
    self.dataProcessor = [RubiksTimerDataProcessing getFromFileByName:self.currentSession];
    int numberOfSolves = self.dataProcessor.numberOfSolves;
    NSString *currentType = self.dataProcessor.CurrentType;
    NSString *scrambleType;
    if ([[currentType substringToIndex:1] isEqualToString:@"3"]) {
        scrambleType = @"三阶魔方";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"2"]) {
        scrambleType = @"二阶魔方";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"4"]) {
        scrambleType = @"四阶魔方";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"5"]) {
        scrambleType = @"五阶魔方";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"6"]) {
        scrambleType = @"六阶魔方";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"7"]) {
        scrambleType = @"七阶魔方";
    } else if ([[currentType substringToIndex:8] isEqualToString:@"Square-1"]) {
        scrambleType = @"SQ1";
    } else if ([[currentType substringToIndex:8] isEqualToString:@"Megaminx"]) {
        scrambleType = @"五魔方";
    } else if ([[currentType substringToIndex:8] isEqualToString:@"Pyraminx"]) {
        scrambleType = @"金字塔";
    } else if ([[currentType substringToIndex:5] isEqualToString:@"Clock"]) {
        scrambleType = @"魔表";
    } else if ([[currentType substringToIndex:5] isEqualToString:@"Skewb"]) {
        scrambleType = @"Skewb";
    } else {
        scrambleType = @"魔方";
    }
    int num = self.dataProcessor.numberOfSolves;
    if (numberOfSolves == 0) {
        textToShare = [NSString stringWithFormat:@"我正在用 ChaoTimer 进行%@测速，你也来试试？", scrambleType];
    } else if (numberOfSolves < 3) {
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        textToShare = [NSString stringWithFormat:@"我刚刚用 ChaoTimer 完成了%d次%@测速，最快单次：%@，你也来试试？", num, scrambleType, best];
    } else if (numberOfSolves < 5) {
        NSString *avg = [[self.dataProcessor sessionAvgTimeObj] toString];
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        textToShare = [NSString stringWithFormat:@"我刚刚用 ChaoTimer 完成了%d次%@测速，平均：%@，最快单次：%@，你也来试试？", num, scrambleType, avg, best];
    } else if (numberOfSolves < 12) {
        NSString *avg = [[self.dataProcessor sessionAvgTimeObj] toString];
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        NSString *best5 = [[self.dataProcessor bestAvgTimeObjOf:5] toString];
        textToShare = [NSString stringWithFormat:@"我刚刚用 ChaoTimer 完成了%d次%@测速，平均：%@，最快单次：%@，最快五次：%@，你也来试试？", num, scrambleType, avg, best, best5];
    } else if (numberOfSolves < 100) {
        NSString *avg = [[self.dataProcessor sessionAvgTimeObj] toString];
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        NSString *best5 = [[self.dataProcessor bestAvgTimeObjOf:5] toString];
        NSString *best12 = [[self.dataProcessor bestAvgTimeObjOf:12] toString];
        textToShare = [NSString stringWithFormat:@"我刚刚用 ChaoTimer 完成了%d次%@测速，平均：%@，最快单次：%@，最快五次：%@，最快12次：%@，你也来试试？", num, scrambleType, avg, best, best5, best12];
    } else {
        NSString *avg = [[self.dataProcessor sessionAvgTimeObj] toString];
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        NSString *best5 = [[self.dataProcessor bestAvgTimeObjOf:5] toString];
        NSString *best12 = [[self.dataProcessor bestAvgTimeObjOf:12] toString];
        NSString *best100 = [[self.dataProcessor bestAvgTimeObjOf:100] toString];
        textToShare = [NSString stringWithFormat:@"我刚刚用 ChaoTimer 完成了%d次%@测速，平均：%@，最快单次：%@，最快五次：%@，最快12次：%@，最快100次：%@，你也来试试？", num, scrambleType, avg, best, best5, best12, best100];
    }

    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"http://itunes.apple.com/us/app/chaotimer/id537516001?ls=1&mt=8", @"url",
                                   @"http://ww3.sinaimg.cn/large/6b6b38c9gw1dupdk9gseaj.jpg", @"image",
                                   textToShare, @"description",
                                   @"ChaoTimer", @"action_name",
                                   @"http://itunes.apple.com/cn/app/chaotimer/id537516001?ls=1&mt=8",@"action_link",
                                   @"我的成绩",@"message",
                                   @"ChaoTimer", @"name",nil];
    NSLog(@"%@", @"login");
    [self.renren dialog:@"feed" andParams:params andDelegate:self];
}


- (IBAction)copyToPaste{
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm a"];
    date = [formatter stringFromDate:[NSDate date]];
    self.dataProcessor = [RubiksTimerDataProcessing getFromFileByName:self.currentSession];
    NSString *currentType = self.dataProcessor.CurrentType;
    NSString *scrambleType;
    if ([[currentType substringToIndex:1] isEqualToString:@"3"]) {
        scrambleType = @"3x3x3";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"2"]) {
        scrambleType = @"2x2x2";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"4"]) {
        scrambleType = @"4x4x4";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"5"]) {
        scrambleType = @"5x5x5";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"6"]) {
        scrambleType = @"6x6x6";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"7"]) {
        scrambleType = @"7x7x7";
    } else if ([[currentType substringToIndex:8] isEqualToString:@"Square-1"]) {
        scrambleType = @"SQ1";
    } else if ([[currentType substringToIndex:8] isEqualToString:@"Megaminx"]) {
        scrambleType = @"Megaminx";
    } else if ([[currentType substringToIndex:8] isEqualToString:@"Pyraminx"]) {
        scrambleType = @"Pyraminx";
    } else if ([[currentType substringToIndex:5] isEqualToString:@"Clock"]) {
        scrambleType = @"Clock";
    } else if ([[currentType substringToIndex:5] isEqualToString:@"Skewb"]) {
        scrambleType = @"Skewb";
    } else {
        scrambleType = @"speedsolving";
    }
    NSString *textToPaste = [[NSLocalizedString(@"Generate by", NULL) stringByAppendingFormat:@"%@\n\n", date] stringByAppendingString:[self.dataProcessor toStringWithIndividualTime:YES]];    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = textToPaste;
    NSLog(@"%@", textToPaste);
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"pasteboard success", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];
    [alertView show];
}

- (IBAction)shareToTwitter {
    NSString *textToShare = @"";
    self.dataProcessor = [RubiksTimerDataProcessing getFromFileByName:self.currentSession];
    int numberOfSolves = self.dataProcessor.numberOfSolves;
    NSString *currentType = self.dataProcessor.CurrentType;
    NSString *scrambleType;
    if ([[currentType substringToIndex:1] isEqualToString:@"3"]) {
        scrambleType = @"3x3x3";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"2"]) {
        scrambleType = @"2x2x2";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"4"]) {
        scrambleType = @"4x4x4";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"5"]) {
        scrambleType = @"5x5x5";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"6"]) {
        scrambleType = @"6x6x6";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"7"]) {
        scrambleType = @"7x7x7";
    } else if ([[currentType substringToIndex:8] isEqualToString:@"Square-1"]) {
        scrambleType = @"SQ1";
    } else if ([[currentType substringToIndex:8] isEqualToString:@"Megaminx"]) {
        scrambleType = @"Megaminx";
    } else if ([[currentType substringToIndex:8] isEqualToString:@"Pyraminx"]) {
        scrambleType = @"Pyraminx";
    } else if ([[currentType substringToIndex:5] isEqualToString:@"Clock"]) {
        scrambleType = @"Clock";
    } else if ([[currentType substringToIndex:5] isEqualToString:@"Skewb"]) {
        scrambleType = @"Skewb";
    } else {
        scrambleType = @"speedcubing";
    }
    int num = self.dataProcessor.numberOfSolves;
    if (numberOfSolves == 0) {
        textToShare = [NSString stringWithFormat:@"I'm using #ChaoTimer for my speedcubing, do you wanna try？"];
    } else if (numberOfSolves == 1) {
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        textToShare = [NSString stringWithFormat:@"%@ solve: %@. via #ChaoTimer", scrambleType, best];
    } else if (numberOfSolves < 3) {
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        textToShare = [NSString stringWithFormat:@" %d times %@, best time: %@. via #ChaoTimer", num, scrambleType, best];
    } else if (numberOfSolves < 5) {
        NSString *avg = [[self.dataProcessor sessionAvgTimeObj] toString];
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        textToShare = [NSString stringWithFormat:@"%d times %@, avg: %@, best time: %@. via #ChaoTimer", num, scrambleType, avg, best];
    } else if (numberOfSolves < 12) {
        NSString *avg = [[self.dataProcessor sessionAvgTimeObj] toString];
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        NSString *best5 = [[self.dataProcessor bestAvgTimeObjOf:5] toString];
        textToShare = [NSString stringWithFormat:@"%d times %@, avg: %@, best: %@, best avg5: %@. via #ChaoTimer", num, scrambleType, avg, best, best5];
    } else if (numberOfSolves < 100) {
        NSString *avg = [[self.dataProcessor sessionAvgTimeObj] toString];
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        NSString *best5 = [[self.dataProcessor bestAvgTimeObjOf:5] toString];
        NSString *best12 = [[self.dataProcessor bestAvgTimeObjOf:12] toString];
        textToShare = [NSString stringWithFormat:@"%d times %@, avg: %@, best: %@, best avg5: %@, best avg12: %@. via #ChaoTimer", num, scrambleType, avg, best, best5, best12];
    } else {
        NSString *avg = [[self.dataProcessor sessionAvgTimeObj] toString];
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        NSString *best5 = [[self.dataProcessor bestAvgTimeObjOf:5] toString];
        NSString *best12 = [[self.dataProcessor bestAvgTimeObjOf:12] toString];
        NSString *best100 = [[self.dataProcessor bestAvgTimeObjOf:100] toString];
        textToShare = [NSString stringWithFormat:@"%d times %@, avg: %@, best: %@, best avg5: %@, best avg12: %@, best avg100: %@. via #ChaoTimer", num, scrambleType, avg, best, best5, best12, best100];
    }
    
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    [twitter setInitialText:textToShare];//optional
    //[twitter addImage:[UIImage imageNamed:@"icon_114.png"]];
    [twitter addURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/chaotimer/id537516001?ls=1&mt=8"]];
    
    if([TWTweetComposeViewController canSendTweet]){
        [self presentViewController:twitter animated:YES completion:nil]; 
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"twitter fail title", NULL) message:NSLocalizedString(@"twitter fail msg", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
        if (res == TWTweetComposeViewControllerResultDone) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"twitter success title", NULL) message:NSLocalizedString(@"twitter success msg", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];
            [alertView show];
        } 
        [self dismissModalViewControllerAnimated:YES];
    };
}

-(IBAction) shareToFB{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"statsViewController" forKey:@"whoStartFBLogin"];
    [defaults synchronize];
    facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
    facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    
    if (![facebook isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream", 
                                nil];
        [facebook authorize:permissions];
    } else {
        [self fbDidLogin];
    }
}

- (void)fbDidLogin {
    NSLog(@"%@", @"did login");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [self postToFB];
    [self.tableView reloadData];
}

- (void)postToFB {
    NSString *textToShare = @"";
    self.dataProcessor = [RubiksTimerDataProcessing getFromFileByName:self.currentSession];
    int numberOfSolves = self.dataProcessor.numberOfSolves;
    NSString *currentType = self.dataProcessor.CurrentType;
    NSString *scrambleType;
    if ([[currentType substringToIndex:1] isEqualToString:@"3"]) {
        scrambleType = @"3x3x3";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"2"]) {
        scrambleType = @"2x2x2";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"4"]) {
        scrambleType = @"4x4x4";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"5"]) {
        scrambleType = @"5x5x5";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"6"]) {
        scrambleType = @"6x6x6";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"7"]) {
        scrambleType = @"7x7x7";
    } else if ([[currentType substringToIndex:8] isEqualToString:@"Square-1"]) {
        scrambleType = @"SQ1";
    } else if ([[currentType substringToIndex:8] isEqualToString:@"Megaminx"]) {
        scrambleType = @"Megaminx";
    } else if ([[currentType substringToIndex:8] isEqualToString:@"Pyraminx"]) {
        scrambleType = @"Pyraminx";
    } else if ([[currentType substringToIndex:5] isEqualToString:@"Clock"]) {
        scrambleType = @"Clock";
    } else if ([[currentType substringToIndex:5] isEqualToString:@"Skewb"]) {
        scrambleType = @"Skewb";
    } else {
        scrambleType = @"speedsolving";
    }
    int num = self.dataProcessor.numberOfSolves;
    if (numberOfSolves == 0) {
        textToShare = [NSString stringWithFormat:@"I'm using ChaoTimer for my speedcubing, do you wanna try？"];
    } else if (numberOfSolves == 1) {
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        textToShare = [NSString stringWithFormat:@"I have just finished %d time %@ solve using ChaoTimer, best time: %@, do you wanna try?", num, scrambleType, best];
    } else if (numberOfSolves < 3) {
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        textToShare = [NSString stringWithFormat:@"I have just finished %d times %@ solves using ChaoTimer, best time: %@, do you wanna try?", num, scrambleType, best];
    } else if (numberOfSolves < 5) {
        NSString *avg = [[self.dataProcessor sessionAvgTimeObj] toString];
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        textToShare = [NSString stringWithFormat:@"I have just finished %d times %@ solves using ChaoTimer, average: %@, best time: %@, do you wanna try?", num, scrambleType, avg, best];
    } else if (numberOfSolves < 12) {
        NSString *avg = [[self.dataProcessor sessionAvgTimeObj] toString];
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        NSString *best5 = [[self.dataProcessor bestAvgTimeObjOf:5] toString];
        textToShare = [NSString stringWithFormat:@"I have just finished %d times %@ solves using ChaoTimer, average: %@, best time: %@, best avg5: %@, do you wanna try?", num, scrambleType, avg, best, best5];
    } else if (numberOfSolves < 100) {
        NSString *avg = [[self.dataProcessor sessionAvgTimeObj] toString];
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        NSString *best5 = [[self.dataProcessor bestAvgTimeObjOf:5] toString];
        NSString *best12 = [[self.dataProcessor bestAvgTimeObjOf:12] toString];
        textToShare = [NSString stringWithFormat:@"I have just finished %d times %@ solves using ChaoTimer, average: %@, best time: %@, best avg5: %@, best avg12: %@, do you wanna try?", num, scrambleType, avg, best, best5, best12];
    } else {
        NSString *avg = [[self.dataProcessor sessionAvgTimeObj] toString];
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        NSString *best5 = [[self.dataProcessor bestAvgTimeObjOf:5] toString];
        NSString *best12 = [[self.dataProcessor bestAvgTimeObjOf:12] toString];
        NSString *best100 = [[self.dataProcessor bestAvgTimeObjOf:100] toString];
        textToShare = [NSString stringWithFormat:@"I have just finished %d times %@ solves using ChaoTimer, average: %@, best time: %@, best avg5: %@, best avg12: %@, best avg100: %@, do you wanna try?", num, scrambleType, avg, best, best5, best12, best100];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"http://itunes.apple.com/cn/app/chaotimer/id537516001?ls=1&mt=8", @"link",
                                   textToShare, @"description",
                                   @"My Solves", @"caption",
                                   @"https://public.bay.livefilestore.com/y1pu-KFyRuVOQmIhpteKupUq7zU8zOWK42ISDTukVt6O8Gw31VshDW0qSjXY5gL-a8xG_95k8MS1XhrdaPPCidjHw/icon_share.png?psid=1", @"picture",
                                   @"ChaoTimer", @"name",nil];
    [facebook dialog:@"feed" andParams:params andDelegate:self];

}

- (void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"%@", @"did not login");
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt {
    NSLog(@"%@", @"stats did extend token");
}


- (void)fbSessionInvalidated{
    NSLog(@"%@", @"session invalidated");
}

- (void) fbDidLogout {
    NSLog(@"%@", @"did logout");
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
    [self.tableView reloadData];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"Successfully logout", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];
    [alertView show];
}


-(IBAction) shareToSina{
    //[weiBoEngine logOut];
    [weiBoEngine logIn];
}
- (void)engineDidLogIn:(WBEngine *)engine {
    NSLog(@"%@", @"didlogin");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:engine.accessToken forKey:@"WeiboAccessTokenKey"];
    [defaults setInteger:engine.expireTime forKey:@"WeiboExpirationDateKey"];
    [self sendWeibo];
}

- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    NSLog(@"%@", @"alreadylogin");
    //[[self.view.subviews objectAtIndex:0] removeFromSuperview];
   [self sendWeibo];
}

- (void) sendWeibo{
    NSString *textToShare = @"";
    self.dataProcessor = [RubiksTimerDataProcessing getFromFileByName:self.currentSession];
    int numberOfSolves = self.dataProcessor.numberOfSolves;
    NSString *currentType = self.dataProcessor.CurrentType;
    NSString *scrambleType;
    if ([[currentType substringToIndex:1] isEqualToString:@"3"]) {
        scrambleType = @"三阶魔方";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"2"]) {
        scrambleType = @"二阶魔方";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"4"]) {
        scrambleType = @"四阶魔方";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"5"]) {
        scrambleType = @"五阶魔方";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"6"]) {
        scrambleType = @"六阶魔方";
    } else if ([[currentType substringToIndex:1] isEqualToString:@"7"]) {
        scrambleType = @"七阶魔方";
    } else if ([[currentType substringToIndex:8] isEqualToString:@"Square-1"]) {
        scrambleType = @"SQ1";
    } else if ([[currentType substringToIndex:8] isEqualToString:@"Megaminx"]) {
        scrambleType = @"五魔方";
    } else if ([[currentType substringToIndex:8] isEqualToString:@"Pyraminx"]) {
        scrambleType = @"金字塔";
    } else if ([[currentType substringToIndex:5] isEqualToString:@"Clock"]) {
        scrambleType = @"魔表";
    } else if ([[currentType substringToIndex:5] isEqualToString:@"Skewb"]) {
        scrambleType = @"Skewb";
    } else {
        scrambleType = @"魔方";
    }
    int num = self.dataProcessor.numberOfSolves;
    if (numberOfSolves == 0) {
        textToShare = [NSString stringWithFormat:@"我正在用#ChaoTimer#进行%@测速，你也来试试？http://t.cn/zWbXPmG", scrambleType];
    } else if (numberOfSolves < 3) {
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        textToShare = [NSString stringWithFormat:@"我刚刚用#ChaoTimer#完成了%d次%@测速，最快单次：%@，你也来试试？http://t.cn/zWbXPmG", num, scrambleType, best];
    } else if (numberOfSolves < 5) {
        NSString *avg = [[self.dataProcessor sessionAvgTimeObj] toString];
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        textToShare = [NSString stringWithFormat:@"我刚刚用#ChaoTimer#完成了%d次%@测速，平均：%@，最快单次：%@，你也来试试？http://t.cn/zWbXPmG", num, scrambleType, avg, best];
    } else if (numberOfSolves < 12) {
        NSString *avg = [[self.dataProcessor sessionAvgTimeObj] toString];
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        NSString *best5 = [[self.dataProcessor bestAvgTimeObjOf:5] toString];
        textToShare = [NSString stringWithFormat:@"我刚刚用#ChaoTimer#完成了%d次%@测速，平均：%@，最快单次：%@，最快五次：%@，你也来试试？http://t.cn/zWbXPmG", num, scrambleType, avg, best, best5];
    } else if (numberOfSolves < 100) {
        NSString *avg = [[self.dataProcessor sessionAvgTimeObj] toString];
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        NSString *best5 = [[self.dataProcessor bestAvgTimeObjOf:5] toString];
        NSString *best12 = [[self.dataProcessor bestAvgTimeObjOf:12] toString];
        textToShare = [NSString stringWithFormat:@"我刚刚用#ChaoTimer#完成了%d次%@测速，平均：%@，最快单次：%@，最快五次：%@，最快12次：%@，你也来试试？http://t.cn/zWbXPmG", num, scrambleType, avg, best, best5, best12];
    } else {
        NSString *avg = [[self.dataProcessor sessionAvgTimeObj] toString];
        NSString *best = [[self.dataProcessor bestTimeObj] toString];
        NSString *best5 = [[self.dataProcessor bestAvgTimeObjOf:5] toString];
        NSString *best12 = [[self.dataProcessor bestAvgTimeObjOf:12] toString];
        NSString *best100 = [[self.dataProcessor bestAvgTimeObjOf:100] toString];
        textToShare = [NSString stringWithFormat:@"我刚刚用#ChaoTimer#完成了%d次%@测速，平均：%@，最快单次：%@，最快五次：%@，最快12次：%@，最快100次：%@，你也来试试？http://t.cn/zWbXPmG", num, scrambleType, avg, best, best5, best12, best100];
    }
    
    //WBSendView *sendView = [[WBSendView alloc] initWithAppKey:sinaAppKey appSecret:sinaAppSecret text:textToShare image:[UIImage imageNamed:@"icon_114.png"]];
    
    RubiksTimerWBSendViewController *sendView = [self.storyboard instantiateViewControllerWithIdentifier:@"wbSend"];
    [sendView setModalPresentationStyle:UIModalPresentationFormSheet];
    [sendView setDelegate:self];
    [sendView setProperties:sinaAppKey appSecret:sinaAppSecret text:textToShare image:snapshot];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:sendView];
    [nav setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:nav animated:YES completion:NULL];
   // WBSendView *sendView = [[WBSendView alloc] initWithAppKey:sinaAppKey appSecret:sinaAppSecret text:textToShare image:snapshot];

    //[sendView show:YES];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    NSLog(@"%@", error);
     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"Fail to login", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];
	[alertView show];
}

- (void)sendViewDidFinishSending:(RubiksTimerWBSendViewController *)view {
    [view hide];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"success share weibo", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];
    [alertView show];
}
- (void)sendView:(RubiksTimerWBSendViewController *)view didFailWithError:(NSError *)error {
    [view hide];
    if (error.code == 100) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"send duplicate", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];
        [alertView show];
    } else {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"fail share", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];
        [alertView show];
    }
    NSLog(@"%@", error);
}

- (void)sendViewNotAuthorized:(RubiksTimerWBSendViewController *)view {
    NSLog(@"%@", @"not autho");
    [view hide];
    [weiBoEngine logOut];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [weiBoEngine logIn]; 
}
- (void)sendViewAuthorizeExpired:(RubiksTimerWBSendViewController *)view {
    NSLog(@"%@", @"autho expire");
    [view hide];
    [weiBoEngine logOut];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [weiBoEngine logIn];
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
    RubiksTimerStatDetailViewController *statDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"statDetail"];
    if ([[[[stats objectAtIndex:indexPath.row] statType] substringToIndex:7] isEqualToString:@"Current"] || [[[[stats objectAtIndex:indexPath.row] statType] substringToIndex:6] isEqualToString:@"Best a"] || [[[[stats objectAtIndex:indexPath.row] statType] substringToIndex:7] isEqualToString:@"Session"]) {
        statDetailViewController.detailType = [[stats objectAtIndex:indexPath.row] statType];
        [self.navigationController pushViewController:statDetailViewController animated:YES];
        [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    } else if ([[[stats objectAtIndex:indexPath.row] statType] isEqualToString:@"Best time: "]) {
        RubiksTimerSolveDetailViewController *solveDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"oneSolveDetail"];
        RubiksTimerTimeObj *aTimeObj = self.dataProcessor.bestTimeObj;
        solveDetailViewController.time = aTimeObj.toString;
        solveDetailViewController.scramble = aTimeObj.scramble;
        solveDetailViewController.type = aTimeObj.type;
        [self.navigationController pushViewController:solveDetailViewController animated:YES];
        [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    } else if ([[[stats objectAtIndex:indexPath.row] statType] isEqualToString:@"Worst time: "]) {
        RubiksTimerSolveDetailViewController *solveDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"oneSolveDetail"];
        RubiksTimerTimeObj *aTimeObj = self.dataProcessor.worstTimeObj;
        solveDetailViewController.time = aTimeObj.toString;
        solveDetailViewController.scramble = aTimeObj.scramble;
        solveDetailViewController.type = aTimeObj.type;
        [self.navigationController pushViewController:solveDetailViewController animated:YES];
        [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    } else {
        [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    }
        
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)presentSessionView
{
    NSLog(@"sads");
    if([self.popoverController isPopoverVisible])
   {
       NSLog(@"oh");
       [self updateStats];
       [self reloadData:YES];
        [self.popoverController dismissPopoverAnimated:YES];
       //[self.popoverController.delegate popoverControllerDidDismissPopover:self.popoverController];
        return;
    }
    RubiksTimerSessionViewController *sessionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sessionManage"];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:sessionViewController];
        self.popoverController.delegate = self;
        //[self.popoverController setValue:[NSNumber numberWithInt:3] forKey:@"popoverBackgroundStyle"];
        //[self.popoverController.contentViewController.view setBackgroundColor:[UIColor colorWithRed:0.1f green:0.5f blue:0.75f alpha:1]];
        
        //[self.popoverController setPopoverContentSize:CGSizeMake(320, 600) animated:YES];
        [self.popoverController presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [sessionViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:sessionViewController animated:YES completion:NULL];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"dismiss");
    [self updateStats];
    [self reloadData:YES];
}

- (void)reloadData:(BOOL)animated
{
    [self.tableView reloadData];
    
    if (animated) {
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionFade];
        //[animation setSubtype:kCATransitionFade];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [animation setFillMode:kCAFillModeBoth];
        [animation setDuration:0.3];
        [[self.tableView layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
        
    }
}

@end

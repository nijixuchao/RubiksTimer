//
//  RubiksTimerStatDetailViewController.m
//  RubiksTimer
//
//  Created by Jichao Li on 5/26/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import "RubiksTimerStatDetailViewController.h"
#import "RubiksTimerOneStat.h"
#import "RubiksTimerDataProcessing.h"
#import "RubiksTimerTimeObj.h"
#import "RubiksTimerStatDetailViewController.h"
#import "RubiksTimerSolveDetailViewController.h"

@interface RubiksTimerStatDetailViewController ()
@property (nonatomic, strong) NSString *currentSession;
@end

@implementation RubiksTimerStatDetailViewController
@synthesize statDetails;
@synthesize detailType;
@synthesize currentSession;
@synthesize dataProcessor = _dataProcessor;

- (RubiksTimerDataProcessing *) dataProcessor {
    if (!_dataProcessor) {
        _dataProcessor = [[RubiksTimerDataProcessing alloc] init];
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
    self.navigationItem.title = NSLocalizedString(@"Detail", NULL);
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
    titleLabel.text = NSLocalizedString(@"Detail", NULL);
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.1f green:0.5f blue:0.75f alpha:1]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:0.2f green:0.6f blue:0.8f alpha:1]];
    
    //self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];	// use the table view background color
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateStatDetail];
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
    
    //return YES;
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
    return [self.statDetails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"statDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    RubiksTimerTimeObj *tempBest = self.statDetails.lastObject;
    RubiksTimerTimeObj *tempWorst = self.statDetails.lastObject;
    for (id aTime in self.statDetails) {
        if (((RubiksTimerTimeObj *)aTime).timeValueAfterPenalty > tempWorst.timeValueAfterPenalty) {
            tempWorst = (RubiksTimerTimeObj *)aTime;
        }  
        if (((RubiksTimerTimeObj *)aTime).timeValueAfterPenalty < tempBest.timeValueAfterPenalty) {
            tempBest = (RubiksTimerTimeObj *)aTime;
        }
    }
    RubiksTimerTimeObj *oneTimeObj = [self.statDetails objectAtIndex:indexPath.row];
    if ([oneTimeObj isEqual:tempBest] || [oneTimeObj isEqual:tempWorst]) {
        cell.textLabel.text = [[@"( " stringByAppendingString:[oneTimeObj toString]] stringByAppendingString:@" )"];
    } else {
        cell.textLabel.text = [oneTimeObj toString];
    }
    cell.detailTextLabel.text = oneTimeObj.scramble;
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    if (indexPath.row % 2 == 1) {
        [cell.backgroundView setBackgroundColor:[UIColor lightGrayColor]];
    }
    // Configure the cell...
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(self.detailType, NULL);
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
        return nil;
    }
    else {
        UIView* myView = [[UIView alloc] init];
        myView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 320, 25)];
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = NSLocalizedString(self.detailType, NULL);
        titleLabel.shadowColor = [UIColor blackColor];
        titleLabel.shadowOffset = CGSizeMake(1, 1);
        
        [myView addSubview:titleLabel];
        return myView;
    }
}
*/
- (void)updateStatDetail{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.currentSession = [defaults stringForKey:@"currentSession"];
    self.dataProcessor = [RubiksTimerDataProcessing getFromFileByName:currentSession];
    [self.statDetails removeAllObjects];
    if ([self.detailType isEqualToString:@"Current average of 5: "]) {
        self.statDetails = [self.dataProcessor anArrayOfTimeObjOfCurrent:5];
    } else if ([self.detailType isEqualToString:@"Current average of 12: "]) {
        self.statDetails = [self.dataProcessor anArrayOfTimeObjOfCurrent:12];
    } else if ([self.detailType isEqualToString:@"Current average of 100: "]) {
        self.statDetails = [self.dataProcessor anArrayOfTimeObjOfCurrent:100];
    } else if ([self.detailType isEqualToString:@"Best average of 5: "]) {
        self.statDetails = [self.dataProcessor anArrayOfTimeObjOfBest:5];
    } else if ([self.detailType isEqualToString:@"Best average of 12: "]) {
        self.statDetails = [self.dataProcessor anArrayOfTimeObjOfBest:12];
    } else if ([self.detailType isEqualToString:@"Best average of 100: "]) {
        self.statDetails = [self.dataProcessor anArrayOfTimeObjOfBest:100];
    } else if ([self.detailType isEqualToString:@"Session Average: "] || [self.detailType isEqualToString:@"Session Mean: "]) {
        self.statDetails = [self.dataProcessor anArrayOfTimeObjOfAllSolves];
    }
   
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        RubiksTimerTimeObj *aTimeObj = [self.statDetails objectAtIndex:indexPath.row];
        [self.dataProcessor removeTimeObj:aTimeObj];
        [self.statDetails removeObjectAtIndex:indexPath.row];
        
        [self.dataProcessor storeIntoFile];
        [[[[[self tabBarController] tabBar] items] objectAtIndex:0] setBadgeValue:[NSString stringWithFormat:@"%d", [self.dataProcessor numberOfSolves]]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [self updateStatDetail];
        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
        //[self.tableView reloadData];
    }   
}


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
    RubiksTimerSolveDetailViewController *solveDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"oneSolveDetail"]; 
    RubiksTimerTimeObj *oneTimeObj = [self.statDetails objectAtIndex:indexPath.row];
    solveDetailViewController.time= [oneTimeObj toString];
    solveDetailViewController.scramble = oneTimeObj.scramble;
    solveDetailViewController.type = oneTimeObj.type;
    [self.navigationController pushViewController:solveDetailViewController animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

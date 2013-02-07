//
//  RubiksTimerHelpViewController.m
//  ChaoTimer
//
//  Created by Jichao Li on 6/29/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import "RubiksTimerHelpViewController.h"

@interface RubiksTimerHelpViewController ()

@end

@implementation RubiksTimerHelpViewController
@synthesize helps = _helps;
@synthesize helpsToDo = _helpsToDo;
@synthesize helpsImage = _helpsImage;
- (NSArray *)helps {
    if (!_helps) {
        _helps = [[NSArray alloc] initWithObjects:NSLocalizedString(@"1fhold", NULL), NSLocalizedString(@"sr", NULL), NSLocalizedString(@"sl", NULL), NSLocalizedString(@"1f2t", NULL), NSLocalizedString(@"2f2t", NULL), NSLocalizedString(@"2fup", NULL), nil];
    }
    return _helps;
}

- (NSArray *)helpsToDo {
    if (!_helpsToDo) {
        _helpsToDo = [[NSArray alloc] initWithObjects:NSLocalizedString(@"1fholdto", NULL), NSLocalizedString(@"srto", NULL), NSLocalizedString(@"slto", NULL), NSLocalizedString(@"1f2tto", NULL), NSLocalizedString(@"2f2tto", NULL), NSLocalizedString(@"2fupto", NULL), nil];
    }
    return _helpsToDo;
}

- (NSArray *)helpsImage {
    if (!_helpsImage) {
        _helpsImage = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"1hold.png"], [UIImage imageNamed:@"1fr.png"], [UIImage imageNamed:@"1fl.png"], [UIImage imageNamed:@"1f2t.png"], [UIImage imageNamed:@"2f2t.png"], [UIImage imageNamed:@"2fup.png"], nil];
    }
    return _helpsImage;
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
    [super viewDidLoad];
    //self.navigationItem.title = NSLocalizedString(@"Gestures Help", NULL);
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
    titleLabel.text = NSLocalizedString(@"Gestures Help", NULL);
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.1f green:0.5f blue:0.75f alpha:1]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:0.2f green:0.6f blue:0.8f alpha:1]];
    
    [self.tableView setScrollEnabled:NO];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return [self.helps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"oneHelp";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self.helpsToDo objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.helps objectAtIndex:indexPath.row];
    cell.imageView.image = [self.helpsImage objectAtIndex:indexPath.row];
    // Configure the cell...
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return  57;
    } else {
        return 75;
    }
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [indexPath row];
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
}

@end

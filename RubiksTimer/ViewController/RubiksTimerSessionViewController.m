//
//  RubiksTimerSessionViewController.m
//  ChaoTimer
//
//  Created by Jichao Li on 11/27/12.
//  Copyright (c) 2012 Jichao Li. All rights reserved.
//

#import "RubiksTimerSessionViewController.h"
#import "RubiksTimerSessionManager.h"
#import "RubiksTimerDataProcessing.h"
#import "RubiksTimerEditSessionViewController.h"

@interface RubiksTimerSessionViewController ()
@property NSMutableArray *buttons;
@end

@implementation RubiksTimerSessionViewController
@synthesize buttons;
@synthesize sessionManager;


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
    self.sessionManager = [RubiksTimerSessionManager getFromFile];
    self.navigationItem.title = NSLocalizedString(@"session", NULL);
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
    titleLabel.text = NSLocalizedString(@"session", NULL);
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.1f green:0.5f blue:0.75f alpha:1]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:0.2f green:0.6f blue:0.8f alpha:1]];
    //[self.navigationController.toolbar setTintColor:[UIColor colorWithRed:0.1f green:0.5f blue:0.75f alpha:1]];
    [[UIToolbar appearance] setTintColor:[UIColor colorWithRed:0.1f green:0.5f blue:0.75f alpha:1]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backToStatsView:)];
    }
    [self.navigationController setToolbarHidden:NO];
    self.buttons = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self.editButtonItem setAction:@selector(editBtnPressed)];
    [self.buttons addObject:self.editButtonItem];
    [self.buttons addObject:flexibleSpace];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"new session", NULL) style:UIBarButtonItemStyleBordered target:self action:@selector(addNewSession:)];
    [self.buttons addObject:newButton];
    [self setToolbarItems:self.buttons animated:NO];
    [self.tableView setAllowsSelectionDuringEditing:YES];
    //self.hidesBottomBarWhenPushed = YES;
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.sessionManager = [RubiksTimerSessionManager getFromFile];
    //[self setEditing:NO animated:NO];
    
    [self.tableView reloadData];
}


- (void)viewWillDisappear:(BOOL)animated {
    [self.sessionManager storeIntoFile];
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [self.sessionManager stickySessionNum];
            break;
        case 1:
            return [self.sessionManager normalSessionNum];
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sessionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case 0: {
            NSString *title = [sessionManager getStickySessionIndexAt:indexPath.row];
            RubiksTimerDataProcessing *dataProcesser = [RubiksTimerSessionManager getCurrentSessionfromName:title];
            int solveNumber = [dataProcesser numberOfSolves];
            NSString *subTitle = [NSLocalizedString(@"Number of solves: ", NULL)stringByAppendingFormat:@"%d", solveNumber];
            if (indexPath.row == 0) {
                cell.textLabel.text = NSLocalizedString(title, NULL);
                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            } else
                cell.textLabel.text = title;
            cell.detailTextLabel.text = subTitle;
            if (indexPath.row == 0) {
                cell.imageView.image = [UIImage imageNamed:@"mainSession.png"];
            } else
                cell.imageView.image = [UIImage imageNamed:@"sticky.png"];
            
            if ([title isEqualToString:self.sessionManager.currentSession]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
        case 1: {
            NSString *title = [sessionManager getNormalSessionIndexAt:indexPath.row];
            RubiksTimerDataProcessing *dataProcesser = [RubiksTimerSessionManager getCurrentSessionfromName:title];
            int solveNumber = [dataProcesser numberOfSolves];
            NSString *subTitle = [NSLocalizedString(@"Number of solves: ", NULL)stringByAppendingFormat:@"%d", solveNumber];
            cell.textLabel.text = title;
            cell.detailTextLabel.text = subTitle;
            cell.imageView.image = [UIImage imageNamed:@"sessions.png"];
            if ([title isEqualToString:self.sessionManager.currentSession]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
        default:
            break;
    }
    // Configure the cell...
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    //[[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    return NO;
                    break;
                default:
                    return YES;
                    break;
            }
        default:
            return YES;
            break;
    }
    // Return NO if you do not want the specified item to be editable.
    //return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSString *deleteSession = @"";
        switch (indexPath.section) {
            case 0: {
                NSString *deleteSession = [self.sessionManager getStickySessionIndexAt:indexPath.row];
                if ([deleteSession isEqualToString:self.sessionManager.currentSession]) {
                    self.sessionManager.currentSession = @"main session";
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"main session" forKey:@"currentSession"];
                    [defaults synchronize];
                }
                [self.sessionManager removeStickySessionAtIndex:indexPath.row];
                break;
            }
            case 1: {
                NSString *deleteSession = [self.sessionManager getNormalSessionIndexAt:indexPath.row];
                if ([deleteSession isEqualToString:self.sessionManager.currentSession]) {
                    self.sessionManager.currentSession = @"main session";
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"main session" forKey:@"currentSession"];
                    [defaults synchronize];
                }
                [self.sessionManager removeNormalSessionAtIndex:indexPath.row];
                break;
            }
            default:
                deleteSession = self.sessionManager.currentSession;
                break;
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.sessionManager storeIntoFile];
        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
        //[self.tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.sessionManager moveObjectFrom:fromIndexPath toIndexPath:toIndexPath];
    //[self.sessionManager moveObjectFromIndex:fromIndexPath.row+1 toIndex:toIndexPath.row+1];
    [self.sessionManager storeIntoFile];
    //[self.tableView reloadData];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if ((sourceIndexPath.section == 0 && sourceIndexPath.row ==0) || (proposedDestinationIndexPath.section == 0 && proposedDestinationIndexPath.row == 0)) {
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return NO;
                    break;
                default:
                    return YES;
                    break;
            }
        default:
            return YES;
            break;
    }
    // Return NO if you do not want the item to be re-orderable.
    //return YES;
}


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
    if (self.tableView.isEditing) {
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setSelectionStyle:UITableViewCellSelectionStyleNone];
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
                        break;
                    default:
                        [self editSession:indexPath];
                        break;
                }
                break;
            default:
                [self editSession:indexPath];
                break;
        }
        
    } else {
        NSString *session = @"main session";
        switch (indexPath.section) {
            case 0:
                session = [self.sessionManager getStickySessionIndexAt:indexPath.row];
                break;
            case 1:
                session = [self.sessionManager getNormalSessionIndexAt:indexPath.row];
                break;
            default:
                break;
        }
        //NSLog(session);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:session forKey:@"currentSession"];
        [defaults synchronize];
        self.sessionManager.currentSession = session;
        [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
        //[self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.tableView reloadData];

    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"stickySessions", NULL);
            break;
        case 1:
            return NSLocalizedString(@"mySessions", NULL);
            break;
        default:
            return @"";
            break;
    }
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

- (IBAction) editBtnPressed
{
    if ([self isEditing])
    {
        [self setEditing:NO animated:YES];
        //[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.6];
    }
    else
    {
        [self setEditing:YES animated:YES];
    }
}

//- (void)setEditing:(BOOL)editing animated:(BOOL)animate
//{
//    [super setEditing:editing animated:animate];
//    if (editButtonPressed == YES) {
//        if(editing)
//        {
//            UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"new session", NULL) style:UIBarButtonItemStyleBordered target:self action:@selector(addNewSession:)];
//            [self.buttons addObject:newButton];
//            [self setToolbarItems:self.buttons animated:NO];
//            [self.navigationController.toolbar setItems:self.buttons animated:YES];
//        }
//        else
//        {
//            [self.buttons removeLastObject];
//            [self.navigationController.toolbar setItems:self.buttons animated:YES];
//            NSLog(@"Done leave editmode");
//            editButtonPressed = NO;
//        }
//        
//    }
//}

- (IBAction)addNewSession:(id)sender {
    //RubiksTimerDataProcessing *newDataProcessor = [RubiksTimerDataProcessing initWithName:sender];
    RubiksTimerEditSessionViewController *newSessionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"editSession"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150,44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    if ( [[UIDevice currentDevice].systemVersion doubleValue] >= 6.0f) {
        titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:22.0f];
    } else {
        titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    }
    [titleLabel setShadowColor:[UIColor darkGrayColor]];
    [titleLabel setShadowOffset:CGSizeMake(0, -1)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"new session", NULL);
    titleLabel.textColor = [UIColor whiteColor];
    newSessionViewController.navigationItem.titleView = titleLabel;
    newSessionViewController.isNew = YES;
    
    [self.navigationController pushViewController:newSessionViewController animated:YES];
    
}

- (void)editSession:(NSIndexPath *)indexPath {
    RubiksTimerEditSessionViewController *newSessionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"editSession"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150,44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    if ( [[UIDevice currentDevice].systemVersion doubleValue] >= 6.0f) {
        titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:22.0f];
    } else {
        titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    }
    [titleLabel setShadowColor:[UIColor darkGrayColor]];
    [titleLabel setShadowOffset:CGSizeMake(0, -1)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"rename session", NULL);
    titleLabel.textColor = [UIColor whiteColor];
    newSessionViewController.navigationItem.titleView = titleLabel;
    newSessionViewController.isNew = NO;
    if (indexPath.section == 0) {
        newSessionViewController.oldSessionName = [self.sessionManager getStickySessionIndexAt:indexPath.row];
    } else 
        newSessionViewController.oldSessionName =[self.sessionManager getNormalSessionIndexAt:indexPath.row];
    [self.navigationController pushViewController:newSessionViewController animated:YES];
    
}

- (IBAction)backToStatsView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

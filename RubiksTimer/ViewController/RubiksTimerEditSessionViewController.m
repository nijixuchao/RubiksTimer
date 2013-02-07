//
//  RubiksTimerEditSessionViewController.m
//  ChaoTimer
//
//  Created by Jichao Li on 12/4/12.
//  Copyright (c) 2012 Jichao Li. All rights reserved.
//

#import "RubiksTimerEditSessionViewController.h"
#import "RubiksTimerSessionManager.h"

@interface RubiksTimerEditSessionViewController ()
@end

@implementation RubiksTimerEditSessionViewController

@synthesize myTextField;
@synthesize isNew;
@synthesize oldSessionName;
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
    [super viewDidLoad];
    //NSLog(oldSessionName);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"view will disappear");
    [myTextField resignFirstResponder];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"editSessionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    [self.view setNeedsDisplay];
    myTextField = [[UITextField alloc]initWithFrame:CGRectMake(20,5,280,36)];
    myTextField.borderStyle = UITextBorderStyleNone;
    myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    myTextField.placeholder =  NSLocalizedString(@"inputSessionName", NULL);
    myTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if ( [[UIDevice currentDevice].systemVersion doubleValue] >= 6.0f) {
        myTextField.font = [UIFont fontWithName:@"Avenir" size:17.0f];
    } else {
        myTextField.font = [UIFont systemFontOfSize:17.0f];
    }
    myTextField.returnKeyType = UIReturnKeyDone;
    if (!isNew) {
        myTextField.text = oldSessionName;
    }
    myTextField.enablesReturnKeyAutomatically = YES;
    myTextField.delegate = self;
    [myTextField becomeFirstResponder];
    
    [cell addSubview:myTextField];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"sessionName", NULL);
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return NSLocalizedString(@"sessionNameDup", NULL);
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"should return");
    if (self.isNew) {
        NSString *newSession = textField.text;
        //NSLog(newSession);
        if([sessionManager hasSession:newSession]) {
            textField.text = @"";
            [textField resignFirstResponder];
            UIAlertView *duplicateName = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dup warning", NULL) message:NSLocalizedString(@"choose another name", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", NULL) otherButtonTitles:nil];
            [duplicateName show];
            return NO;
        } else {
            [self.sessionManager addSesion:newSession];
            [self.sessionManager storeIntoFile];
            [self.navigationController popViewControllerAnimated:YES];
            return YES;
        }
    } else {
        NSString *newSession = textField.text;
        //NSLog(newSession);
        if((![newSession isEqualToString:oldSessionName]) &&[sessionManager hasSession:newSession]) {
            textField.text = oldSessionName;
            [textField resignFirstResponder];
            UIAlertView *duplicateName = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dup warning", NULL) message:NSLocalizedString(@"choose another name", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];
            [duplicateName show];
            //[self.myTextField becomeFirstResponder];
            return NO;
        } else {
            [self.sessionManager renameSession:oldSessionName to:newSession];
            [self.sessionManager storeIntoFile];
            [self.navigationController popViewControllerAnimated:YES];
            return YES;
        }

    }
}

- (void)dismissNamedAlert: (UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}
@end

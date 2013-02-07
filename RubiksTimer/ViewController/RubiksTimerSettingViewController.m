//
//  RubiksTimerSettingViewController.m
//  ChaoTimer
//
//  Created by Jichao Li on 7/10/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import "RubiksTimerSettingViewController.h"

@interface RubiksTimerSettingViewController ()
@property(nonatomic, strong) UILabel *fTime;
@end

@implementation RubiksTimerSettingViewController
@synthesize fTime;

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
    self.navigationItem.title = NSLocalizedString(@"setting", NULL);
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
    titleLabel.text = NSLocalizedString(@"setting", NULL);
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.1f green:0.5f blue:0.75f alpha:1]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:0.2f green:0.6f blue:0.8f alpha:1]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        fTime = [[UILabel alloc]initWithFrame:CGRectMake(55, 28, 200, 15)];
    } else {
        fTime = [[UILabel alloc]initWithFrame:CGRectMake(22, 28, 200, 15)];
    }
    
    fTime.font = [UIFont fontWithName:@"Avenir" size:14.0f];
    fTime.backgroundColor = [UIColor clearColor];
    fTime.textColor = [UIColor grayColor];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int time = [defaults integerForKey:@"freezeTime"];
    fTime.text = [NSString stringWithFormat:@"%0.1f s", (double)time*0.01];
    if ([fTime.text isEqualToString:@"0.0 s"]) {
        fTime.text = [fTime.text stringByAppendingString:NSLocalizedString(@"no other gesture", NULL)];
    }
    /*if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        UIImage *backButton = [UIImage imageNamed:@"backButton.png"];
        UIBarButtonItem *barButtomItem = [[UIBarButtonItem alloc]init];
        [barButtomItem setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.backBarButtonItem = barButtomItem;
    }*/
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //[super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:17.0f];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir" size:14.0f];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0: 
                {
                    cell.textLabel.text = NSLocalizedString(@"wca inspection", NULL);
                    cell.detailTextLabel.text = NSLocalizedString(@"15 sec", NULL);
                    UISwitch *wcaInsSwitch = [[UISwitch alloc] init];
                    [wcaInsSwitch setTag:1];
                    [wcaInsSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                    if ([defaults boolForKey:@"wcaInspection"] == YES) {
                        [wcaInsSwitch setOn:YES];
                    }
                    else {
                        [wcaInsSwitch setOn:NO];
                    }
                    cell.accessoryView = wcaInsSwitch;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                    
                case 1:
                {
                    cell.textLabel.text = NSLocalizedString(@"start freeze", NULL);
                    UISlider *freezeTime = [[UISlider alloc] init];
                    freezeTime.minimumValue = 0;
                    freezeTime.maximumValue = 100;
                    [freezeTime addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    int time = [defaults integerForKey:@"freezeTime"];
                    freezeTime.value = time;
                    //freezeTime set
                    //[cell.detailTextLabel addSubview:fTime];
                    [cell addSubview:fTime];
                    cell.accessoryView = freezeTime;
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                /*{
                    cell.textLabel.text = NSLocalizedString(@"two hands start", NULL);
                    UISwitch *twoHandsSwitch = [[UISwitch alloc] init];
                    [twoHandsSwitch setTag:2];
                    [twoHandsSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                    if ([defaults boolForKey:@"twoHandsStart"] == YES) {
                        [twoHandsSwitch setOn:YES];
                    }
                    else {
                        [twoHandsSwitch setOn:NO];
                    }
                    cell.accessoryView = twoHandsSwitch;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }*/
                     
                    
                default:
                    break;
            }
            break;
        /*
        case 1:
            switch ([indexPath indexAtPosition:1]) {
                case 0:
                {
                    cell.textLabel.text = NSLocalizedString(@"theme", NULL);
                    UISegmentedControl *themeControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[UIImage imageNamed:@"blue.png"], [UIImage imageNamed:@"red.png"], [UIImage imageNamed:@"green.png"], [UIImage imageNamed:@"black.png"], nil]];
                    [themeControl setFrame:CGRectMake(0.0f, 0.0f, 150.0f, 30.0f)];
                    cell.accessoryView = themeControl;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
            }*/
        default:
            break;
    }

    
    // Configure the cell...
    return cell;
}

- (IBAction)sliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int progressAsInt = (int)roundf(slider.value);
    fTime.text = [NSString stringWithFormat:@"%0.1f s", (double)progressAsInt*0.01];
    if ([fTime.text isEqualToString:@"0.0 s"]) {
        fTime.text = [fTime.text stringByAppendingString:NSLocalizedString(@"no other gesture", NULL)];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:progressAsInt forKey:@"freezeTime"];
}

- (IBAction)switchAction:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender; 
    BOOL isButtonOn = [switchButton isOn]; 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch (switchButton.tag) {
        case 1:
            if (isButtonOn) {  
                [defaults setBool:YES forKey:@"wcaInspection"];
                NSLog(@"%@",@"on");
            }else {  
                [defaults setBool:NO forKey:@"wcaInspection"];
                NSLog(@"%@",@"off");
            }  
            break;
        case 2:
            if (isButtonOn) {
                [defaults setBool:YES forKey:@"twoHandsStart"];
            } else {
                [defaults setBool:NO forKey:@"twoHandsStart"];
            }
            break;
        default:
            break;
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

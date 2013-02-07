//
//  RubiksTimerSolveDetailViewController.m
//  RubiksTimer
//
//  Created by Jichao Li on 5/28/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import "RubiksTimerSolveDetailViewController.h"

@interface RubiksTimerSolveDetailViewController ()

@end

@implementation RubiksTimerSolveDetailViewController
@synthesize displayTime;
@synthesize displayScramble;
@synthesize time, scramble;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.displayTime.text = self.time;
    self.displayScramble.text = self.scramble;
    if ([[self.type substringToIndex:3] isEqualToString:@"2x2"]) {
        self.displayType.text = @"2x2x2";
    } else if ([[self.type substringToIndex:3] isEqualToString:@"3x3"]) {
        self.displayType.text = @"3x3x3";
    } else if ([[self.type substringToIndex:3] isEqualToString:@"4x4"]) {
        self.displayType.text = @"4x4x4";
    } else if ([[self.type substringToIndex:3] isEqualToString:@"5x5"]) {
        self.displayType.text = @"5x5x5";
    } else if ([[self.type substringToIndex:3] isEqualToString:@"6x6"]) {
        self.displayType.text = @"6x6x6";
    } else if ([[self.type substringToIndex:3] isEqualToString:@"7x7"]) {
        self.displayType.text = @"7x7x7";
    } else if ([self.type isEqualToString:@"MegaminxPochmann"]) {
        self.displayType.text = @"Megaminx";
    } else if ([[self.type substringToIndex:8] isEqualToString:@"Square-1"]) {
        self.displayType.text = @"Square-1";
    } else if ([[self.type substringToIndex:5] isEqualToString:@"Clock"]) {
        self.displayType.text = @"Clock";
    } else if ([self.type isEqualToString:@"Pyraminxrandom state"]) {
        self.displayType.text = @"Pyraminx";
    } else if ([self.type isEqualToString:@"Skewb<U,L,R,B>"]) {
        self.displayType.text = @"Skewb";
    } else {
        self.displayType.text = @"";
    }

    self.navigationItem.title = NSLocalizedString(@"scramble", NULL);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    if ( [[UIDevice currentDevice].systemVersion doubleValue] >= 6.0f) {
        titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:22.0f];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self.displayTime setFont:[UIFont fontWithName:@"Avenir-Heavy" size:30.0f]];
            [self.displayType setFont:[UIFont fontWithName:@"Avenir" size:20.0f]];
            [self.displayScramble setFont:[UIFont fontWithName:@"Avenir" size:18.0f]];
            if ([self.type isEqualToString:@"MegaminxPochmann"] || [[self.type substringToIndex:3] isEqualToString:@"7x7"]) {
                [self.displayScramble setFont:[UIFont fontWithName:@"Avenir" size:12.0f]];
            } else if([[self.type substringToIndex:3] isEqualToString:@"6x6"]) {
                [self.displayScramble setFont:[UIFont fontWithName:@"Avenir" size:14.0f]];
            } else if([[self.type substringToIndex:3] isEqualToString:@"5x5"]) {
                [self.displayScramble setFont:[UIFont fontWithName:@"Avenir" size:16.0f]];
            }
        } else {
            [self.displayTime setFont:[UIFont fontWithName:@"Avenir-Heavy" size:40.0f]];
            [self.displayType setFont:[UIFont fontWithName:@"Avenir" size:30.0f]];
            [self.displayScramble setFont:[UIFont fontWithName:@"Avenir" size:24.0f]];
        }
    } else {
        titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self.displayTime setFont:[UIFont boldSystemFontOfSize:30.0f]];
            [self.displayType setFont:[UIFont systemFontOfSize:20.0f]];
            [self.displayScramble setFont:[UIFont systemFontOfSize:18.0f]];
            if ([self.type isEqualToString:@"MegaminxPochmann"] || [[self.type substringToIndex:3] isEqualToString:@"7x7"]) {
                [self.displayScramble setFont:[UIFont systemFontOfSize:12.0f]];
            } else if([[self.type substringToIndex:3] isEqualToString:@"6x6"]){
                [self.displayScramble setFont:[UIFont systemFontOfSize:14.0f]];
            } else if([[self.type substringToIndex:3] isEqualToString:@"5x5"]) {
                [self.displayScramble setFont:[UIFont systemFontOfSize:16.0f]];
            }
        } else {
            [self.displayTime setFont:[UIFont boldSystemFontOfSize:40.0f]];
            [self.displayType setFont:[UIFont systemFontOfSize:30.0f]];
            [self.displayScramble setFont:[UIFont systemFontOfSize:24.0f]];

        }
    }
    [titleLabel setShadowColor:[UIColor darkGrayColor]];
    [titleLabel setShadowOffset:CGSizeMake(0, -1)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"scramble", NULL);
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.1f green:0.5f blue:0.75f alpha:1]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:0.2f green:0.6f blue:0.8f alpha:1]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(displayActionSheet)];
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setDisplayTime:nil];
    [self setDisplayScramble:nil];
    [self setDisplayType:nil];
    [self setDisplayType:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) displayActionSheet {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (shareSheet.visible) {
            [shareSheet dismissWithClickedButtonIndex:-1 animated:YES];
        } else {
            shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", NULL) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"copy scramble", NULL), nil];
            [shareSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
            [shareSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
        }
    } else {
        shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", NULL) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"copy scramble", NULL), nil];
        [shareSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        [shareSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self copyToPaste];
            break;
        default:
            break;
    }
}

- (IBAction)copyToPaste {
    NSString *textToPaste = self.scramble;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = textToPaste;
    NSLog(@"%@", textToPaste);
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"copy scramble success", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];
    [alertView show];

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

@end

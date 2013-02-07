//
//  RubiksTimerImageDisplayViewController.m
//  ChaoTimer
//
//  Created by Jichao Li on 1/31/13.
//  Copyright (c) 2013 Jichao Li. All rights reserved.
//

#import "RubiksTimerImageDisplayViewController.h"
#import "UIViewController+MJPopupViewController.h"

@interface RubiksTimerImageDisplayViewController ()

@end

@implementation RubiksTimerImageDisplayViewController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

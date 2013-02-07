//
//  RubiksTimerFirstViewController.h
//  RubiksTimer
//
//  Created by Jichao Li on 5/21/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RubiksTimerFirstViewController : UIViewController <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timerDisplay;
@property (weak, nonatomic) IBOutlet UILabel *scrambleDisplay;
@property NSTimer *myTimer;
@property NSTimer *inspectionTimer;
@property NSTimer *inspectionOverTimeTimer;

- (void)alertView:(UIAlertView *)uiAlertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

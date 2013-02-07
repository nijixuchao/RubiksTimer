//
//  RubiksTimerFirstViewController.m
//  RubiksTimer
//
//  Created by Jichao Li on 5/21/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import "RubiksTimerFirstViewController.h"
#import "RubiksTimerDataProcessing.h"
#import <mach/mach_time.h>
#import "RubiksTimerCustomPickerView.h"
#import "Scrambler.h"
#import "QuartzCore/QuartzCore.h"
#import "RubiksTimerSessionManager.h"
#import "UIViewController+MJPopupViewController.h"
#import "RubiksTimerImageDisplayViewController.h"
#import "RubiksTimerWBSendViewController.h"

@interface RubiksTimerFirstViewController ()
@property (nonatomic) int timerStatus;
@property (nonatomic) int time;
@property (nonatomic) long long timeWhenTimerStart;
@property (nonatomic, strong) RubiksTimerDataProcessing *dataProcessor;
@property (nonatomic, strong) Scrambler *scrambler;
@property (nonatomic, strong) NSString *thisScramble;
@property (nonatomic, strong) NSString *nextScramble;
@property (nonatomic, strong) RubiksTimerCustomPickerView *alert;
@property (nonatomic, strong) NSString *scrambleType;
@property (nonatomic, strong) NSString *currentSession;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@end

@implementation RubiksTimerFirstViewController
@synthesize timerDisplay;
@synthesize scrambleDisplay;
@synthesize timerStatus; // 0:not touch; 1:touch but not ready; 2:ready but not timing; 3: timing; 5:inspection
@synthesize myTimer;
@synthesize inspectionTimer;
@synthesize inspectionOverTimeTimer;
@synthesize time;
@synthesize timeWhenTimerStart;
@synthesize dataProcessor = _dataProcessor;
@synthesize scrambler = _scrambler;
@synthesize thisScramble = _thisScramble;
@synthesize nextScramble = _nextScramble;
@synthesize alert = _alert;
@synthesize scrambleType = _scrambleType;
@synthesize currentSession = _currentSession;
@synthesize longPressGesture;
//@synthesize spinner = _spinner;

BOOL wcaInspection;
BOOL inspectionBegin = NO;
//BOOL ifFirstStartRand333;
BOOL ifPlus2 = NO;
int solvedTimes;
NSString *oldSession;

- (RubiksTimerDataProcessing *) dataProcessor {
    if (!_dataProcessor) {
        _dataProcessor = [RubiksTimerDataProcessing initWithName:self.currentSession];
    }
    return _dataProcessor;
}

- (Scrambler *) scrambler {
    if (!_scrambler) {
        _scrambler = [[Scrambler alloc] init];
    }
    return _scrambler;
}

- (RubiksTimerCustomPickerView *) alert {
    if (!_alert) {
        _alert = [[RubiksTimerCustomPickerView alloc]
                  initWithTitle:NSLocalizedString(@"scramble type", NULL)
                  message:nil
                  delegate:self
                  cancelButtonTitle:NSLocalizedString(@"cancel", NULL)
                  otherButtonTitles:NSLocalizedString(@"done", NULL), nil];
    }
    return _alert;
}

- (void)viewDidLoad
{
    UIApplication *myApp = [UIApplication sharedApplication];
    [myApp setIdleTimerDisabled:YES];
    [myApp setStatusBarHidden:NO withAnimation:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    wcaInspection = [defaults boolForKey:@"wcaInspection"];
    solvedTimes = [defaults integerForKey:@"solvedTimes"];
    self.currentSession = [defaults stringForKey:@"currentSession"];
    //[defaults setBool:NO forKey:@"ifRated"];
    NSLog(@"%d", solvedTimes);
    //NSLog(self.currentSession);
    [[[[[self tabBarController] tabBar] items] objectAtIndex:0] setTitle:NSLocalizedString(@"Timing", NULL)];
    [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setTitle:NSLocalizedString(@"Stats", NULL)];
    [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setTitle:NSLocalizedString(@"Help", NULL)];
    [[[[[self tabBarController] tabBar] items] objectAtIndex:3] setTitle:NSLocalizedString(@"More", NULL)];
    
    if ( [[UIDevice currentDevice].systemVersion doubleValue] >= 6.0f) {
        [[[[[self tabBarController] tabBar] items] objectAtIndex:0] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir-Heavy" size:10.0f], UITextAttributeFont, nil] forState:UIControlStateNormal];
        [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir-Heavy" size:10.0f], UITextAttributeFont, nil] forState:UIControlStateNormal];
        [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir-Heavy" size:10.0f], UITextAttributeFont, nil] forState:UIControlStateNormal];
        [[[[[self tabBarController] tabBar] items] objectAtIndex:3] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir-Heavy" size:10.0f], UITextAttributeFont, nil] forState:UIControlStateNormal];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            //[self.timerDisplay setFont:[UIFont fontWithName:@"Avenir" size:80.0f]];
            UIImage *tabImage = [UIImage imageNamed:@"tabBar.png"];
            [self.tabBarController.tabBar setBackgroundImage:tabImage];
        } else {
            //[self.timerDisplay setFont:[UIFont fontWithName:@"Avenir" size:170.0f]];
        }
    } else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self.timerDisplay setFont:[UIFont boldSystemFontOfSize:80.0f]];
            UIImage *tabImage = [UIImage imageNamed:@"tabBar.png"];
            [self.tabBarController.tabBar setBackgroundImage:tabImage];
        } else {
            [self.timerDisplay setFont:[UIFont boldSystemFontOfSize:170.0f]];
        }
    }
    self.scrambleType = @"3x3random state";
    if (self.dataProcessor.CurrentType != nil) {
        self.scrambleType = self.dataProcessor.CurrentType;
    }
    [self setScrambleDisplayFont];
    //[self.scrambleDisplay setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    //self.scrambleDisplay.adjustsFontSizeToFitWidth = YES;
    //self.thisScramble = [self.scrambler generateScrambleString:self.scrambleType];
    //self.scrambleDisplay.text = self.thisScramble;
    NSLog(@"this: %@", self.thisScramble);
    //self.nextScramble = self.thisScramble;
    //[self performSelector:@selector(generateNextScramble) withObject:nil afterDelay:1];
    
    int freezeTime;
    if ([defaults objectForKey:@"freezeTime"] != nil) {
        freezeTime = [defaults integerForKey:@"freezeTime"];
        NSLog(@"has freezetime");
    } else {
        freezeTime = 50;
        [defaults setInteger:50 forKey:@"freezeTime"];
        NSLog(@"freezeTime: %d", freezeTime);
    }
    longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startTimer:)];
    [longPressGesture setMinimumPressDuration:freezeTime*0.01];
    [longPressGesture setAllowableMovement:50];
    [self.view addGestureRecognizer:longPressGesture];
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(deleteLastSolve:)];
    [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeGestureLeft requireGestureRecognizerToFail:longPressGesture];
    [self.view addGestureRecognizer:swipeGestureLeft];
    
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(getNewScramble:)];
    [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeGestureRight requireGestureRecognizerToFail:longPressGesture];
    [self.view addGestureRecognizer:swipeGestureRight];
    
    //UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(displayScrambleImage:)];
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(resetTimerStatus:)];
    [swipeGestureUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeGestureUp requireGestureRecognizerToFail:longPressGesture];
    [self.view addGestureRecognizer:swipeGestureUp];
    
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(resetTimerStatus:)];
    [swipeGestureDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [swipeGestureDown requireGestureRecognizerToFail:longPressGesture];
    [self.view addGestureRecognizer:swipeGestureDown];
    
    UITapGestureRecognizer *singleFingerDoubleTaps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPenalty:)];
    [singleFingerDoubleTaps setNumberOfTapsRequired:2];
    [singleFingerDoubleTaps setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleFingerDoubleTaps];
    
    UITapGestureRecognizer *twoFingersDoubleTaps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearTimer:)];
    [twoFingersDoubleTaps setNumberOfTapsRequired:2];
    [twoFingersDoubleTaps setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:twoFingersDoubleTaps];
    
    UISwipeGestureRecognizer *twoFingersSwipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(chooseScrambleType:)];
    [twoFingersSwipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [twoFingersSwipeUp setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:twoFingersSwipeUp];
    
    timerStatus = 0;
    [self performSelector:@selector(getScrType) withObject:nil afterDelay:0.1];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (void) getScrType {
    self.dataProcessor.CurrentType = self.scrambleType;
    NSLog(@"%@", self.dataProcessor.CurrentType);
}

- (void)viewDidUnload
{
    [self setTimerDisplay:nil];
    [self.dataProcessor storeIntoFile];
    [self setScrambleDisplay:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int freezeTime;
    if ([defaults objectForKey:@"freezeTime"] != nil) {
        freezeTime = [defaults integerForKey:@"freezeTime"];
        NSLog(@"has freezetime");
    } else {
        freezeTime = 50;
        [defaults setInteger:50 forKey:@"freezeTime"];
        NSLog(@"freezeTime: %d", freezeTime);
    }
    [longPressGesture setMinimumPressDuration:freezeTime*0.01];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    wcaInspection = [defaults boolForKey:@"wcaInspection"];
    solvedTimes = [defaults integerForKey:@"solvedTimes"];
    self.currentSession = [defaults stringForKey:@"currentSession"];
    //NSLog(self.currentSession);
    if (self.currentSession == nil) {
        //first time update
        self.currentSession = @"main session";
        oldSession = self.currentSession;
        [defaults setObject:self.currentSession forKey:@"currentSession"];
        [defaults synchronize];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *fileName = [[path objectAtIndex:0] stringByAppendingPathComponent:@"timeLog"];
        NSLog(@"Get path: %@",fileName);
        NSData *data = [[NSData alloc] initWithContentsOfFile:fileName];
        if (data) {
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            self.dataProcessor = [unarchiver decodeObjectForKey:@"timeProcessingObj"];
            [unarchiver finishDecoding];
            self.dataProcessor.sessionName = @"main session";
            [self.dataProcessor storeIntoFile];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:fileName error:nil];
        }
        self.thisScramble = [self.scrambler generateScrambleString:self.scrambleType];
        self.scrambleDisplay.text = self.thisScramble;
        NSLog(@"this: %@", self.thisScramble);
        self.nextScramble = self.thisScramble;
        [self performSelector:@selector(generateNextScramble) withObject:nil afterDelay:1];
    } else {
        self.dataProcessor = [RubiksTimerSessionManager getCurrentSessionfromName:self.currentSession];
        self.dataProcessor.sessionName = self.currentSession;
        if (![oldSession isEqualToString:self.currentSession]) {
            self.timerDisplay.text = @"Ready";
            oldSession = self.currentSession;
            self.scrambleType = self.dataProcessor.CurrentType;
            //[self.scrambleDisplay setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
            //self.scrambleDisplay.adjustsFontSizeToFitWidth = YES;
            self.thisScramble = [self.scrambler generateScrambleString:self.scrambleType];
            self.scrambleDisplay.text = self.thisScramble;
            NSLog(@"this: %@", self.thisScramble);
            self.nextScramble = self.thisScramble;
            [self performSelector:@selector(generateNextScramble) withObject:nil afterDelay:1];
        }
    }
    [self setScrambleDisplayFont];
    self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", self.dataProcessor.numberOfSolves];
    
    
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    if (![oldSession isEqualToString:[defaults stringForKey:@"currentSession"]]) {
    //        self.timerDisplay.text = @"Ready";
    //    }
    //    [self setScrambleDisplayFont];
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [self.dataProcessor storeIntoFile];
    [self performSelector:@selector(stopTimer)];
    [super viewWillDisappear:animated];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch begin.");
    [super touchesBegan:touches withEvent:event];
    if  (self.timerStatus == 0) {
        self.timerDisplay.textColor = [UIColor redColor];
        self.timerStatus = 1;
    } else if(self.timerStatus == 3){
        [self performSelector:@selector(stopTimer)];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.timerStatus == 1) {
        self.timerStatus = 0;
        self.timerDisplay.textColor = [UIColor whiteColor];
    }
}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touch move.");
//    [super touchesMoved:touches withEvent:event];
//    if (self.timerStatus == 1) {
//        self.timerDisplay.textColor = [UIColor whiteColor];
//        self.timerStatus = 0;
//    }
//}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch cancel.");
    [super touchesBegan:touches withEvent:event];
    if  (self.timerStatus == 1) {
        self.timerDisplay.textColor = [UIColor whiteColor];
        self.timerStatus = 0;
    }
    
}

- (IBAction)resetTimerStatus:(id)sender {
    NSLog(@"reset!");
    if  (!wcaInspection && timerStatus != 3) {
        self.timerDisplay.textColor = [UIColor whiteColor];
        self.timerStatus = 0;
    }
}

- (IBAction)getNewScramble:(id)sender {
    if (self.timerStatus != 3 && self.timerStatus != 5) {
        self.thisScramble = self.nextScramble;
        //self.thisScramble = [self.scrambler generateScrambleString:self.scrambleType];
        self.scrambleDisplay.text = self.thisScramble;
        NSLog(@"this: %@", self.thisScramble);
        [self performSelector:@selector(generateNextScramble) withObject:nil afterDelay:0.1];
    }
}

- (void)updateTime {
    long long timeNow = mach_absolute_time();
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    self.time = (timeNow - self.timeWhenTimerStart) * info.numer / info.denom / 1000000;
    //NSLog ([NSString stringWithFormat:@"%d\n", self.time]);
    NSString *timeToDisplay = [RubiksTimerDataProcessing convertTimeFromMsecondToString:self.time];
    self.timerDisplay.text = timeToDisplay;
}

- (void)updateInspectionOverTimeTimer {
    if ([self.timerDisplay.text isEqualToString:@"1"]) {
        self.timerDisplay.text = @"+2";
        ifPlus2 = YES;
        return;
    }
    if ([self.timerDisplay.text isEqualToString:@"+2"]) {
        ifPlus2 = NO;
        self.timerDisplay.text = @"DNF";
        [self.inspectionOverTimeTimer invalidate];
        self.timerStatus = 0;
        inspectionBegin = NO;
        [self.dataProcessor addATime:INFINITY withPenalty:2 scramble:self.thisScramble scrambleType:self.scrambleType];
        [self.dataProcessor storeIntoFile];
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", self.dataProcessor.numberOfSolves];
        self.thisScramble = self.nextScramble;
        //self.thisScramble = [self.scrambler generateScrambleString:self.scrambleType];
        NSLog(@"this: %@", self.thisScramble);
        self.scrambleDisplay.text = self.thisScramble;
        [self performSelector:@selector(generateNextScramble) withObject:nil afterDelay:0.1];
    }
}


- (void)updateInspectionTime{
    self.timerDisplay.text = [NSString stringWithFormat:@"%d", ([self.timerDisplay.text intValue] - 1)];
    if ([self.timerDisplay.text isEqualToString:@"1"]) {
        [self.inspectionTimer invalidate];
        self.inspectionOverTimeTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateInspectionOverTimeTimer) userInfo:nil repeats:YES];
    }
}

- (IBAction)startTimer:(UILongPressGestureRecognizer *)sender {
    if (!wcaInspection) {
        if (sender.state == UIGestureRecognizerStateBegan) {
            if (self.timerStatus == 1) {
                self.timerDisplay.textColor = [UIColor greenColor];
                self.timerStatus = 2;
            }
        }
        if (sender.state == UIGestureRecognizerStateCancelled) {
            self.timerDisplay.textColor = [UIColor whiteColor];
            self.timerStatus = 0;
        }
        else if (sender.state == UIGestureRecognizerStateEnded) {
            if (self.timerStatus == 2) {
                self.timerDisplay.textColor = [UIColor whiteColor];
                self.timerDisplay.text = @"0.000";
                self.timeWhenTimerStart = mach_absolute_time();
                self.time = 0;
                self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
                self.timerStatus = 3;
                //[self hideTabBar:YES];
            }
        }
    }
    else {
        if (inspectionBegin) {
            if (sender.state == UIGestureRecognizerStateBegan) {
                if (self.timerStatus == 5) {
                    self.timerDisplay.textColor = [UIColor greenColor];
                    self.timerStatus = 2;
                }
            }
            if (sender.state == UIGestureRecognizerStateCancelled) {
                self.timerDisplay.textColor = [UIColor redColor];
                self.timerStatus = 5;
            }
            else if (sender.state == UIGestureRecognizerStateEnded) {
                if (self.timerStatus == 2) {
                    self.timerDisplay.textColor = [UIColor whiteColor];
                    self.timerDisplay.text = @"0.000";
                    self.timeWhenTimerStart = mach_absolute_time();
                    self.time = 0;
                    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
                    self.timerStatus = 3;
                    inspectionBegin = NO;
                    //[self hideTabBar:YES];
                }
            }
        }
        else {
            if (sender.state == UIGestureRecognizerStateBegan) {
                NSLog(@"start touch began.");
                if (self.timerStatus == 1) {
                    self.timerDisplay.textColor = [UIColor greenColor];
                    self.timerStatus = 2;
                }
            }
            if (sender.state == UIGestureRecognizerStateCancelled) {
                NSLog(@"start touch cancel.");
                self.timerDisplay.textColor = [UIColor whiteColor];
                self.timerStatus = 0;
            }
            else if (sender.state == UIGestureRecognizerStateEnded) {
                NSLog(@"start touch end.");
                if (self.timerStatus == 2) {
                    self.timerDisplay.textColor = [UIColor whiteColor];
                    self.timerDisplay.text = @"15";
                    self.inspectionTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateInspectionTime) userInfo:nil repeats:YES];
                    self.timerStatus = 5;
                    inspectionBegin = YES;
                    //[self hideTabBar:YES];
                }
            }
            
        }
        
    }
}

- (void)stopTimer{
    if (self.timerStatus == 3) {
        [self.myTimer invalidate];
        [self.inspectionTimer invalidate];
        self.timerStatus = 0;
        inspectionBegin = NO;
        if (!ifPlus2) {
            [self.dataProcessor addATime:self.time withPenalty:0 scramble:self.thisScramble scrambleType:self.scrambleType];
        }
        else {
            [self.dataProcessor addATime:self.time withPenalty:1 scramble:self.thisScramble scrambleType:self.scrambleType];
            ifPlus2 = NO;
            self.timerDisplay.text = [self.dataProcessor.lastTime toString];
        }
        NSLog(@"%@", [NSString stringWithFormat:@"timebeforepenalty2: %d",  ((RubiksTimerTimeObj *)self.dataProcessor.lastTime).timeValueAfterPenalty]);
        //NSLog ([NSString stringWithFormat:@"%d\n", self.time]);
        [self.dataProcessor storeIntoFile];
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", self.dataProcessor.numberOfSolves];
        self.thisScramble = self.nextScramble;
        //self.thisScramble = [self.scrambler generateScrambleString:self.scrambleType];
        NSLog(@"this: %@", self.thisScramble);
        self.scrambleDisplay.text = self.thisScramble;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        solvedTimes++;
        BOOL ifRated = [defaults boolForKey:@"ifRated"];
        if (solvedTimes >= 100) {
            solvedTimes = 0;
            if (!ifRated) {
                UIAlertView *rateAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"rateTitle", NULL) message:NSLocalizedString(@"rateBody", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"remind later", NULL) otherButtonTitles:NSLocalizedString(@"remind now", NULL), NSLocalizedString(@"never remind", NULL) , nil];
                [rateAlert setTag:6];
                [rateAlert show];
            }
        }
        NSLog(@"times: %d", solvedTimes);
        [defaults setInteger:solvedTimes forKey:@"solvedTimes"];
        NSLog(@"times get: %d", [defaults integerForKey:@"solvedTimes"]);
        [self performSelector:@selector(generateNextScramble) withObject:nil afterDelay:0.1];
        //self.thisScramble = [self.scrambler generateScrambleString:self.scrambleType];
        //self.scrambleDisplay.text = self.thisScramble;
        //[self hideTabBar:NO];
    }
}
/*
 - (void) hideTabBar:(BOOL) hidden{
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationDuration:0];
 for(UIView *view in self.tabBarController.view.subviews)
 {
 if([view isKindOfClass:[UITabBar class]])
 {
 if (hidden) {
 [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
 } else {
 [view setFrame:CGRectMake(view.frame.origin.x, 433, view.frame.size.width, view.frame.size.height)];
 }
 }
 else
 {
 if (hidden) {
 [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
 } else {
 [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 433)];
 }
 }
 }
 [UIView commitAnimations];
 }
 */


- (IBAction)addPenalty:(UITapGestureRecognizer *)tapGesture {
    NSLog(@"add penalty.");
    NSLog(@"last: %d", self.dataProcessor.lastTime.timeValueBeforePenalty);
    //NSLog([NSString stringWithFormat:@"%d\n", self.timerStatus]);
    if (self.dataProcessor.numberOfSolves > 0 && ![self.timerDisplay.text isEqualToString:@"Ready"] && self.timerStatus != 3 && self.timerStatus != 5 && self.dataProcessor.lastTime.timeValueBeforePenalty != 2147483647) {
        UIAlertView *addPenaltyAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"penalty", NULL) message:NSLocalizedString(@"this time was", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", NULL) otherButtonTitles:@"+2", @"DNF", NSLocalizedString(@"no penalty", NULL) , nil];
        [addPenaltyAlert setTag:3];
        [addPenaltyAlert show];
    }
    
}

- (IBAction)deleteLastSolve:(UISwipeGestureRecognizer *)swipeGesture {
    NSLog(@"swipe left.");
    if (self.timerStatus != 3 && self.timerStatus != 5 && self.dataProcessor.numberOfSolves > 0) {
        if (swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft) {
            // delete
            NSLog(@"swipe left.");
            
            UIAlertView *deleteLastTimeAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"delete last", NULL) message:NSLocalizedString(@"sure?", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"no", NULL) otherButtonTitles:NSLocalizedString(@"yes", NULL), nil];
            [deleteLastTimeAlert setTag:1];
            [deleteLastTimeAlert show];
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", self.dataProcessor.numberOfSolves];
        }
    }
}

- (IBAction)clearTimer:(UITapGestureRecognizer *)tapGesture{
    NSLog(@"Clear Timer.");
    if (self.timerStatus != 3 && self.timerStatus != 5 && self.dataProcessor.numberOfSolves > 0) {
        UIAlertView *clearTimeAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"reset session", NULL) message:NSLocalizedString(@"sure?", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"no", NULL) otherButtonTitles:NSLocalizedString(@"yes", NULL), nil];
        [clearTimeAlert setTag:2];
        [clearTimeAlert show];
    }
}

- (IBAction)chooseScrambleType:(id)sender {
    NSLog(@"Choose Scramble Type.");
    if (self.timerStatus != 3 && self.timerStatus != 5) {
        [self.alert setTag:4];
        [self.alert show];
    }
}


- (void)alertView:(UIAlertView *)uiAlertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (uiAlertView.tag) {
        case 1:
            // delete last time
            if (buttonIndex == 1) {
                [self.dataProcessor lastTimeModify:3];
                self.timerDisplay.text = @"Ready";
            }
            [self.dataProcessor storeIntoFile];
            break;
        case 2:
            // clear session
            if (buttonIndex == 1) {
                [self.dataProcessor clearArray];
                self.timerDisplay.text = @"Ready";
            }
            [self.dataProcessor storeIntoFile];
            break;
        case 3:
            // add penalty
            switch (buttonIndex) {
                case 1:
                    [self.dataProcessor lastTimeModify:1];
                    self.timerDisplay.text = [self.dataProcessor.lastTime toString];
                    [self.dataProcessor storeIntoFile];
                    break;
                case 2:
                    [self.dataProcessor lastTimeModify:2];
                    self.timerDisplay.text = [self.dataProcessor.lastTime toString];
                    [self.dataProcessor storeIntoFile];
                    break;
                case 3:
                    [self.dataProcessor lastTimeModify:0];
                    self.timerDisplay.text = [self.dataProcessor.lastTime toString];
                    [self.dataProcessor storeIntoFile];
                    break;
                default:
                    break;
            }
            break;
        case 4:
            //choose scramble type
            if (buttonIndex == 1) {
                
                NSString *typeTemp = [NSString stringWithString:self.alert.chooseType];
                NSString *subsetTemp = [NSString stringWithString:self.alert.chooseSubsets];
                self.scrambleType = [typeTemp stringByAppendingString:subsetTemp];
                self.dataProcessor.CurrentType = self.scrambleType;
                self.thisScramble = [self.scrambler generateScrambleString:self.scrambleType];
                NSLog(@"this: %@", self.thisScramble);
                [self setScrambleDisplayFont];
                self.scrambleDisplay.text = self.thisScramble;
                self.nextScramble = self.thisScramble;
                [self performSelector:@selector(generateNextScramble) withObject:nil afterDelay:1];
            }
            
            break;
        case 5:
            if (buttonIndex == 1) {
                [self performSelectorOnMainThread:@selector(disSpin) withObject:nil waitUntilDone:NO];
                [self performSelector:@selector(choose333Scramble) withObject:nil afterDelay:0.1];
            }
            break;
        case 6:
            switch (buttonIndex) {
                case 1:
                {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setBool:YES forKey:@"ifRated"];
                    NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d", 537516001];
                    NSLog(@"URL string:%@",str);
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                    
                }
                    break;
                case 2:
                {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setBool:YES forKey:@"ifRated"];
                }
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", self.dataProcessor.numberOfSolves];
}

- (void) disSpin {
    self.view.alpha = 0.7;
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setFrame:CGRectMake(0, 0, 100, 100)];
    spinner.layer.cornerRadius = 10;
    spinner.layer.masksToBounds = YES;
    [spinner setBackgroundColor:[UIColor blackColor]];
    CGRect tScreenBounds = [[UIScreen mainScreen] applicationFrame];
    if (tScreenBounds.size.height == 1024) {
        spinner.center = CGPointMake(tScreenBounds.size.height/2, tScreenBounds.size.width/2);
    }
    else {
        spinner.center = CGPointMake(tScreenBounds.size.width/2, tScreenBounds.size.height/2);
    }
    spinner.tag = 1111;
    spinner.alpha = 1;
    [spinner startAnimating];
    [self.view addSubview:spinner];
}

- (void) choose333Scramble{
    self.scrambleType = @"3x3random state";
    self.dataProcessor.CurrentType = self.scrambleType;
    self.thisScramble = [self.scrambler generateScrambleString:self.scrambleType];
    [self.scrambleDisplay setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    self.scrambleDisplay.text = self.thisScramble;
    //ifFirstStartRand333 = NO;
    UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[self.view viewWithTag:1111];
    [spinner stopAnimating];
    self.view.alpha = 1;
    self.nextScramble = self.thisScramble;
    [self performSelector:@selector(generateNextScramble) withObject:nil afterDelay:1];
}


- (void) generateNextScramble {
    self.nextScramble = [self.scrambler generateScrambleString:self.scrambleType];
    NSLog(@"next: %@", self.nextScramble);
}

- (void) setScrambleDisplayFont {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([[self.scrambleType substringToIndex:1]isEqualToString:@"2"]) {
            [self.scrambleDisplay setFont:[UIFont fontWithName:@"Helvetica" size:20.0f]];
        }else if ([[self.scrambleType substringToIndex:1]isEqualToString:@"P"]) {
            [self.scrambleDisplay setFont:[UIFont fontWithName:@"Helvetica" size:20.0f]];
        }else if ([[self.scrambleType substringToIndex:1]isEqualToString:@"4"]) {
            [self.scrambleDisplay setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
        } else if ([[self.scrambleType substringToIndex:1]isEqualToString:@"5"]) {
            [self.scrambleDisplay setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
        } else if ([[self.scrambleType substringToIndex:1]isEqualToString:@"6"]) {
            [self.scrambleDisplay setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        } else if ([[self.scrambleType substringToIndex:1]isEqualToString:@"7"]) {
            [self.scrambleDisplay setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        } else if ([self.scrambleType isEqualToString:@"MegaminxPochmann"]) {
            [self.scrambleDisplay setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        } else {
            [self.scrambleDisplay setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
        }
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ([[self.scrambleType substringToIndex:1]isEqualToString:@"4"]) {
            [self.scrambleDisplay setFont:[UIFont fontWithName:@"Helvetica" size:20.0f]];
        } else if ([[self.scrambleType substringToIndex:1]isEqualToString:@"5"]) {
            [self.scrambleDisplay setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
        } else if ([[self.scrambleType substringToIndex:1]isEqualToString:@"6"]) {
            [self.scrambleDisplay setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
        } else if ([[self.scrambleType substringToIndex:1]isEqualToString:@"7"]) {
            [self.scrambleDisplay setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
        } else if ([self.scrambleType isEqualToString:@"MegaminxPochmann"]) {
            [self.scrambleDisplay setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
        } else {
            [self.scrambleDisplay setFont:[UIFont fontWithName:@"Helvetica" size:22.0f]];
        }
    }
}

- (IBAction) displayScrambleImage:(id)sender {
    RubiksTimerImageDisplayViewController *imageDisplayViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"imageDisplay"];
    [imageDisplayViewController.view setFrame:CGRectMake(0, 0, 260, 200)];
    imageDisplayViewController.view.layer.cornerRadius = 5;
    imageDisplayViewController.view.layer.masksToBounds = YES;
    [self presentPopupViewController:imageDisplayViewController animationType:MJPopupViewAnimationSlideBottomBottom];    
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

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

@end

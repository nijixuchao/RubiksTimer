//
//  RubiksTimerEditSessionViewController.h
//  ChaoTimer
//
//  Created by Jichao Li on 12/4/12.
//  Copyright (c) 2012 Jichao Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RubiksTimerSessionManager.h"

@interface RubiksTimerEditSessionViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) UITextField *myTextField;
@property BOOL isNew;
@property NSString *oldSessionName;
@property (nonatomic, strong) RubiksTimerSessionManager *sessionManager;
@end

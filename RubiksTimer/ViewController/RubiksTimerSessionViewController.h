//
//  RubiksTimerSessionViewController.h
//  ChaoTimer
//
//  Created by Jichao Li on 11/27/12.
//  Copyright (c) 2012 Jichao Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RubiksTimerSessionManager.h"

@interface RubiksTimerSessionViewController : UITableViewController <UIActionSheetDelegate>
@property (nonatomic, strong) RubiksTimerSessionManager *sessionManager;
@end

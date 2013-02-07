//
//  RubiksTimerStatsViewController.h
//  RubiksTimer
//
//  Created by Jichao Li on 5/26/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h" 
#import "WBLogInAlertView.h"
#import "FBConnect.h"
#import "ROConnect.h"
#import "RubiksTimerWBSendViewController.h"

@interface RubiksTimerStatsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIPopoverControllerDelegate, RubiksTimerWBSendDelegate, WBEngineDelegate, FBSessionDelegate, FBDialogDelegate, RenrenDelegate> {
    WBEngine *weiBoEngine;
    Facebook *facebook;
    Renren *renren;
   UIActionSheet *shareSheet;
    UIPopoverController *popoverController;
}
@property (nonatomic, strong) NSMutableArray *stats;
@property (nonatomic, strong) WBEngine *weiBoEngine;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, strong) Renren *renren;
@property (nonatomic, retain) UIPopoverController *popoverController;


@end

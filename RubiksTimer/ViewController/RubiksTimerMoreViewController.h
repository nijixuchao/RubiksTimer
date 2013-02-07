//
//  RubiksTimerMoreViewController.h
//  ChaoTimer
//
//  Created by Jichao Li on 6/24/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "WBEngine.h"
#import "WBSendView.h"  
#import "WBLogInAlertView.h"
#import "FBConnect.h"
#import "ROConnect.h"

@interface RubiksTimerMoreViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate,WBSendViewDelegate, WBEngineDelegate, FBSessionDelegate, RenrenDelegate> {
    WBEngine *weiBoEngine;
    Facebook *facebook;
    Renren *renren;
}

@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) WBEngine *weiBoEngine;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, strong) Renren *renren;
@property (nonatomic) BOOL isWeiboIn, isFBIn, isRRIn;
@end

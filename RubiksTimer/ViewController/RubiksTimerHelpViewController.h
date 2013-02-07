//
//  RubiksTimerHelpViewController.h
//  ChaoTimer
//
//  Created by Jichao Li on 6/29/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RubiksTimerHelpViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *helps;
@property (nonatomic, strong) NSArray *helpsToDo;
@property (nonatomic, strong) NSArray *helpsImage;
@end

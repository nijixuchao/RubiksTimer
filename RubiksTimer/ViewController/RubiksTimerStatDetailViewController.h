//
//  RubiksTimerStatDetailViewController.h
//  RubiksTimer
//
//  Created by Jichao Li on 5/26/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RubiksTimerDataProcessing.h"

@interface RubiksTimerStatDetailViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *statDetails;
@property (nonatomic, strong) RubiksTimerDataProcessing *dataProcessor;
@property (nonatomic) NSString *detailType;
@end

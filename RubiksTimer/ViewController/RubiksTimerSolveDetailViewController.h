//
//  RubiksTimerSolveDetailViewController.h
//  RubiksTimer
//
//  Created by Jichao Li on 5/28/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RubiksTimerSolveDetailViewController : UIViewController <UIActionSheetDelegate> {
    UIActionSheet *shareSheet;
}

@property (weak, nonatomic) IBOutlet UILabel *displayTime;
@property (weak, nonatomic) IBOutlet UILabel *displayScramble;
@property (weak, nonatomic) IBOutlet UILabel *displayType;
@property (nonatomic) NSString *time, *scramble, *type;
@end

//
//  RubiksTimerDataProcessing.h
//  RubiksTimer
//
//  Created by Jichao Li on 5/21/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RubiksTimerTimeObj.h"

@interface RubiksTimerDataProcessing : NSObject <NSCoding>
@property (readonly) int numberOfSolves;
@property (readonly) int bestTime;
@property (readonly) int worstTime;
@property (nonatomic, strong) NSString *CurrentType;
@property (nonatomic, strong) NSString *sessionName;


+ (NSString *)convertTimeFromMsecondToString: (int)msecond;
- (void)addATime : (int)time withPenalty: (int)penalty scramble:(NSString *)aScramble scrambleType:(NSString *) theType; // 0 for no penalty; 1 for +2; 2 for DNF
- (void)lastTimeModify : (int) modifyOption; // 0 for no penalty; 1 for +2; 2 for DNF; 3 for delete
- (int)calculateBestAvgOf: (int)solves;
- (int)calculateCurrentAvgOf: (int)solves;
- (int)calculateSessionAvg;
- (int)calculateSessionMean;
- (RubiksTimerTimeObj *)lastTime;
- (RubiksTimerTimeObj *)bestTimeObj;
- (RubiksTimerTimeObj *)worstTimeObj;
- (RubiksTimerTimeObj *)bestAvgTimeObjOf: (int)solves;
- (RubiksTimerTimeObj *)currentAvgTimeObjOf: (int)solves;
- (RubiksTimerTimeObj *)sessionAvgTimeObj;
- (RubiksTimerTimeObj *)sessionMeanTimeObj;
- (NSMutableArray *) anArrayOfTimeObjOfBest: (int)solves;
- (NSMutableArray *) anArrayOfTimeObjOfCurrent: (int)solves;
- (NSMutableArray *) anArrayOfTimeObjOfAllSolves;
- (NSString *)displayNumberOfSolves;
- (NSString *)toStringWithIndividualTime: (BOOL)ifContainIndividualTime;
- (void)removeTimeAtIndex: (int)index;
- (void)removeTimeObj: (RubiksTimerTimeObj *)aTimeObj;

- (void)clearArray;

- (void)storeIntoFile;
+ (RubiksTimerDataProcessing *)getFromFileByName:(NSString *)theName;
+ (RubiksTimerDataProcessing *) initWithName:(NSString *)name;
@end
//
//  RubiksTimerDataProcessing.m
//  RubiksTimer
//
//  Created by Jichao Li on 5/21/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import "RubiksTimerDataProcessing.h"
#import "RubiksTimerTimeObj.h"
#import "stdio.h"

@interface RubiksTimerDataProcessing ()
@property (nonatomic, strong) NSMutableArray *timeStoredArray;
@end


@implementation RubiksTimerDataProcessing
@synthesize timeStoredArray = _timeStoredArray;
@synthesize CurrentType = _CurrentType;
@synthesize sessionName = _sessionName;

- (NSString *) CurrentType {
    if (!_CurrentType) {
        _CurrentType = @"3x3random state";
    }
    return _CurrentType;
}

- (NSString *) sessionName {
    if (!_sessionName) {
        _sessionName = @"main session";
    }
    return _sessionName;
}

- (NSMutableArray *)timeStoredArray  {
    if (!_timeStoredArray) {
        _timeStoredArray = [[NSMutableArray alloc] init];
    }
    return _timeStoredArray;
}

+ (RubiksTimerDataProcessing *) initWithName:(NSString *)name{
    RubiksTimerDataProcessing *dataProcessing = [[RubiksTimerDataProcessing alloc] init];
    dataProcessing.sessionName = name;
    return dataProcessing;
}

+ (NSString *)convertTimeFromMsecondToString: (int)msecond {

    NSString *outputTimeString;
    if (msecond < 1000) {
        outputTimeString = [NSString stringWithFormat:@"0.%03d", msecond];
    } else if (msecond < 60000) {
        int second = msecond * 0.001;
        int msec = msecond % 1000;
        outputTimeString = [NSString stringWithFormat:@"%d.%03d", second, msec];
    } else if (msecond < 3600000) {
        int minute = msecond/60000;
        int second = (msecond % 60000)/1000;
        int msec = msecond % 1000;
        outputTimeString = [NSString stringWithFormat:@"%d:%02d.%03d", minute, second, msec];
    } else {
        int hour = msecond / 3600000;
        int minute = (msecond % 360000)/60000;
        int second = (msecond % 60000)/1000;
        int msec = msecond % 1000;
        outputTimeString = [NSString stringWithFormat:@"%d:%02d:%02d.%03d", hour, minute, second, msec];
    }
    return outputTimeString;
}

- (int)numberOfSolves {
    return self.timeStoredArray.count;
}

- (int)numberOfDNF {
    int n = 0;
    for (id times in self.timeStoredArray) {
        if (((RubiksTimerTimeObj *)times).penalty == 2) {
            n++;
        }
    }
    return n;
}

- (int)bestTime {
    int min = ((RubiksTimerTimeObj *)(self.timeStoredArray.lastObject)).timeValueAfterPenalty;
    for (id times in self.timeStoredArray) {
        if (((RubiksTimerTimeObj *)times).timeValueAfterPenalty < min) {
            min = ((RubiksTimerTimeObj *)times).timeValueAfterPenalty;
        }
    }
    return min;
}

- (int)worstTime {
    int max = ((RubiksTimerTimeObj *)(self.timeStoredArray.lastObject)).timeValueAfterPenalty;
    for (id times in self.timeStoredArray) {
        if (((RubiksTimerTimeObj *)times).timeValueAfterPenalty > max) {
            max = ((RubiksTimerTimeObj *)times).timeValueAfterPenalty;
        }
    }
    return max;
}

- (RubiksTimerTimeObj *)bestTimeObj {
    RubiksTimerTimeObj *min = (RubiksTimerTimeObj *)(self.timeStoredArray.lastObject);
    for (id times in self.timeStoredArray) {
        if (((RubiksTimerTimeObj *)times).timeValueAfterPenalty < min.timeValueAfterPenalty) {
            min = (RubiksTimerTimeObj *)times;
        }
    }
    return min;
}

- (RubiksTimerTimeObj *)worstTimeObj {
    RubiksTimerTimeObj *max = (RubiksTimerTimeObj *)(self.timeStoredArray.lastObject);
    for (id times in self.timeStoredArray) {
        if (((RubiksTimerTimeObj *)times).timeValueAfterPenalty > max.timeValueAfterPenalty) {
            max = (RubiksTimerTimeObj *)times;
        }
    }
    return max;
}

- (int)bestTimeOfAnArray: (NSMutableArray *)theArray {
    int min = ((RubiksTimerTimeObj *)(theArray.lastObject)).timeValueAfterPenalty;
    for (id times in theArray) {
        if (((RubiksTimerTimeObj *)times).timeValueAfterPenalty < min) {
            min = ((RubiksTimerTimeObj *)times).timeValueAfterPenalty;
        }
    }
    return min;
}

- (int)worstTimeOfAnArray: (NSMutableArray *)theArray {
    int max = ((RubiksTimerTimeObj *)(theArray.lastObject)).timeValueAfterPenalty;
    for (id times in theArray) {
        if (((RubiksTimerTimeObj *)times).timeValueAfterPenalty > max) {
            max = ((RubiksTimerTimeObj *)times).timeValueAfterPenalty;
        }
    }
    return max;
}

// delete the best time and worst time and calculate avg
- (int) calculateAvgOfAnArray: (NSMutableArray *)theArray {
    int avg = 0;
    if (theArray.count >= 3) {
        int sum = 0;
        for (id times in theArray) {
            sum = sum + ((RubiksTimerTimeObj *)times).timeValueAfterPenalty;
        }
        sum = sum - [self bestTimeOfAnArray:theArray]-[self worstTimeOfAnArray:theArray];
        avg = sum / (theArray.count - 2);
    }
    return avg;
}

- (void)addATime:(int)time withPenalty:(int)penalty scramble:(NSString *)aScramble scrambleType:(NSString *)theType {
    RubiksTimerTimeObj *newTime = [[RubiksTimerTimeObj alloc] init];
    [newTime setTimeValue:time andPenalty:penalty scramble:aScramble type:theType];
    newTime.index = self.numberOfSolves;
    [self.timeStoredArray addObject:newTime];
}

// 0 for no penalty; 1 for +2; 2 for DNF; 3 for delete
- (void)lastTimeModify : (int) modifyOption {
    if (self.numberOfSolves > 0) {
        switch (modifyOption) {
            case 0:
                ((RubiksTimerTimeObj *)self.timeStoredArray.lastObject).penalty = modifyOption;
                ((RubiksTimerTimeObj *)self.timeStoredArray.lastObject).timeValueAfterPenalty = ((RubiksTimerTimeObj *)self.timeStoredArray.lastObject).timeValueBeforePenalty;
                if (((RubiksTimerTimeObj *)self.timeStoredArray.lastObject).timeValueBeforePenalty == INFINITY) {
                    ((RubiksTimerTimeObj *)self.timeStoredArray.lastObject).timeValueAfterPenalty = INFINITY;
                }
                NSLog(@"%@", [NSString stringWithFormat:@"timebeforepenalty1: %d",  ((RubiksTimerTimeObj *)self.timeStoredArray.lastObject).timeValueBeforePenalty]);
                
                break;
            case 1:
                if (((RubiksTimerTimeObj *)self.timeStoredArray.lastObject).timeValueBeforePenalty == INFINITY) {
                    ((RubiksTimerTimeObj *)self.timeStoredArray.lastObject).timeValueAfterPenalty = INFINITY;
                    break;
                }
                ((RubiksTimerTimeObj *)self.timeStoredArray.lastObject).penalty = modifyOption;
                ((RubiksTimerTimeObj *)self.timeStoredArray.lastObject).timeValueAfterPenalty = ((RubiksTimerTimeObj *)self.timeStoredArray.lastObject).timeValueBeforePenalty + 2000;
                
                break;
            case 2:
                NSLog(@"DNF.");
                ((RubiksTimerTimeObj *)self.timeStoredArray.lastObject).penalty = modifyOption;
                ((RubiksTimerTimeObj *)self.timeStoredArray.lastObject).timeValueAfterPenalty = INFINITY;
                break;
            case 3:
                [self.timeStoredArray removeLastObject];
                break;
            default:
                break;
        }
    }
}

- (RubiksTimerTimeObj *)lastTime {
    return self.timeStoredArray.lastObject;
}

/* bugs to be fixed*/
- (int)calculateBestAvgOf: (int)solves {
    int bestavg = INFINITY;
    if ((self.numberOfSolves >= solves) && (self.numberOfSolves >=3)) {
        for (int i = 0; i <= (self.numberOfSolves - solves); i++) {
            int avg = 0;
            int sum = 0;
            int max = 0;
            int min = INFINITY;
            int DNFs = 0;
            for (int j = 0; j < solves; j++) {
                int thisTime = ((RubiksTimerTimeObj *)[self.timeStoredArray objectAtIndex:(i+j)]).timeValueAfterPenalty;
                int p = ((RubiksTimerTimeObj *)[self.timeStoredArray objectAtIndex:(i+j)]).penalty;
                if (p == 2) {
                    DNFs++;
                }
                sum = sum + thisTime;
                if (thisTime > max) {
                    max = thisTime;
                }
                if (thisTime < min) {
                    min = thisTime;
                }
            }
            if (DNFs > 1) {
                avg = INFINITY;
            } else {
                sum = sum - min - max;
                avg = sum / (solves - 2);
            }
            if (bestavg > avg) {
                bestavg = avg;
            }
        }
    }
    // why if (bestavg == INFINITY) not right?
    if (bestavg == 2147483647) {
        bestavg = -1;
    }
    
    //NSLog([NSString stringWithFormat:@"%d: %d", solves, bestavg]);
    return bestavg;
}

- (int)calculateCurrentAvgOf: (int)solves {
    int avg = 0;
    if ((self.numberOfSolves >= solves) && (self.numberOfSolves >=3)) {
        int sum = 0;
        int max = 0;
        int min = INFINITY;
        int DNFs = 0;
        for (int i = (self.timeStoredArray.count - solves); i < self.timeStoredArray.count; i++) {
            int thisTime = ((RubiksTimerTimeObj *)[self.timeStoredArray objectAtIndex:i]).timeValueAfterPenalty;
            int p =  ((RubiksTimerTimeObj *)[self.timeStoredArray objectAtIndex:i]).penalty;
            if (p == 2) {
                DNFs++;
            }
            sum = sum + thisTime;
            if (thisTime > max) {
                max = thisTime;
            }
            if (thisTime < min) {
                min = thisTime;
            }
        }
        if (DNFs > 1) {
            avg = -1;
        }
        else {
            sum = sum - min -max;
            avg = sum / (solves - 2);
        }
    }
    return avg;
}

- (int)calculateSessionAvg {
    int avg = 0;
    if (self.numberOfSolves >= 3) {
        int sum = 0;
        int DNFs = 0;
        for (id times in self.timeStoredArray) {
            int thisTime = ((RubiksTimerTimeObj *)times).timeValueAfterPenalty;
            int p = ((RubiksTimerTimeObj *)times).penalty;
            sum = sum + thisTime;
            if (p == 2) {
                DNFs++;
            }
        }
        if (DNFs > 1) {
            avg = -1;
        } else {
            sum = sum - [self bestTime]-[self worstTime];
            avg = sum / (self.numberOfSolves - 2);
        }
    }
    return avg;
}

- (int)calculateSessionMean {
    int mean = 0;
    if (self.numberOfSolves > 0) {
        int sum = 0;
        int DNFs = 0;
        for (id times in self.timeStoredArray) {
            int thisTime = ((RubiksTimerTimeObj *)times).timeValueAfterPenalty;
            int p = ((RubiksTimerTimeObj *)times).penalty;
            if (p == 2) {
                DNFs++;
            } else {
                sum = sum + thisTime;
            }
        }
        if (self.numberOfSolves > DNFs) {
            mean = sum / (self.numberOfSolves - DNFs);
        }
        else {
            mean = -1;
        }
    }
    return mean;
}

- (RubiksTimerTimeObj *)bestAvgTimeObjOf: (int)solves {
    int time = [self calculateBestAvgOf:solves];
    int penalty = 0;
    if (time == -1) {
        penalty = 2;
    }
    return [RubiksTimerTimeObj timeObjWith:time andPenalty:penalty];
}
- (RubiksTimerTimeObj *)currentAvgTimeObjOf: (int)solves {
    int time = [self calculateCurrentAvgOf:solves];
    int penalty = 0;
    if (time == -1) {
        penalty = 2;
    }
    return [RubiksTimerTimeObj timeObjWith:time andPenalty:penalty];
}
- (RubiksTimerTimeObj *)sessionAvgTimeObj {
    int time = [self calculateSessionAvg];
    int penalty = 0;
    if (time == -1) {
        penalty = 2;
    }
    return [RubiksTimerTimeObj timeObjWith:time andPenalty:penalty];
}
- (RubiksTimerTimeObj *)sessionMeanTimeObj {
    int time = [self calculateSessionMean];
    int penalty = 0;
    if (time == -1) {
        penalty = 2;
    }
    return [RubiksTimerTimeObj timeObjWith:time andPenalty:penalty];
}

- (NSMutableArray *) anArrayOfTimeObjOfBest: (int)solves {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    int bestavg = INFINITY;
    int index = 0;
    if ((self.numberOfSolves >= solves) && (self.numberOfSolves >=3)) {
        for (int i = 0; i <= (self.numberOfSolves - solves); i++) {
            int avg = 0;
            int sum = 0;
            int max = 0;
            int min = INFINITY;
            int DNFs = 0;
            for (int j = 0; j < solves; j++) {
                int thisTime = ((RubiksTimerTimeObj *)[self.timeStoredArray objectAtIndex:(i+j)]).timeValueAfterPenalty;
                int p = ((RubiksTimerTimeObj *)[self.timeStoredArray objectAtIndex:(i+j)]).penalty;
                if (p == 2) {
                    DNFs++;
                }
                sum = sum + thisTime;
                if (thisTime > max) {
                    max = thisTime;
                }
                if (thisTime < min) {
                    min = thisTime;
                }
            }
            if (DNFs > 1) {
                avg = INFINITY;
            } else {
                sum = sum - min - max;
                avg = sum / (solves - 2);
            }
            if (bestavg > avg) {
                bestavg = avg;
                index = i;
            }
        }
    }
    for (int i = index; i < (index + solves); i++) {
        [array addObject:[self.timeStoredArray objectAtIndex:i]];
    }
    return array;
}

- (NSMutableArray *) anArrayOfTimeObjOfCurrent: (int)solves {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ((self.numberOfSolves >= solves) && (self.numberOfSolves >=3)) {
        for (int i = (self.timeStoredArray.count - solves); i < self.timeStoredArray.count; i++) {
            [array addObject:[self.timeStoredArray objectAtIndex:i]];
        }
    }
    return array;
}
    
- (NSMutableArray *) anArrayOfTimeObjOfAllSolves {
    return [self.timeStoredArray mutableCopy];
}



- (NSString *)displayNumberOfSolves {
    int num = self.numberOfSolves;
    return [NSString stringWithFormat:@"%d", num];
}


- (NSString *)toStringWithIndividualTime:(BOOL)ifContainIndividualTime {
    NSString *stringToDisplay;
    if (self.numberOfSolves == 0) {
        stringToDisplay = @"Number of Solves: 0";
    } else {
        if (ifContainIndividualTime == NO) {
            int avg = [self calculateSessionAvg];
            int mean = [self calculateSessionMean];
            
            NSString *numberOfTotalSolves = [NSLocalizedString(@"Number of solves: ", NULL) stringByAppendingFormat:@"%d\n", self.numberOfSolves];
            NSString *bestTime = [[NSLocalizedString(@"Best Time: ", NULL) stringByAppendingString:[[self bestTimeObj] toString]] stringByAppendingFormat:@"\n"];
            NSString *worstTime = [[NSLocalizedString(@"Worst Time: ", NULL) stringByAppendingString:[[self worstTimeObj] toString]] stringByAppendingFormat:@"\n\n"];
            NSString *sessionAvg;
            if (avg == -1) {
                sessionAvg = [NSLocalizedString(@"Session Avg: ",NULL) stringByAppendingFormat:@"DNF\n"];
            } else {
                sessionAvg = [[NSLocalizedString(@"Session Avg: ", NULL) stringByAppendingString:[RubiksTimerDataProcessing convertTimeFromMsecondToString:avg]] stringByAppendingFormat:@"\n"];
            }
            NSString *sessionMean;
            if (mean == -1) {
                sessionMean = [NSLocalizedString(@"Session Mean: ", NULL) stringByAppendingFormat:@"DNF\n"];
            } else {
                sessionMean = [[NSLocalizedString(@"Session Mean: ", NULL) stringByAppendingString:[RubiksTimerDataProcessing convertTimeFromMsecondToString:mean]] stringByAppendingFormat:@"\n"];
            }

            if (self.numberOfSolves < 5) {
                stringToDisplay = [[[[numberOfTotalSolves stringByAppendingString:bestTime] stringByAppendingString:worstTime] stringByAppendingString:sessionAvg] stringByAppendingString:sessionMean];
            } else {
                int ca5 = [self calculateCurrentAvgOf:5];
                int ca12 = [self calculateCurrentAvgOf:12];
                int ca100 = [self calculateCurrentAvgOf:100];
                int ba5 = [self calculateBestAvgOf:5];
                int ba12 = [self calculateBestAvgOf:12];
                int ba100 = [self calculateBestAvgOf:100];
                NSString *currentAvg5;
                if (ca5 == -1) {
                    currentAvg5 = [NSLocalizedString(@"Current Avg5: ", NULL) stringByAppendingFormat:@"DNF\n"];
                } else {
                    currentAvg5 = [[NSLocalizedString(@"Current Avg5: ", NULL) stringByAppendingString:[RubiksTimerDataProcessing convertTimeFromMsecondToString:ca5]] stringByAppendingFormat:@"\n"];
                }
                
                NSString *bestAvg5;
                if (ba5 == -1) {
                    bestAvg5 = [NSLocalizedString(@"Best Avg5: ", NULL) stringByAppendingFormat:@"DNF\n"];
                } else {
                    bestAvg5 = [[NSLocalizedString(@"Best Avg5: ", NULL) stringByAppendingString:[RubiksTimerDataProcessing convertTimeFromMsecondToString:ba5]] stringByAppendingFormat:@"\n\n"];
                }
                
                
                NSString *currentAvg12;
                if (ca12 == -1) {
                    currentAvg12 = [NSLocalizedString(@"Current Avg12: ", NULL) stringByAppendingFormat:@"DNF\n"];
                } else {
                    currentAvg12 = [[NSLocalizedString(@"Current Avg12: ", NULL) stringByAppendingString:[RubiksTimerDataProcessing convertTimeFromMsecondToString:ca12]] stringByAppendingFormat:@"\n"];
                }
                
                NSString *bestAvg12;
                if (ba12 == -1) {
                    bestAvg12 = [NSLocalizedString(@"Best Avg12: ", NULL) stringByAppendingFormat:@"DNF\n\n"];
                } else {
                    bestAvg12 = [[NSLocalizedString(@"Best Avg12: ", NULL) stringByAppendingString:[RubiksTimerDataProcessing convertTimeFromMsecondToString:ba12]] stringByAppendingFormat:@"\n\n"];
                }
                
                NSString *currentAvg100;
                if (ca100 == -1) {
                    currentAvg100 = [NSLocalizedString(@"Current Avg100: ", NULL) stringByAppendingFormat:@"DNF\n\n"];
                } else {
                    currentAvg100 = [[NSLocalizedString(@"Current Avg100: ", NULL) stringByAppendingString:[RubiksTimerDataProcessing convertTimeFromMsecondToString:ca100]] stringByAppendingFormat:@"\n"];
                }
                
                NSString *bestAvg100;
                if (ba100 == -1) {
                    bestAvg100 = [NSLocalizedString(@"Best Avg100: ", NULL) stringByAppendingFormat:@"DNF\n"];
                } else {
                    bestAvg100 = [[NSLocalizedString(@"Best Avg100: ", NULL) stringByAppendingString:[RubiksTimerDataProcessing convertTimeFromMsecondToString:ba100]] stringByAppendingFormat:@"\n"];
                }
                if (self.numberOfSolves < 12 ) {
                    stringToDisplay = [[[[[[numberOfTotalSolves stringByAppendingString:bestTime] stringByAppendingString:worstTime] stringByAppendingString:currentAvg5] stringByAppendingString:bestAvg5] stringByAppendingString:sessionAvg] stringByAppendingString:sessionMean];;
                } else if (self.numberOfSolves < 100) {
                    stringToDisplay = [[[[[[[[numberOfTotalSolves stringByAppendingString:bestTime] stringByAppendingString:worstTime] stringByAppendingString:currentAvg5] stringByAppendingString:bestAvg5] stringByAppendingString:currentAvg12] stringByAppendingString:bestAvg12] stringByAppendingString:sessionAvg] stringByAppendingString:sessionMean];
                } else {
                    stringToDisplay = [[[[[[[[[[numberOfTotalSolves stringByAppendingString:bestTime] stringByAppendingString:worstTime] stringByAppendingString:currentAvg5] stringByAppendingString:bestAvg5] stringByAppendingString:currentAvg12] stringByAppendingString:bestAvg12] stringByAppendingString:currentAvg100] stringByAppendingString:bestAvg100] stringByAppendingString:sessionAvg] stringByAppendingString:sessionMean];
                }
            }

        }
        else {
            int avg = [self calculateSessionAvg];
            int mean = [self calculateSessionMean];
            
            NSString *numberOfTotalSolves = [NSLocalizedString(@"Number of solves: ", NULL) stringByAppendingFormat:@"%d\n", self.numberOfSolves];
            NSString *bestTime = [[NSLocalizedString(@"Best Time: ", NULL) stringByAppendingString:[[self bestTimeObj] toStringWith2BehindPoint]] stringByAppendingFormat:@"\n"];
            NSString *worstTime = [[NSLocalizedString(@"Worst Time: ", NULL) stringByAppendingString:[[self worstTimeObj] toStringWith2BehindPoint]] stringByAppendingFormat:@"\n\n"];
            NSString *sessionAvg;
            if (avg == -1) {
                sessionAvg = [NSLocalizedString(@"Session Avg: ",NULL) stringByAppendingFormat:@"DNF\n"];
            } else {
                sessionAvg = [[NSLocalizedString(@"Session Avg: ", NULL) stringByAppendingString: [[self sessionAvgTimeObj] toStringWith2BehindPoint]] stringByAppendingFormat:@"\n"];
            }
            NSString *sessionMean;
            if (mean == -1) {
                sessionMean = [NSLocalizedString(@"Session Mean: ", NULL) stringByAppendingFormat:@"DNF\n"];
            } else {
                sessionMean = [[NSLocalizedString(@"Session Mean: ", NULL) stringByAppendingString:[[self sessionMeanTimeObj] toStringWith2BehindPoint]] stringByAppendingFormat:@"\n"];
            }

            
            BOOL notHasBest = YES;
            BOOL notHasWorst = YES;
            NSString *timesList = @"";
            RubiksTimerTimeObj *tempBest = self.timeStoredArray.lastObject;
            RubiksTimerTimeObj *tempWorst = self.timeStoredArray.lastObject;
            for (id aTime in self.timeStoredArray) {
                if (((RubiksTimerTimeObj *)aTime).timeValueAfterPenalty > tempWorst.timeValueAfterPenalty) {
                    tempWorst = (RubiksTimerTimeObj *)aTime;
                }  
                if (((RubiksTimerTimeObj *)aTime).timeValueAfterPenalty < tempBest.timeValueAfterPenalty) {
                    tempBest = (RubiksTimerTimeObj *)aTime;
                }  
            }
            for (id aTime in self.timeStoredArray) {
                NSString *appEndTime = [aTime toStringWith2BehindPoint];
                if ([aTime isEqual:tempBest] && notHasBest) {
                    appEndTime = [[@"(" stringByAppendingString:appEndTime] stringByAppendingString:@")"];
                    notHasBest = NO;
                } else if ([aTime isEqual:tempWorst] && notHasWorst) {
                    appEndTime = [[@"(" stringByAppendingString:appEndTime] stringByAppendingString:@")"];
                    notHasWorst = NO;
                }
                timesList = [[timesList stringByAppendingString:appEndTime] stringByAppendingString:@", "];
            }
            timesList = [timesList substringToIndex:(timesList.length - 2)];
            NSString *individualTimes = [[NSLocalizedString(@"Individual Times: ", NULL) stringByAppendingFormat:@"\n"] stringByAppendingString:timesList];
            
            stringToDisplay = [[[[[numberOfTotalSolves stringByAppendingString:bestTime] stringByAppendingString:worstTime] stringByAppendingString:sessionAvg] stringByAppendingFormat:@"\n"] stringByAppendingString:individualTimes];;
        }
    }
    if ([self.sessionName isEqualToString:@"main session"]) {
        stringToDisplay = [[NSLocalizedString(self.sessionName, NULL) stringByAppendingString:@"\n\n" ] stringByAppendingString:stringToDisplay];
    } else {
        stringToDisplay = [[self.sessionName stringByAppendingString:@"\n\n" ] stringByAppendingString:stringToDisplay];
    }
    return stringToDisplay;
}

- (void)removeTimeAtIndex: (int)index {
    if (self.timeStoredArray) {
        [self.timeStoredArray removeObjectAtIndex:index];
    }
}

- (void)removeTimeObj: (RubiksTimerTimeObj *)aTimeObj {
    if (self.timeStoredArray) {
        [self.timeStoredArray removeObject:aTimeObj];
    }
}

- (void)clearArray {
    if (self.timeStoredArray) {
        [self.timeStoredArray removeAllObjects];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.timeStoredArray forKey:@"timeArray"];
    [aCoder encodeObject:self.CurrentType forKey:@"currentType"];
    [aCoder encodeObject:self.sessionName forKey:@"sessionName"];

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super init]) {
        self.timeStoredArray = [aDecoder decodeObjectForKey:@"timeArray"];
        self.CurrentType = [aDecoder decodeObjectForKey:@"currentType"];
        self.sessionName = [aDecoder decodeObjectForKey:@"sessionName"];
    }
    return self;
}


- (void)storeIntoFile {
    NSLog(@"store");
    NSString *name;
    if (self.sessionName == nil) {
        name = @"main session";
    } else
        name = self.sessionName;
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[path objectAtIndex:0] stringByAppendingPathComponent:[@"timeProcess_" stringByAppendingString:name]];
    //NSLog(@"store path: %@",fileName);
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    NSString *keyName = self.sessionName;
    [archiver encodeObject:self forKey:keyName];
    //[archiver encodeObject:self forKey:@"timeProcessingObj"];
    [archiver finishEncoding];
    if ([data writeToFile:fileName atomically:YES]) {
        NSLog(@"Store dataProcessor");
//        NSLog(@"%@", [NSString stringWithFormat:@"Store! timebeforepenalty: %d",  ((RubiksTimerTimeObj *)self.lastTime).timeValueBeforePenalty]);
//        NSLog(@"%@", [NSString stringWithFormat:@"Store! timeafterpenalty: %d",  ((RubiksTimerTimeObj *)self.lastTime).timeValueAfterPenalty]);
//        NSLog(@"store type: %@", self.CurrentType);
    };
}
+ (RubiksTimerDataProcessing *)getFromFileByName:(NSString *)theName {
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSLog(@"Get document path: %@",[path objectAtIndex:0]);
    NSString *fileName = [[path objectAtIndex:0] stringByAppendingPathComponent:[@"timeProcess_" stringByAppendingString:theName]];
    //NSLog(@"get path: %@",fileName);
    RubiksTimerDataProcessing *dataProcessing= [[RubiksTimerDataProcessing alloc] init];    
    NSData *data = [[NSData alloc] initWithContentsOfFile:fileName];
    NSString *keyName = theName;
    if (data) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        dataProcessing = [unarchiver decodeObjectForKey:keyName];
        [unarchiver finishDecoding];
        NSLog(@"Get dataProcessor");
//         NSLog(@"%@", [NSString stringWithFormat:@"Get! timebeforepenalty: %d",  ((RubiksTimerTimeObj *)dataProcessing.lastTime).timeValueBeforePenalty]);
//        NSLog(@"%@", [NSString stringWithFormat:@"Get! timeafterpenalty: %d",  ((RubiksTimerTimeObj *)dataProcessing.lastTime).timeValueAfterPenalty]);
//        NSLog(@"get type: %@", dataProcessing.CurrentType);
        //dataProcessing.sessionName = theName;
        return dataProcessing;
    }
    else {
        return nil;
    }
}
@end

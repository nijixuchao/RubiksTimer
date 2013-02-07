//
//  RubiksTimerTimeObj.m
//  RubiksTimer
//
//  Created by Jichao Li on 5/22/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import "RubiksTimerTimeObj.h"
#import "RubiksTimerDataProcessing.h"

@interface RubiksTimerTimeObj ()

@end

@implementation RubiksTimerTimeObj
@synthesize timeValueBeforePenalty;
@synthesize timeValueAfterPenalty;
@synthesize penalty;
@synthesize scramble;
@synthesize index;
@synthesize type;

- (NSString *) toString {
    NSString *str;
    if (penalty == 1) {
        str = [[RubiksTimerDataProcessing convertTimeFromMsecondToString:timeValueAfterPenalty] stringByAppendingString:@"+"];
    } else if (penalty == 2) {
        str = @"DNF";
    } else {
        str =  [RubiksTimerDataProcessing convertTimeFromMsecondToString:timeValueAfterPenalty];
    }
    return str;
}

- (NSString *) toStringWith2BehindPoint {
    int tempVal = timeValueAfterPenalty;
    if ((timeValueAfterPenalty % 10 != 0) && (penalty!=2)) {
        tempVal = timeValueAfterPenalty + 5;
    }
    
    NSString *str;
    if (penalty == 1) {
        str = [[RubiksTimerDataProcessing convertTimeFromMsecondToString:tempVal] stringByAppendingString:@"+"];
    } else if (penalty == 2) {
        str = @"DNF";
    } else {
        str =  [RubiksTimerDataProcessing convertTimeFromMsecondToString:tempVal];
    }
    return [str substringToIndex:(str.length-1)];
}

- (void) setTimeValue: (int)newTimeValue andPenalty: (int)newPenalty {
    int t = newTimeValue;
    if (newPenalty == 1) {
        t = newTimeValue + 2000;
    } else if (newPenalty == 2) {
        t = INFINITY;
    }
    self.timeValueBeforePenalty = newTimeValue;
    self.timeValueAfterPenalty = t;
    self.penalty = newPenalty;
    self.scramble = @"";
    self.type = @"";
}

- (void) setTimeValue: (int)newTimeValue andPenalty: (int)newPenalty scramble: (NSString *)aScramble type:(NSString *)theType{
    int t = newTimeValue;
    if (newPenalty == 1) {
        t = newTimeValue + 2000;
    } else if (newPenalty == 2) {
        t = INFINITY;
    }
    self.timeValueBeforePenalty = newTimeValue;
    self.timeValueAfterPenalty = t;
    self.penalty = newPenalty;
    self.scramble = aScramble;
    self.type = theType;
    //NSLog(@"%@", [NSString stringWithFormat:@"timebeforepenalty1: %d", self.timeValueBeforePenalty]);
}

+ (RubiksTimerTimeObj *)timeObjWith: (int)timevalue andPenalty: (int)penalty {
    RubiksTimerTimeObj *newTimeObj = [[RubiksTimerTimeObj alloc] init];
    [newTimeObj setTimeValue:timevalue andPenalty:penalty];
    [newTimeObj setScramble:@""];
    [newTimeObj setType:@""];
    return newTimeObj;
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInt:timeValueBeforePenalty] forKey:@"timeBeforePenalty"];
    [aCoder encodeObject:[NSNumber numberWithInt:timeValueAfterPenalty] forKey:@"timeAfterPenalty"];
    [aCoder encodeObject:[NSNumber numberWithInt:penalty] forKey:@"timePenalty"];
    [aCoder encodeObject:scramble forKey:@"solveScramble"];
    [aCoder encodeObject:type forKey:@"solveType"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super init]) {
        self.timeValueBeforePenalty = [[aDecoder decodeObjectForKey:@"timeBeforePenalty"] intValue];
        self.timeValueAfterPenalty = [[aDecoder decodeObjectForKey:@"timeAfterPenalty"] intValue];
        self.penalty = [[aDecoder decodeObjectForKey:@"timePenalty"] intValue];
        self.scramble = [aDecoder decodeObjectForKey:@"solveScramble"];
        self.type =  [aDecoder decodeObjectForKey:@"solveType"];
    }
    return self;
}

@end

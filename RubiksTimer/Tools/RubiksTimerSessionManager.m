//
//  RubiksTimerSessionManager.m
//  ChaoTimer
//
//  Created by Jichao Li on 12/1/12.
//  Copyright (c) 2012 Jichao Li. All rights reserved.
//

#import "RubiksTimerSessionManager.h"
#import "RubiksTimerDataProcessing.h"

@implementation RubiksTimerSessionManager
@synthesize sessionArray = _sessionArray;
@synthesize stickySessionArray = _stickySessionArray;
@synthesize currentSession = _currentSession;

- (NSMutableArray *)stickySessionArray {
    if (!_stickySessionArray) {
        NSLog(@"no sticky sessionArray");
        _stickySessionArray = [[NSMutableArray alloc] init];
        [_stickySessionArray addObject:@"main session"];
    }
    return _stickySessionArray;
}

- (NSMutableArray *)sessionArray {
    if (!_sessionArray) {
        NSLog(@"no sessionArray");
        _sessionArray = [[NSMutableArray alloc] init];
    }
    return _sessionArray;
}

- (NSString *)currentSession {
    if (!_currentSession) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults stringForKey:@"currentSession"] != nil) {
            self.currentSession = [defaults stringForKey:@"currentSession"];
        } else
            _currentSession = @"main session";
    }
    return _currentSession;
}

+ (RubiksTimerDataProcessing *) getCurrentSessionfromName:(NSString *)name {
    NSString *theName = @"";
    if ([name isEqualToString:@""]) {
        theName = @"main session";
    } else
        theName = name;
    RubiksTimerDataProcessing *dataProcessor = [RubiksTimerDataProcessing getFromFileByName:theName];
    return dataProcessor;
}

- (void) addSesion:(NSString *)addName {
    [self.sessionArray insertObject:addName atIndex:0];
    self.currentSession = addName;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:addName forKey:@"currentSession"];
}

- (void) removeSession:(NSString *)removeName {
    if([self.stickySessionArray indexOfObject:removeName] != NSNotFound) {
        [self.stickySessionArray removeObject:removeName];
    } else
        [self.sessionArray removeObject:removeName];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[path objectAtIndex:0] stringByAppendingPathComponent:[@"timeProcess_" stringByAppendingString:removeName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:fileName error:nil];
    
}

- (void) removeStickySessionAtIndex:(int) index{
    NSString *removeName = [self.stickySessionArray objectAtIndex:index];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[path objectAtIndex:0] stringByAppendingPathComponent:[@"timeProcess_" stringByAppendingString:removeName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:fileName error:nil];
    [self.stickySessionArray removeObjectAtIndex:index];
}

- (void) removeNormalSessionAtIndex:(int) index{
    NSString *removeName = [self.sessionArray objectAtIndex:index];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[path objectAtIndex:0] stringByAppendingPathComponent:[@"timeProcess_" stringByAppendingString:removeName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:fileName error:nil];
    [self.sessionArray removeObjectAtIndex:index];
}

- (NSUInteger) stickySessionNum {
    return self.stickySessionArray.count;
}

- (NSUInteger) normalSessionNum {
    return self.sessionArray.count;
}

- (NSString *) getStickySessionIndexAt: (int)position{
    return [self.stickySessionArray objectAtIndex:position];
}

- (NSString *) getNormalSessionIndexAt: (int)position{
    return [self.sessionArray objectAtIndex:position];
}

- (BOOL) hasSession:(NSString *)sessionName {
    if ([self.sessionArray indexOfObject:sessionName] != NSNotFound) {
        return YES;
    }
    if ([self.stickySessionArray indexOfObject:sessionName] != NSNotFound) {
        return YES;
    }
    return NO;
}

- (void) renameSession:(NSString *)oldName to:(NSString *) newName {
    if ([self.stickySessionArray indexOfObject:oldName]!= NSNotFound) {
        [self.stickySessionArray setObject:newName atIndexedSubscript:[self.stickySessionArray indexOfObject:oldName]];
        RubiksTimerDataProcessing *dataProcessor = [RubiksTimerSessionManager getCurrentSessionfromName:oldName];
        dataProcessor.sessionName = newName;
        [dataProcessor storeIntoFile];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *fileName = [[path objectAtIndex:0] stringByAppendingPathComponent:[@"timeProcess_" stringByAppendingString:oldName]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:fileName error:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([[defaults objectForKey:@"currentSession"] isEqualToString:oldName]){
            [defaults setObject:newName forKey:@"currentSession"];
            self.currentSession = newName;
        }
        
        
    } else if ([self.sessionArray indexOfObject:oldName]!= NSNotFound) {
        [self.sessionArray setObject:newName atIndexedSubscript:[self.sessionArray indexOfObject:oldName]];
        RubiksTimerDataProcessing *dataProcessor = [RubiksTimerSessionManager getCurrentSessionfromName:oldName];
        dataProcessor.sessionName = newName;
        [dataProcessor storeIntoFile];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *fileName = [[path objectAtIndex:0] stringByAppendingPathComponent:[@"timeProcess_" stringByAppendingString:oldName]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:fileName error:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([[defaults objectForKey:@"currentSession"] isEqualToString:oldName]){
            [defaults setObject:newName forKey:@"currentSession"];
            self.currentSession = newName;
        }
        
    } else
        return;
}

- (void)moveObjectFrom:(NSIndexPath *)from toIndexPath:(NSIndexPath *)to {
    if (from.section == to.section && from.section == 1) {
        if (from.row != to.row) {
            id obj = [self.sessionArray objectAtIndex:from.row];
            [self.sessionArray removeObjectAtIndex:from.row];
            if (to.row >= [self.sessionArray count]) {
                [self.sessionArray addObject:obj];
            } else {
                [self.sessionArray insertObject:obj atIndex:to.row];
            }
        }
    } else if (from.section == to.section && from.section == 0) {
        if (from.row != 0 && to.row != 0) {
            if (from.row != to.row) {
                id obj = [self.stickySessionArray objectAtIndex:from.row];
                [self.stickySessionArray removeObjectAtIndex:from.row];
                if (to.row >= [self.stickySessionArray count]) {
                    [self.stickySessionArray addObject:obj];
                } else {
                    [self.stickySessionArray insertObject:obj atIndex:to.row];
                }
            }
        }
    } else if (from.section != to.section) {
        if (from.section == 0) {
            if (from.row != 0) {
                id obj = [self.stickySessionArray objectAtIndex:from.row];
                [self.stickySessionArray removeObjectAtIndex:from.row];
                if (to.row >= [self.sessionArray count]) {
                    [self.sessionArray addObject:obj];
                } else {
                    [self.sessionArray insertObject:obj atIndex:to.row];
                }
            }
        } else if (to.section == 0) {
            if (to.row != 0) {
                id obj = [self.sessionArray objectAtIndex:from.row];
                [self.sessionArray removeObjectAtIndex:from.row];
                if (to.row >= [self.stickySessionArray count]) {
                    [self.stickySessionArray addObject:obj];
                } else {
                    [self.stickySessionArray insertObject:obj atIndex:to.row];
                }
            }
        }
    }
}

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    if (to != from) {
        id obj = [self.sessionArray objectAtIndex:from];
        [self.sessionArray removeObjectAtIndex:from];
        if (to >= [self.sessionArray count]) {
            [self.sessionArray addObject:obj];
        } else {
            [self.sessionArray insertObject:obj atIndex:to];
        }
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.sessionArray forKey:@"sessionArray"];
    [aCoder encodeObject:self.stickySessionArray forKey:@"stickySessionArray"];
    [aCoder encodeObject:self.currentSession forKey:@"currentSession"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super init]) {
        self.sessionArray = [aDecoder decodeObjectForKey:@"sessionArray"];
        self.stickySessionArray = [aDecoder decodeObjectForKey:@"stickySessionArray"];
        self.currentSession = [aDecoder decodeObjectForKey:@"currentSession"];
    }
    return self;
}

- (void)storeIntoFile {
    for (int i = 0; i<self.sessionArray.count; i++) {
        [[RubiksTimerDataProcessing getFromFileByName:[self.sessionArray objectAtIndex:i]] storeIntoFile];
    }
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[path objectAtIndex:0] stringByAppendingPathComponent:@"sessions"];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:@"sessionManager"];
    //[archiver encodeObject:self forKey:@"timeProcessingObj"];
    [archiver finishEncoding];
    
    if ([data writeToFile:fileName atomically:YES]) {
        NSLog(@"Store sessionManager");
    }
}

+ (RubiksTimerSessionManager *)getFromFile {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[path objectAtIndex:0] stringByAppendingPathComponent:@"sessions"];
    RubiksTimerSessionManager *sessionManager = [[RubiksTimerSessionManager alloc] init];
    NSData *data = [[NSData alloc] initWithContentsOfFile:fileName];
    if (data) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        sessionManager = [unarchiver decodeObjectForKey:@"sessionManager"];
        [unarchiver finishDecoding];
        //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //sessionManager.currentSession = [defaults stringForKey:@"currentSession"];
        NSLog(@"Get sessionManager");
        return sessionManager;
    }
    else {
        NSLog(@"sessionManager not exit");
        return sessionManager;
    }
}

@end
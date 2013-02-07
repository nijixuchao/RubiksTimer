//
//  RubiksTimerSessionManager.h
//  ChaoTimer
//
//  Created by Jichao Li on 12/1/12.
//  Copyright (c) 2012 Jichao Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RubiksTimerDataProcessing.h"

@interface RubiksTimerSessionManager : NSObject
@property (nonatomic, strong) NSMutableArray *sessionArray;
@property (nonatomic, strong) NSMutableArray *stickySessionArray;
@property (nonatomic, strong) NSString *currentSession;

+ (RubiksTimerDataProcessing *) getCurrentSessionfromName:(NSString *)name;
- (void) addSesion:(NSString *)addName;
//- (void) removeSession:(NSString *)removeName;
- (void) removeStickySessionAtIndex:(int) index;
- (void) removeNormalSessionAtIndex:(int) index;
- (NSUInteger) stickySessionNum;
- (NSUInteger) normalSessionNum;
- (NSString *) getStickySessionIndexAt: (int)position;
- (NSString *) getNormalSessionIndexAt: (int)position;
- (BOOL) hasSession:(NSString *)sessionName;
- (void) renameSession:(NSString *)oldName to:(NSString *) newName;
//- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;
- (void)moveObjectFrom:(NSIndexPath *)from toIndexPath:(NSIndexPath *)to;
- (void)storeIntoFile;
+ (RubiksTimerSessionManager *)getFromFile;
@end

//
//  Scrambler.m
//  RubiksTimer
//
//  Created by Jichao Li on 5/30/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import "Scrambler.h"
#import "Scramble222.h"
#import "ScrambleSQ1.h"
#import "ScramblePyraminx.h"
#import "Scramble333.h"
#import "time.h"
#import "CTScrambleManager.h"

@interface Scrambler ()
@property (nonatomic, strong) Scramble222 *scramble222;
@property (nonatomic, strong) ScramblePyraminx *scramblePyra;
@property (nonatomic, strong) ScrambleSQ1 *scrambleSq1;
@property (nonatomic, strong) Scramble333 *scramble333;
@property (nonatomic, strong) CTScrambleManager *scrambleManager;
@end


@implementation Scrambler
@synthesize scramble222 = _scramble222;
@synthesize scramblePyra = _scramblePyra;
@synthesize scrambleSq1 = _scrambleSq1;
@synthesize scramble333 = _scramble333;
@synthesize scrambleManager = _scrambleManager;

- (NSString *)scrambleNNNWithFaces: (NSArray *)faces Suffix: (NSArray *)suffix andLength: (int)length {
    NSString *result = [[NSString alloc] init];
    int a = -1; int b = -1; int j;
    srand((unsigned)time(NULL));
    while (length > 0) {
        j = rand() % faces.count;
        if ((j % 3 != b % 3) && (j != a)) {
            NSString *new = [[[faces objectAtIndex:j] stringByAppendingString:[suffix objectAtIndex:(rand() % suffix.count)]] stringByAppendingString:@" "];
            result = [result stringByAppendingString:new];
            a = b;
            b = j;
            length--;
        }
    }
    return result;
}

- (NSString *)scrambleTwoGenWithGen1: (NSString *)gen1 Gen2: (NSString *)gen2 andLength: (int)length{
    NSArray *faces = [[NSArray alloc] initWithObjects:gen1, gen2, nil];
    NSArray *suffix = [[NSArray alloc] initWithObjects:@"", @"'", @"2", nil];
    int j = 0;
    srand((unsigned)time(NULL));
    NSString *result = [[NSString alloc] init];
    while (length-- > 0) {
        NSString *new = [[[faces objectAtIndex:j] stringByAppendingString:[suffix objectAtIndex:(rand() % suffix.count)]] stringByAppendingString:@" "];
        result = [result stringByAppendingString:new];
        j = 1 - j;
    }
    return result;
}

- (NSString *)scrambleClock {
    NSArray *pins = [[NSArray alloc] initWithObjects:@"U", @"d", nil];
    NSString *result = @"";
    srand((unsigned)time(NULL));
    for (int i = 0; i < 4; i++) {
        NSString *new = [[[[@"(" stringByAppendingFormat:[NSString stringWithFormat:@"%d", (rand() % 12 - 5)]] stringByAppendingString:@", "] stringByAppendingString:[NSString stringWithFormat:@"%d", (rand() % 12 - 5)]] stringByAppendingString:@") / " ];
        result = [result stringByAppendingString:new];
    }
    for (int i = 0; i < 6; i++) {
        NSString *new = [[@"(" stringByAppendingFormat:[NSString stringWithFormat:@"%d", (rand() % 12 - 5)]] stringByAppendingString:@") / "]; 
        result = [result stringByAppendingString:new];
    }
    for (int i = 0; i < 4; i++) {
        int j = rand() % 2;
        result = [result stringByAppendingString:[pins objectAtIndex:j]];
    }
    return result;
}

- (NSString *)scrambleMegaminx {
    NSArray *faces = [[NSArray alloc] initWithObjects:@"R", @"D", nil];
    NSArray *suffix1 = [[NSArray alloc] initWithObjects:@"++", @"--", nil];
    NSArray *suffix2 = [[NSArray alloc] initWithObjects:@"", @"'", nil];
    int j = 0;
    NSString *result = @"";
    srand((unsigned)time(NULL));
    for (int i = 0; i < 7; i++) {
        int length = 10;
        while (length-- > 0) {
            NSString *new = [[[faces objectAtIndex:j] stringByAppendingFormat:[suffix1 objectAtIndex:(rand() % 2)]] stringByAppendingString:@" "];
            result = [result stringByAppendingString:new];
            j = 1 - j;
        }
        result = [[[result stringByAppendingString:@"U"] stringByAppendingString:[suffix2 objectAtIndex:(rand() %2)]] stringByAppendingFormat:@"\n"];
    }
    return result;
    
}

- (NSString *)scrambleTwoByTwo {
    if (!_scramble222) {
        self.scramble222 =[[Scramble222 alloc] init];
        //NSLog(@"new!");
    }
    //NSLog(@"scramble");
    return [self.scramble222 scramble];
}

- (NSString *)scrambleSquareOne {
    if (!_scrambleSq1) {
        self.scrambleSq1 = [[ScrambleSQ1 alloc] init];
    }
    return [self.scrambleSq1 scramble];
}

- (NSString *)scramblePyraminx {
    if (!_scramblePyra) {
        self.scramblePyra =[[ScramblePyraminx alloc] init];
    }
    return [self.scramblePyra scramble];
}

- (NSString *)scrambleThreeByThree {
    if (!_scramble333) {
        self.scramble333 =[[Scramble333 alloc] init];
    }
    return [self.scramble333 scramble];
}


- (NSString *)generateScrambleString: (NSString *)type{
    NSString *scramble;
    _scrambleManager = [CTScrambleManager sharedScrambleManager];
    if ([type isEqualToString:@"2x2random state"]) {
        scramble = [self scrambleTwoByTwo];
    } else if ([type isEqualToString:@"2x23-gen"]) {
        NSArray *faces = [[NSArray alloc] initWithObjects:@"U", @"R", @"F", nil];
        NSArray *suffix = [[NSArray alloc] initWithObjects:@"", @"'", @"2", nil];
        scramble = [self scrambleNNNWithFaces:faces Suffix:suffix andLength:15];
    } else if ([type isEqualToString:@"2x26-gen"]) {
        NSArray *faces = [[NSArray alloc] initWithObjects:@"U", @"R", @"F", @"D", @"L", @"B", nil];
        NSArray *suffix = [[NSArray alloc] initWithObjects:@"", @"'", @"2", nil];
        scramble = [self scrambleNNNWithFaces:faces Suffix:suffix andLength:15];
    } else if ([type isEqualToString:@"3x3random state"]) {
        
        scramble = [_scrambleManager scrambleForPuzzleType:@"3x3" competitionLength:NO];
    
    } else if ([type isEqualToString:@"3x3old style"]) {
        NSArray *faces = [[NSArray alloc] initWithObjects:@"U", @"R", @"F", @"D", @"L", @"B", nil];
        NSArray *suffix = [[NSArray alloc] initWithObjects:@"", @"'", @"2", nil];
        scramble = [self scrambleNNNWithFaces:faces Suffix:suffix andLength:25];
    } else if ([type isEqualToString:@"4x4WCA"]) {
        NSArray *faces = [[NSArray alloc] initWithObjects:@"U", @"R", @"F", @"D", @"L", @"B", @"Uw", @"Rw", @"Fw", nil];
        NSArray *suffix = [[NSArray alloc] initWithObjects:@"", @"'", @"2", nil];
        scramble = [self scrambleNNNWithFaces:faces Suffix:suffix andLength:40];
    } else if ([type isEqualToString:@"4x4SiGN"]) {
        NSArray *faces = [[NSArray alloc] initWithObjects:@"U", @"R", @"F", @"D", @"L", @"B", @"u", @"r", @"f", nil];
        NSArray *suffix = [[NSArray alloc] initWithObjects:@"", @"'", @"2", nil];
        scramble = [self scrambleNNNWithFaces:faces Suffix:suffix andLength:40];
    } else if ([type isEqualToString:@"5x5WCA"]) {
        NSArray *faces = [[NSArray alloc] initWithObjects:@"U", @"R", @"F", @"D", @"L", @"B", @"Uw", @"Rw", @"Fw", @"Dw", @"Lw", @"Bw", nil];
        NSArray *suffix = [[NSArray alloc] initWithObjects:@"", @"'", @"2", nil];
        scramble = [self scrambleNNNWithFaces:faces Suffix:suffix andLength:60];
    } else if ([type isEqualToString:@"5x5SiGN"]) {
        NSArray *faces = [[NSArray alloc] initWithObjects:@"U", @"R", @"F", @"D", @"L", @"B", @"u", @"r", @"f", @"d", @"l", @"b", nil];
        NSArray *suffix = [[NSArray alloc] initWithObjects:@"", @"'", @"2", nil];
        scramble = [self scrambleNNNWithFaces:faces Suffix:suffix andLength:60];
    } else if ([type isEqualToString:@"6x6prefix"]) {
        NSArray *faces = [[NSArray alloc] initWithObjects:@"U", @"R", @"F", @"D", @"L", @"B", @"2U", @"2R", @"2F", @"2D", @"2L", @"2B", @"3U", @"3R", @"3F", @"3D", @"3L", @"3B", nil];
        NSArray *suffix = [[NSArray alloc] initWithObjects:@"", @"'", @"2", nil];
        scramble = [self scrambleNNNWithFaces:faces Suffix:suffix andLength:80];
    } else if ([type isEqualToString:@"6x6SiGN"]) {
        NSArray *faces = [[NSArray alloc] initWithObjects:@"U", @"R", @"F", @"D", @"L", @"B", @"2u", @"2r", @"2f", @"3u", @"3r", @"3f", nil];
        NSArray *suffix = [[NSArray alloc] initWithObjects:@"", @"'", @"2", nil];
        scramble = [self scrambleNNNWithFaces:faces Suffix:suffix andLength:80];
    } else if ([type isEqualToString:@"7x7prefix"]) {
        NSArray *faces = [[NSArray alloc] initWithObjects:@"U", @"R", @"F", @"D", @"L", @"B", @"2U", @"2R", @"2F", @"2D", @"2L", @"2B", @"3U", @"3R", @"3F", @"3D", @"3L", @"3B", nil];
        NSArray *suffix = [[NSArray alloc] initWithObjects:@"", @"'", @"2", nil];
        scramble = [self scrambleNNNWithFaces:faces Suffix:suffix andLength:100];
    } else if ([type isEqualToString:@"7x7SiGN"]) {
        NSArray *faces = [[NSArray alloc] initWithObjects:@"U", @"R", @"F", @"D", @"L", @"B", @"2u", @"2r", @"2f", @"2d", @"2l", @"2b", @"3u", @"3r", @"3f", @"3d", @"3l", @"3b", nil];
        NSArray *suffix = [[NSArray alloc] initWithObjects:@"", @"'", @"2", nil];
        scramble = [self scrambleNNNWithFaces:faces Suffix:suffix andLength:80];
    } else if ([type isEqualToString:@"3x3 subsets2-gen<M,U>"]) {
        scramble = [self scrambleTwoGenWithGen1:@"M" Gen2:@"U" andLength:25];
    } else if ([type isEqualToString:@"3x3 subsets2-gen<R,U>"]) {
        scramble = [self scrambleTwoGenWithGen1:@"R" Gen2:@"U" andLength:25];
    } else if ([type isEqualToString:@"MegaminxPochmann"]) {
        scramble = [self scrambleMegaminx];
    } else if ([type isEqualToString:@"Square-1twist metric"]) {
        //scramble = [_scrambleManager scrambleForPuzzleType:@"SQ" competitionLength:NO];
        scramble = [self scrambleSquareOne];
    } else if ([type isEqualToString:@"Clockconcise"]) {
        scramble = [self scrambleClock];
    } else if ([type isEqualToString:@"Pyraminxrandom state"]) {
        scramble = [self scramblePyraminx];
    } else if ([type isEqualToString:@"ls"]) {
        
        
    } else if ([type isEqualToString:@"k4"]) {
        
        
    } else if ([type isEqualToString:@"ll"]) {
        
        
    } else if ([type isEqualToString:@"zb"]) {
        
        
    } else if ([type isEqualToString:@"Skewb<U,L,R,B>"]) {
        NSArray *faces = [[NSArray alloc] initWithObjects:@"U", @"R", @"B", @"L", nil];
        NSArray *suffix = [[NSArray alloc] initWithObjects:@"", @"'", nil];
        scramble = [self scrambleNNNWithFaces:faces Suffix:suffix andLength:25];
    }


    
    
    return scramble;
}




@end

//
//  ScramblePyraminx.m
//  RubiksTimer
//
//  Created by Jichao Li on 5/31/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import "ScramblePyraminx.h"
#import "stdlib.h"
#import "time.h"

@interface ScramblePyraminx ()

@end

@implementation ScramblePyraminx

int positorig[36] = {0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3};
int posit[36];
int perm[720];
int permmv[720][4];
int twst[2592];
int twstmv[2592][4];
int pcperm[6] = {0, 1, 2, 3, 4, 5}; 
int pcori[10];

NSArray *face;
NSArray *suf;
NSArray *tips;
NSMutableArray *sol;

- (ScramblePyraminx *)init {
    if (self = [super init]) {
        [self initialise];
        face = [[NSArray alloc] initWithObjects:@"U", @"L", @"R", @"B", nil];
        suf = [[NSArray alloc] initWithObjects:@"'", @"", nil];
        tips = [[NSArray alloc] initWithObjects:@"l", @"r", @"b", @"u", nil];
        sol = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)scramble {
    srand((unsigned)time(NULL));
    [self initbrd];
    [self dosolve];
    
    NSString *scramble = @"";
    for (int i = 0; i < sol.count; i++) {
        //scramble += faces[sol.get(i) & 7] + suf[(sol.get(i) & 8) / 8] + " ";
        NSString *temp1 = [face objectAtIndex:([[sol objectAtIndex:i] intValue]&7)];
        NSString *temp2 = [suf objectAtIndex:(([[sol objectAtIndex:i] intValue]&8)/8)];
        scramble = [[[scramble stringByAppendingString:temp1] stringByAppendingString:temp2] stringByAppendingString:@" "];
    }
    for (int i = 0; i < 4; i++) {
        //int j = rand.nextInt(3);
        int j = rand() % 3;
        if (j < 2) 
            scramble = [[[scramble stringByAppendingString:[tips objectAtIndex:i]]stringByAppendingString:[suf objectAtIndex:j]] stringByAppendingString:@" "];
            
            //scramble += tips[i] + suf[j] + " ";
    }
    
    return scramble;
}

- (void) dosolve {
    srand((unsigned)time(NULL));
    int t = 0; int q = 0; BOOL parity = NO;
    int pcperm[] = {0, 1, 2, 3, 4, 5, 6};
    for (int i = 0; i < 4; i++) {
        int other = i + rand() % (6 - i);
        int temp = pcperm[i];
        pcperm[i] = pcperm[other];
        pcperm[other] = temp;
        if (i != other) parity = !parity;
    }
    if (parity) {
        int temp = pcperm[4];
        pcperm[4] = pcperm[5];
        pcperm[5] = temp;
    }
    parity = NO;
    int pcori[10];
    for (int i = 0; i < 5; i++) {
        pcori[i] = rand() % 2;
        if (pcori[i] == 1) parity = !parity;
    }
    if (parity == YES) {
        pcori[5] = 1;
    } else {
        pcori[5] = 0;
    }
    //pcori[5] = (parity ? YES : NO);
    for (int i = 6; i < 10; i++) {
        pcori[i] = rand() % 3;
    }
    for (int a = 0; a < 6; a++) {
        int b = 0;
        for (int c = 0; c < 6; c++) {
            if (pcperm[c] == a) break;
            if (pcperm[c] > a) b++;
        }
        q = q * (6 - a) + b;
    }
    for (int a = 9; a >= 6; a--) {
        t = t * 3 + pcori[a];
    }
    for (int a = 4; a >= 0; a--) {
        t = t * 2 + pcori[a];
    }
    if (q != 0 || t != 0) {
        for (int l = 7; l < 12; l++) {
            if ([self Search:q t:t l:l lm:-1]) break;
        }
    }
}

- (BOOL) Search: (int)q t:(int)t l:(int)l lm:(int)lm{
    //NSLog(@"%@", [NSString stringWithFormat:@"q:%d t:%d l:%d, lm:%d", q,t,l,lm]);
    if (l == 0) {
        if (q == 0 && t == 0) return true;
    }
    else {
        if (perm[q] > l || twst[t] > l) return false;
        int p, s, a, m;
        for (m = 0; m < 4; m++) {
            if (m != lm) {
                p = q;
                s = t;
                for (a = 0; a < 2; a++) {
                    //NSLog(@"%@", [NSString stringWithFormat:@"m1: %d", m]);
                    p = permmv[p][m];
                    s = twstmv[s][m];
                    [sol addObject:[NSNumber numberWithInt:(m + 8 * a)]];
                    //sol.add(m + 8 * a);
                    if ([self Search:p t:s l:(l-1) lm:m]) 
                        return true;
                    [sol removeLastObject];
                    //sol.remove(sol.size() - 1);
                }
            }
        }
    }	    
    return false;
}

- (void) initialise {
    [self calcperm];
}

- (void) calcperm {
    for (int p = 0; p < 720; p++) {
        perm[p] = -1;
        //permmv[p] = new int[4];
        for (int m = 0; m < 4; m++) {
            permmv[p][m] = [self getprmmv:p m:m];
        }
    }
    perm[0] = 0;
    for (int l = 0; l <= 6; l++) {
        int n = 0;
        for (int p = 0; p < 720; p++) {
            if (perm[p] == l) {
                for (int m = 0; m < 4; m++) {
                    int q = p;
                    for (int c = 0; c < 2; c++) {
                        q = permmv[q][m];
                        if (perm[q] == -1) {
                            perm[q] = l + 1;
                            n++;
                        }
                    }
                }
            }
        }
    }
    for (int p = 0; p < 2592; p++) {
        twst[p] = -1;
        //twstmv[p] = new int[4];
        for (int m = 0; m < 4; m++) {
            twstmv[p][m] = [self gettwsmv:p m:m];
        }
    }
    twst[0] = 0;
    for (int l = 0; l <= 5; l++) {
        int n = 0;
        for (int p = 0; p < 2592; p++) {
            if (twst[p] == l) {
                for (int m = 0; m < 4; m++) {
                    int q = p;
                    for (int c = 0; c < 2; c++) {
                        q = twstmv[q][m];
                        if (twst[q] == -1) {
                            twst[q] = l + 1;
                            n++;
                        }
                    }
                }
            }
        }
    }
}

- (int)gettwsmv: (int)p m:(int)m {
    int ps[20];
    int d = 0;
    int q = p;
    for (int a = 0; a <= 4; a++) {
        ps[a] = q & 1;
        q >>= 1;
        d ^= ps[a];
    }
    ps[5] = d;
    for (int a = 6; a <= 9; a++) {
        int c = q / 3;
        int b = q - 3 * c;
        q = c;
        ps[a] = b;
    }
    int c;
    if (m == 0) {
        ps[6]++;
        if (ps[6] == 3) ps[6] = 0;
        c = ps[0];
        ps[0] = ps[3];
        ps[3] = ps[1];
        ps[1] = c;
        //ps = cycle3(ps, 0, 3, 1);
        ps[1] ^= 1;
        ps[3] ^= 1;
    }
    else if (m == 1) {
        ps[7]++;
        if (ps[7] == 3) ps[7] = 0;
        c = ps[1];
        ps[1] = ps[5];
        ps[5] = ps[2];
        ps[2] = c;
        //ps = cycle3(ps, 1, 5, 2);
        ps[2] ^= 1;
        ps[5] ^= 1;
    }
    else if (m == 2) {
        ps[8]++;
        if (ps[8] == 3) ps[8] = 0;
        c = ps[0];
        ps[0] = ps[2];
        ps[2] = ps[4];
        ps[4] = c;
        //ps = cycle3(ps, 0, 2, 4);
        ps[0] ^= 1;
        ps[2] ^= 1;
    }
    else if (m == 3) {
        ps[9]++;
        if (ps[9] == 3) ps[9] = 0;
        c = ps[3];
        ps[3] = ps[4];
        ps[4] = ps[5];
        ps[5] = c;
        //ps = cycle3(ps, 3, 4, 5);
        ps[3] ^= 1;
        ps[4] ^= 1;
    }
    q = 0;
    for (int a = 9; a >= 6; a--) {
        q = q * 3 + ps[a];
    }
    for (int a = 4; a >= 0; a--) {
        q = q * 2 + ps[a];
    }
    return q;
}

- (int) getprmmv: (int)p m:(int)m  {
    int ps[20];
    int q = p;
    for (int a = 1; a <= 6; a++) {
        int c = q / a;
        int b = q - (a * c);
        q = c;
        for (c = a - 1; c >= b; c--) {
            ps[c + 1] = ps[c];
        }
        ps[b] = 6 - a;
    }
    int c;
    if (m == 0) {
        c = ps[0];
        ps[0] = ps[3];
        ps[3] = ps[1];
        ps[1] = c;
    }//ps = cycle3(ps, 0, 3, 1);
    else if (m == 1) {
        c = ps[1];
        ps[1] = ps[5];
        ps[5] = ps[2];
        ps[2] = c;
    }//ps = cycle3(ps, 1, 5, 2);
    else if (m == 2) {
        c = ps[0];
        ps[0] = ps[2];
        ps[2] = ps[4];
        ps[4] = c;
    }//ps = cycle3(ps, 0, 2, 4);
    else if (m == 3) {
        c = ps[3];
        ps[3] = ps[4];
        ps[4] = ps[5];
        ps[5] = c;
    }//ps = cycle3(ps, 3, 4, 5);
    q = 0;
    for (int a = 0; a < 6; a++) {
        int b = 0;
        for (int c = 0; c < 6; c++) {
            if (ps[c] == a) break;
            if (ps[c] > a) b++;
        }
        q = q * (6 - a) + b;
    }
    return q;
}



- (void) initbrd {
    for (int i = 0; i< 36; i++) {
        posit[i] = positorig[i];
    }
    [sol removeAllObjects];
}


@end

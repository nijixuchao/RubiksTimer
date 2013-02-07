//
//  Scramble222.m
//  RubiksTimer
//
//  Created by Jichao Li on 5/30/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import "Scramble222.h"
#import "stdlib.h"
#import "time.h"

@interface Scramble222 ()

@end


@implementation Scramble222

int seqlen = 7;

int perm[5040];
int permmv[5040][3];
int twst[729];
int twstmv[729][3];
int adj[6][6];
int opp[6];
int piece[] = {15,16,16,21,21,15,13,9,9,17,17,13,14,20,20,4,4,14,12,5,5,8,8,12,3,23,23,18,18,3,1,19,19,11,11,1,2,6,6,22,22,2,0,10,10,7,7,0};
int positorigen[24] = {1,1,1,1,2,2,2,2,5,5,5,5,4,4,4,4,3,3,3,3,0,0,0,0};
int posit[24];
NSArray *face;
NSArray *suf;
NSMutableArray *sol;


- (Scramble222 *)init {
    if (self = [super init]) {
        [self initialise];
        face = [[NSArray alloc] initWithObjects:@"U", @"R", @"F", nil];
        suf = [[NSArray alloc] initWithObjects:@"'", @"2", @"", nil];
        sol = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)scramble {
    [self initbrd];
    [self mix];
    [self calcadj];
    
        
    for (int a = 0; a < 6; a++) {
        for (int b = 0; b < 6; b++) {
            if (a != b && adj[a][b] + adj[b][a] == 0) {
                opp[a] = b;
                opp[b] = a;
            }
        }
    }
    int ps[7];
    int tws[7];
    int a = 0;
    for (int d = 0; d < 7; d++) {
        int p = 0;
        for (int b = a; b < a + 6; b += 2) {
            if (posit[piece[b]] == posit[piece[42]]) p += 4;
            if (posit[piece[b]] == posit[piece[44]]) p += 1;
            if (posit[piece[b]] == posit[piece[46]]) p += 2;
        }
        ps[d] = p;
        if (posit[piece[a]] == posit[piece[42]] || posit[piece[a]] == opp[posit[piece[42]]]) tws[d] = 0;
        else if(posit[piece[a+2]] == posit[piece[42]] || posit[piece[a+2]] == opp[posit[piece[42]]]) tws[d]=1;
        else tws[d] = 2;
        a += 6;
    }
    int q = 0;
    for (a = 0; a < 7; a++) {
        int b = 0;
        for (int c = 0; c < 7; c++) {
            if (ps[c] == a) break;
            if (ps[c] > a) b++;
        }
        q = q * (7 - a) + b;
    }
    int t = 0;
    for (a = 5; a >= 0; a--) {
        t = t*3 + tws[a] - 3*(tws[a]/3);
    }
    if (q != 0 || t != 0) {
        [sol removeAllObjects];
        //sol.clear();
        for (int l = seqlen; l < 100; l++) {
            //if (search (0, q, t, l, -1)) break;
            if ([self Search:0 q:q t:t l:l lm:-1]) 
                break;
            
        }
        
        
        NSString *s = @"";
        //String s = "";
        for (q = 0; q < sol.count; q++) {
            //NSLog(@"%@", [NSString stringWithFormat: @"%d", [[sol objectAtIndex:q] intValue] ]);
            NSString *temp1 = [face objectAtIndex:([[sol objectAtIndex:q] intValue]/10)];
            NSString *temp2 = [suf objectAtIndex:([[sol objectAtIndex:q] intValue]%10)];
            s = [[[temp1 stringByAppendingString:temp2] stringByAppendingString:@" "] stringByAppendingString:s];
            // s = face[sol.get(q)/10] + suf[sol.get(q)%10] + " " + s;
            //NSLog(@"%@", s);
        }
        return s;
    }
    return @"...";
}

- (BOOL) Search: (int)d q:(int)q t:(int)t l:(int)l lm:(int)lm {
    //NSLog(@"%@", [NSString stringWithFormat:@"d:%d q:%d t:%d l:%d, lm:%d", d,q,t,l,lm]);
    if (l == 0) {
        if (q == 0 && t == 0) {
            return true;
        }
    }
    else {
        if (perm[q] > l || twst[t] > l) return false;
        int p,s,a,m;
        for (m = 0; m < 3; m++) {
            //NSLog(@"%@", [NSString stringWithFormat:@"m1: %d", m]);
            if (m != lm) {
                p = q; s = t;
                for (a = 0; a < 3; a++) {
                    p = permmv[p][m];
                    s = twstmv[s][m];
                    [sol addObject:[NSNumber numberWithInt:(10 * m + a)]];
                    if ([self Search:(d+1) q:p t:s l:(l-1) lm:m]) 
                        return true;
                    [sol removeLastObject];
                }
            }
        }
        return false;
    }
    return false;
}

- (void) mix {
    srand((unsigned)time(NULL));
    int fixed = 6;
    int perm_src[] = {0, 1, 2, 3, 4, 5, 6, 7};
    int perm_sel[8];
    
    for (int i = 0; i < 7; i++) {
        //int ch = rand.nextInt(7 - i);
        int ch = rand() % (7 - i);
        //NSLog(@"%@", [NSString stringWithFormat:@"%d", ch]);
        ch = (perm_src[ch] == fixed) ? (ch + 1) % (8 - 1) : ch;
        perm_sel[(i >= fixed) ? i + 1 : i] = perm_src[ch];
        perm_src[ch] = perm_src[7 - i];
    }
    perm_sel[fixed] = fixed;
    int total = 0;
    int ori_sel[8];
    int i = (fixed == 0) ? 1 : 0;
    for (; i < 7; i = (i == fixed - 1) ? i + 2 : i + 1) {
        //ori_sel[i] = rand.nextInt(3);
        ori_sel[i] = rand() % 3;
        //NSLog(@"%@", [NSString stringWithFormat:@"%d", ori_sel]);
        total += ori_sel[i];
    }
    if (i <= 7) ori_sel[i] = (3 - (total % 3)) % 3;
    ori_sel[fixed] = 0;
    int D = 1; int L = 2; int B = 5; int U = 4; int R = 3; int F = 0;
    int fmap[8][3] = {{U,R,F}, {U,B,R}, {U,L,B}, {U,F,L}, {D,F,R}, {D,R,B}, {D,B,L}, {D,L,F}};
    int pos[8][3] = {{15,16,21},{13,9,17},{12,5,8},{14,20,4},{3,23,18},{1,19,11},{0,10,7},{2,6,22}};
    for (i = 0; i < 8; i++) {
        for (int j = 0; j < 3; j++) {
            posit[pos[i][(ori_sel[i] + j) % 3]] = fmap[perm_sel[i]][j];
        }
    }
}

- (void) initialise {
    [self calcperm];
}

- (void) calcperm {
    for (int p = 0; p < 5040; p++) {
        perm[p] = -1;
        for (int m = 0; m < 3; m++) {
            //permmv[p][m] = getprmmv(p, m);
            permmv[p][m] = [self getprmmv:p m:m];
        }
    }
    perm[0] = 0;
    for (int l = 0; l <= 6; l++) {
        int n = 0;
        for (int p = 0; p < 5040; p++) {
            if (perm[p] == l) {
                for (int m = 0; m < 3; m++) {
                    int q = p;
                    for (int c = 0; c < 3; c++) {
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
    for (int p = 0; p < 729; p++) {
        twst[p] = -1;
        for (int m = 0; m < 3; m++) {
            //twstmv[p][m] = gettwsmv(p, m);
            twstmv[p][m] = [self gettwsmv:p m:m];
        }
    }
    twst[0] = 0;
    for (int l = 0; l <= 5; l++) {
        int n = 0;
        for (int p = 0; p < 729; p++) {
            if (twst[p] == l) {
                for (int m = 0; m < 3; m++) {
                    int q = p;
                    for (int c = 0; c < 3; c++) {
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
     //NSLog(@"gettwsmmv");
    int ps[7];
    int q = p; int d = 0;
    for (int a = 0; a <= 5; a++) {
        int c = q / 3;
        int b = q - 3 * c;
        q = c;
        ps[a] = b;
        d -= b;
        if (d < 0) d += 3;
    }
    ps[6] = d;
    int c;
    if (m == 0) {
        c = ps[0];
        ps[0] = ps[1];
        ps[1] = ps[3];
        ps[3] = ps[2];
        ps[2] = c;
    }
    else if (m == 1) {
        c = ps[0];
        ps[0] = ps[4];
        ps[4] = ps[5];
        ps[5] = ps[1];
        ps[1] = c;
        ps[0] += 2; 
        ps[1]++; 
        ps[5] += 2; 
        ps[4]++;
    }
    else if (m == 2) {
        c = ps[0];
        ps[0] = ps[2];
        ps[2] = ps[6];
        ps[6] = ps[4];
        ps[4] = c;
        ps[2] += 2; 
        ps[0]++; 
        ps[4] +=2 ; 
        ps[6]++;
    }
    q = 0;
    for (int a = 5; a >= 0; a--) {
        q = q * 3 + (ps[a] % 3);
    }
    return q;
}

- (int) getprmmv: (int)p m:(int)m {
    //NSLog(@"getprmmv");
    int ps[8];
    int q = p;
    for (int a = 1; a <= 7; a++) {
        int b = q % a;
        q = (q - b)/a;
        for (int c = a - 1; c >= b; c--) {
            ps[c + 1] = ps[c];
        }
        ps[b] = 7 - a;
    }
    int c;
    if (m == 0) {
        c = ps[0];
        ps[0] = ps[1];
        ps[1] = ps[3];
        ps[3] = ps[2];
        ps[2] = c;
    }
    else if(m == 1) {
        c = ps[0];
        ps[0] = ps[4];
        ps[4] = ps[5];
        ps[5] = ps[1];
        ps[1] = c;
    }
    else if (m == 2) {
        c = ps[0];
        ps[0] = ps[2];
        ps[2] = ps[6];
        ps[6] = ps[4];
        ps[4] = c;
    }
    q = 0;
    for (int a = 0; a < 7; a++) {
        int b = 0;
        for (c = 0; c < 7; c++) {
            if (ps[c] == a) break;
            if (ps[c] > a) b++;
        }
        q = q * (7 - a) + b;
        //NSLog(@"%@", [NSString stringWithFormat:@"mv q: %d", q]);
    }
    return q;
}

- (void) calcadj{
     //NSLog(@"calcadj");
    for (int a = 0; a < 6; a++) for (int b = 0; b < 6; b++) adj[a][b] = 0;;
    for (int a = 0; a < 48; a+= 2) {
        if (posit[piece[a]] <= 5 && posit[piece[a+1]] <= 5) {
            adj[posit[piece[a]]][posit[piece[a+1]]]++;
            
        }
    }
}


- (void) initbrd {
    for (int i = 0; i< 24; i++) {
        posit[i] = positorigen[i];
    }
}

@end

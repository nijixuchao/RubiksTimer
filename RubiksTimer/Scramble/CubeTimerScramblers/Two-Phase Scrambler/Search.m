//
//  Search.m
//  CubeTimer Scramblers
//
//  Adapted from Shuang Chen's min2phase implementation of the Kociemba algorithm, as obtained from https://github.com/ChenShuang/min2phase
//
//  Copyright (c) 2011, Shuang Chen
//  All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  Neither the name of the creator nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "CubieCube.h"
#import "CoordCube.h"
#import "Util.h"
#import "Sys/time.h"

static int move[31];

static int corn[20];
static int mid4[20];
static int ud8e[20];

static int twist[6];
static int flip[6];
static int slice[6];

static int corn0[6];
static int ud8e0[6];
static int prun[6];

static int f[54];

static int urfIdx;
static int depth1;
static int maxDep2;
static int sol;
static int valid1;
static int valid2;
NSString* solution;
static long timeOut;
static long timeMin;
static int verbose;
CubieCube *cc = nil;

NSArray *move2str;
extern int urfMove[6][18];
extern int MtoEPerm[];

extern int UDSliceMove[495][18];
extern int TwistMove[324][18];
extern int FlipMove[336][18];
extern int UDSliceConj[495][8];
extern int UDSliceTwistPrun[495 * 324 / 8 + 1];
extern int UDSliceFlipPrun[495 * 336 / 8];
//extern int TwistFlipPrun[336 * 324 * 8 / 8];


extern int SymInv[16];
extern int SymMult[16][16];
extern int SymMove[16][18];
extern int Sym8Mult[8][8];
extern int Sym8Move[8][18];
extern int SymMultInv[8][8];
extern int SymMoveUD[16][10];
extern int SymInv[16];
extern int FlipS2R[336];
extern int TwistS2R[324];
extern int EPermS2R[2768];
extern int permMult[24][24];
extern int Sym8MultInv[8][8];
extern int SymMoveUD[16][10];
extern int SymStateTwist[324];
extern int SymStateFlip[336];
extern int SymStatePerm[2768];

extern int CPermMove[2768][18];
extern int EPermMove[2768][10];
extern int MPermMove[24][10];
extern int MPermConj[24][16];
extern int MCPermPrun[24 * 2768 / 8];
extern int MEPermPrun[24 * 2768 / 8];

extern int std2ud[18];
extern int ud2std[];
extern BOOL ckmv2[11][10];

static unsigned long getMStime(void) { struct timeval time; gettimeofday(&time, NULL); return (time.tv_sec * 1000) + (time.tv_usec / 1000); }


/**
 *     Verbose_Mask determines if a " . " separates the phase1 and phase2 parts of the solver string like in F' R B R L2 F .
 *     U2 U D for example.<br>
 */
const int USE_SEPARATOR = 0x1;

/**
 *     Verbose_Mask determines if the solution will be inversed to a scramble/state generator.
 */
const int INVERSE_SOLUTION = 0x2;

/**
 *     Verbose_Mask determines if a tag such as "(21f)" will be appended to the solution.
 */
const int APPEND_LENGTH = 0x4;

/**
 * Computes the solver string for a given cube.
 *
 * @param facelets
 * 		is the cube definition string format.<br>
 * The names of the facelet positions of the cube:
 * <pre>
 *             |************|
 *             |*U1**U2**U3*|
 *             |************|
 *             |*U4**U5**U6*|
 *             |************|
 *             |*U7**U8**U9*|
 *             |************|
 * ************|************|************|************|
 * *L1**L2**L3*|*F1**F2**F3*|*R1**R2**F3*|*B1**B2**B3*|
 * ************|************|************|************|
 * *L4**L5**L6*|*F4**F5**F6*|*R4**R5**R6*|*B4**B5**B6*|
 * ************|************|************|************|
 * *L7**L8**L9*|*F7**F8**F9*|*R7**R8**R9*|*B7**B8**B9*|
 * ************|************|************|************|
 *             |************|
 *             |*D1**D2**D3*|
 *             |************|
 *             |*D4**D5**D6*|
 *             |************|
 *             |*D7**D8**D9*|
 *             |************|
 
 * A cube definition string "UBL..." means for example: In position U1 we have the U-color, in position U2 we have the
 * B-color, in position U3 we have the L color etc. according to the order U1, U2, U3, U4, U5, U6, U7, U8, U9, R1, R2,
 * R3, R4, R5, R6, R7, R8, R9, F1, F2, F3, F4, F5, F6, F7, F8, F9, D1, D2, D3, D4, D5, D6, D7, D8, D9, L1, L2, L3, L4,
 * L5, L6, L7, L8, L9, B1, B2, B3, B4, B5, B6, B7, B8, B9 of the enum constants.
 *
 * @param maxDepth
 * 		defines the maximal allowed maneuver length. For random cubes, a maxDepth of 21 usually will return a
 * 		solution in less than 0.02 seconds on average. With a maxDepth of 20 it takes about 0.1 seconds on average to find a
 * 		solution, but it may take much longer for specific cubes.
 *
 * @param timeOut
 * 		defines the maximum computing time of the method in milliseconds. If it does not return with a solution, it returns with
 * 		an error code.
 *
 * @param timeMin
 * 		defines the minimum computing time of the method in milliseconds. So, if a solution is found within given time, the
 * 		computing will continue to find shorter solution(s). Btw, if timeMin > timeOut, timeMin will be set to timeOut.
 *
 * @param verbose
 * 		determins the format of the solution(s). see USE_SEPARATOR, INVERSE_SOLUTION, APPEND_LENGTH
 *
 * @return The solution string or an error code:<br>
 * 		Error 1: There is not exactly one facelet of each colour<br>
 * 		Error 2: Not all 12 edges exist exactly once<br>
 * 		Error 3: Flip error: One edge has to be flipped<br>
 * 		Error 4: Not all corners exist exactly once<br>
 * 		Error 5: Twist error: One corner has to be twisted<br>
 * 		Error 6: Parity error: Two corners or two edges have to be exchanged<br>
 * 		Error 7: No solution exists for the given maxDepth<br>
 * 		Error 8: Timeout, no solution within given time
 */
NSString* solve(CubieCube* c);
NSString* solutionToString();
int phase1(int twist, int tsym, int flip, int fsym, int slice, int maxl, int lm);
BOOL phase2(int eidx, int esym, int cidx, int csym, int mid, int maxl, int depth, int lm) ;
int verifyFacelets(char facelets[]) {
    int count = 0x000000;
        char center[6] = {
            facelets[4], 
            facelets[13],
            facelets[22],
            facelets[31],
            facelets[40],
            facelets[49]};
        for (int i=0; i<54; i++) {
            char *pos = strchr(center, facelets[i]);
            long index = pos ? pos - center : -1;
            f[i] = (int)index;
            if (f[i] == -1) {
                return -1;
            }
            count += 1 << (f[i] << 2);
        }
    
    if (count != 0x999999) {
        return -1;
    }
    toCubieCube(f, cc);
    return [cc verify];
}

NSString* solutionForFacelets(NSString* facelets, int maxDepth, long newTimeOut, long newTimeMin, int newVerbose) {
    if (!cc) {
        cc = [[CubieCube alloc] init];
    }
    move2str = @[@"U", @"U2", @"U'", @"R", @"R2", @"R'", @"F", @"F2", @"F'",
    @"D", @"D2", @"D'", @"L", @"L2", @"L'", @"B", @"B2", @"B'"];
    int check = verifyFacelets((char*)[facelets UTF8String]);
    if (check != 0) {
        return [NSString stringWithFormat:@"Error %d", check];
    }
    sol = maxDepth+1;
    timeOut = getMStime() + newTimeOut;
    timeMin = timeOut + MIN(newTimeMin - timeOut, 0);
    verbose = newVerbose;
    solution = nil;
    return solve(cc);
}



NSString* solve(CubieCube* c) {
    //Tools.init();
    int conjMask = 0;
    for (int i=0; i<6; i++) {
        twist[i] = c.twistSym;
        flip[i] = c.flipSym;
        slice[i] = c.UDSlice;
        corn0[i] = c.CPermSym;
        ud8e0[i] = c.U4Comb << 16 | c.D4Comb;
        
        for (int j=0; j<i; j++) {	//If S_i^-1 * C * S_i == C, it's unnecessary to compute it again.
            if (twist[i] == twist[j] && flip[i] == flip[j] && slice[i] == slice[j]
                && corn0[i] == corn0[j] && ud8e0[i] == ud8e0[j]) {
                conjMask |= 1 << i;
                break;
            }
        }
        if ((conjMask & (1 << i)) == 0) {
            prun[i] = MAX(MAX(
                                        getPruning(UDSliceTwistPrun,
                                                             ((unsigned)twist[i]>>(unsigned)3) * 495 + UDSliceConj[slice[i]&0x1ff][twist[i]&7]),
                                        getPruning(UDSliceFlipPrun,
                                                   ((unsigned)flip[i]>>(unsigned)3) * 495 + UDSliceConj[slice[i]&0x1ff][flip[i]&7])), 0);
                            /*   getPruning(TwistFlipPrun,
                                                                                ((unsigned)twist[i]>>(unsigned)3) * 2688 + (flip[i] & 0xfff8 | Sym8MultInv[flip[i]&7][twist[i]&7]));*/        
        }
        [c URFConjugate];
        if (i==2) {
            [c invCubieCube];
        }
    }
    for (depth1=0; depth1<sol; depth1++) {
        maxDep2 = MIN(12, sol-depth1);
        for (urfIdx=0; urfIdx<6; urfIdx++) {
            if ((conjMask & (1 << urfIdx)) != 0) {
                continue;
            }
            corn[0] = corn0[urfIdx];
            mid4[0] = slice[urfIdx];
            ud8e[0] = ud8e0[urfIdx];
            if ((prun[urfIdx] <= depth1)
                && phase1((unsigned)twist[urfIdx]>>(unsigned)3, twist[urfIdx]&7, (unsigned)flip[urfIdx]>>(unsigned)3, flip[urfIdx]&7,
                          slice[urfIdx]&0x1ff, depth1, -1) == 0) {
					return solution == nil ? @"Error 8" : solution;
				}
        }
    }
    return @"Error 7";
}

/**
 * @return
 * 		0: Found or Timeout
 * 		1: Try Next Power
 * 		2: Try Next Axis
 */

int initPhase2();

int phase1(int twist, int tsym, int flip, int fsym, int slice, int maxl, int lm) {
    if (twist==0 && flip==0 && slice==0 && maxl<5) {
        return maxl==0 ? initPhase2() : 1;
    }
    for (int axis=0; axis<18; axis+=3) {
        if (axis == lm || axis == lm-9) {
            continue;
        }
        for (int power=0; power<3; power++) {
            int m = axis + power;
            
            int slicex = UDSliceMove[slice][m] & 0x1ff;
            int twistx = TwistMove[twist][Sym8Move[tsym][m]];
            int tsymx = Sym8Mult[twistx & 7][tsym];
            twistx >>= (unsigned)3;
            int prun = getPruning(UDSliceTwistPrun,
                                            twistx * 495 + UDSliceConj[slicex][tsymx]);
            if (prun > maxl) {
                break;
            } else if (prun == maxl) {
                continue;
            }
            int flipx = FlipMove[flip][Sym8Move[fsym][m]]; //One of these two arrays has incorrect values.
            int fsymx = Sym8Mult[flipx & 7][fsym];
            flipx >>= (unsigned)3;
           /* if (YES) {
                prun = getPruning(TwistFlipPrun,
                                            (twistx * 336 + flipx) << 3 | Sym8MultInv[fsymx][tsymx]);
                if (prun > maxl) {
                    break;
                } else if (prun == maxl) {
                    continue;
                }
            }*/
            prun = getPruning(UDSliceFlipPrun,
                                        flipx * 495 + UDSliceConj[slicex][fsymx]);
            if (prun > maxl) {
                break;
            } else if (prun == maxl) {
                continue;
            }
            move[depth1-maxl] = m;
            valid1 = MIN(valid1, depth1-maxl);
            int ret = phase1(twistx, tsymx, flipx, fsymx, slicex, maxl-1, axis);
            if (ret != 1) {
                return ret >> 1;
            }
        }
    }
    return 1;
}

/**
 * @return
 * 		0: Found or Timeout
 * 		1: Try Next Power
 * 		2: Try Next Axis
 */
int initPhase2() {
    if (getMStime() >= (solution == nil ? timeOut : timeMin)) {
        return 0;
    }
    valid2 = MIN(valid2, valid1);
    int cidx = (unsigned)corn[valid1] >> (unsigned)4;
    int csym = corn[valid1] & 0xf;
    for (int i=valid1; i<depth1; i++) {
        int m = move[i];
        cidx = CPermMove[cidx][SymMove[csym][m]];
        csym = SymMult[cidx & 0xf][csym];
        cidx >>= (unsigned)4;
        corn[i+1] = cidx << 4 | csym;
        
        int cx = UDSliceMove[mid4[i] & 0x1ff][m];
        mid4[i+1] = permMult[(unsigned)mid4[i]>>(unsigned)9][(unsigned)cx>>(unsigned)9]<<9|(cx&0x1ff);
    }
    valid1 = depth1;
    int mid = (unsigned)mid4[depth1]>>(unsigned)9;
    int prun = getPruning(MCPermPrun, cidx * 24 + MPermConj[mid][csym]);
    if (prun >= maxDep2) {
        return prun > maxDep2 ? 2 : 1;
    }
    
    int u4e = (unsigned)ud8e[valid2] >> (unsigned)16;
    int d4e = ud8e[valid2] & 0xffff;
    for (int i=valid2; i<depth1; i++) {
        int m = move[i];
        
        int cx = UDSliceMove[u4e & 0x1ff][m];
        u4e = permMult[(unsigned)u4e>>(unsigned)9][(unsigned)cx>>(unsigned)9]<<9|(cx&0x1ff);
        
        cx = UDSliceMove[d4e & 0x1ff][m];
        d4e = permMult[(unsigned)d4e>>(unsigned)9][(unsigned)cx>>(unsigned)9]<<9|(cx&0x1ff);
        
        ud8e[i+1] = u4e << 16 | d4e;
    }
    valid2 = depth1;
    
    int edge = MtoEPerm[494 - (u4e & 0x1ff) + ((unsigned)u4e >> (unsigned)9) * 70 + ((unsigned)d4e >> (unsigned)9) * 1680];
    int esym = edge & 15;
    edge >>= (unsigned)4;
    
    prun = MAX(getPruning(MEPermPrun, edge * 24 + MPermConj[mid][esym]), prun);
    if (prun >= maxDep2) {
        return prun > maxDep2 ? 2 : 1;
    }
    
    int lm = depth1==0 ? 10 : std2ud[move[depth1-1]/3*3+1];
    for (int depth2=prun; depth2<maxDep2; depth2++) {
        if (phase2(edge, esym, cidx, csym, mid, depth2, depth1, lm)) {
            sol = depth1 + depth2;
            maxDep2 = MIN(12, sol-depth1);
            solution = solutionToString();
            return getMStime() >= timeMin ? 0 : 1;
        }
    }
    return 1;
}

BOOL phase2(int eidx, int esym, int cidx, int csym, int mid, int maxl, int depth, int lm) {
    if (eidx==0 && cidx==0 && mid==0) {
        return true;
    }
    for (int m=0; m<10; m++) {
        if (ckmv2[lm][m]) {
            continue;
        }
        int midx = MPermMove[mid][m];
        int cidxx = CPermMove[cidx][SymMove[csym][ud2std[m]]];
        int csymx = SymMult[cidxx & 15][csym];
        cidxx >>= (unsigned)4;
        if (getPruning(MCPermPrun,
                                 cidxx * 24 + MPermConj[midx][csymx]) >= maxl) {
            continue;
        }
        int eidxx = EPermMove[eidx][SymMoveUD[esym][m]];
        int esymx = SymMult[eidxx & 15][esym];
        eidxx >>= (unsigned)4;
        if (getPruning(MEPermPrun, 
                                 eidxx * 24 + MPermConj[midx][esymx]) >= maxl) {
            continue;
        }
        if (phase2(eidxx, esymx, cidxx, csymx, midx, maxl-1, depth+1, m)) {
            move[depth] = ud2std[m];
            return true;
        }
    }
    return false;
}

NSString* solutionToString() {
   // StringBuffer sb = new StringBuffer();
    NSMutableString *solution = [NSMutableString string];
    int urf = (verbose & INVERSE_SOLUTION) != 0 ? (urfIdx + 3) % 6 : urfIdx;
    if (urf < 3) {
        for (int s=0; s<depth1; s++) {
            [solution appendFormat:@"%@ ",[move2str objectAtIndex:(urfMove[urf][move[s]])]];
        }
        for (int s=depth1; s<sol; s++) {
            [solution appendFormat:@"%@ ",[move2str objectAtIndex:(urfMove[urf][move[s]])]];
        }
    } else {
        for (int s=sol-1; s>=depth1; s--) {
            [solution appendFormat:@"%@ ",[move2str objectAtIndex:(urfMove[urf][move[s]])]];
        }
        for (int s=depth1-1; s>=0; s--) {
            [solution appendFormat:@"%@ ",[move2str objectAtIndex:(urfMove[urf][move[s]])]];
        }
    }
    return solution;
}


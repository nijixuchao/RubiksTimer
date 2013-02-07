//
//  PyraminxScrambler.m
//  CubeTimer Scramblers
//
//  Adapted from Jaap Scherphuis' and Syoji Takamatsu's scrambler with permission, as obtained from http://www.worldcubeassociation.org/regulations/scrambles.zip
//

#import "PyraminxScrambler.h"

static int seqlen = 20;

@implementation PyraminxScrambler

-(id)init {
    self = [super init];
    if(self) {
        [self scramble];
    }
    return self;
}

-(void) scramble {
    int i, j, ls, t, k;
    seq = [NSMutableArray array];
    i = 0;
    
    /* Rotate a vertex */
    for( t = 0; t < 4; t++) {
        k = arc4random() % 3;
        if(k != 0) {
            [seq insertObject:[NSNumber numberWithInt:t+4] atIndex:(i * 2)];
            [seq insertObject:[NSNumber numberWithInt:k] atIndex:(i * 2 + 1)];
            i++;
        }
    }
    
    ls = -1;
    /* Rotate two layers */
    for(; i < seqlen ; i++){
        do {
            j = arc4random() % 4;
        } 
        while( ls >= 0 && j == ls);
    
        ls = j;
        k = arc4random() % 2 + 1;
        [seq insertObject:[NSNumber numberWithInt:j] atIndex:2i];
        [seq insertObject:[NSNumber numberWithInt:k] atIndex:(2i + 1)];
    }
}


-(NSString*) generateScrambleString {
    NSMutableString *s = [NSMutableString string];
    for(int i = 0; i < [seq count]; i += 2) {
        [s appendFormat:@"%C",[@"LRBUlrbu" characterAtIndex:[[seq objectAtIndex:i] intValue]]];
        if ([[seq objectAtIndex:i+1] intValue] == 2) [s appendString:@"'"];
        [s appendString:@" "];
    }
    return s;
}
@end

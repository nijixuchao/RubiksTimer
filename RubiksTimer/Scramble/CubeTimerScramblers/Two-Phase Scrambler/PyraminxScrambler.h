//
//  PyraminxScrambler.h
//  CubeTimer Scramblers
//
//  Adapted from Jaap Scherphuis' and Syoji Takamatsu's scrambler with permission, as obtained from http://www.worldcubeassociation.org/regulations/scrambles.zip
//

#import <Foundation/Foundation.h>

@interface PyraminxScrambler : NSObject {
    NSMutableArray *seq;
}
-(NSString*) generateScrambleString;
-(void)scramble;
@end

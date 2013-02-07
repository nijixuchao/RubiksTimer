//
//  ScrambleSQ1.m
//  RubiksTimer
//
//  Created by Jichao Li on 5/31/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import "ScrambleSQ1.h"
#import "stdlib.h"
#import "time.h"
@interface ScrambleSQ1 ()
//@property (nonatomic, retain) UIWebView *webview;
@end

@implementation ScrambleSQ1
//@synthesize webview = _webview;



int pOrig[24] = {1,0,0,1,0,0,1,0,0,1,0,0,0,1,0,0,1,0,0,1,0,0,1,0};
int p[24] = {1,0,0,1,0,0,1,0,0,1,0,0,0,1,0,0,1,0,0,1,0,0,1,0};
NSMutableArray *seq;

- (NSString *)scramble {
    NSLog(@"sq1");
    seq = [[NSMutableArray alloc] init];
    //[seq removeAllObjects];
    
    [self getseq];
    NSString *s = @"";
    for (int i = 0; i < seq.count; i++) {
        //if (seq.get(i)[0] == 7) s += "/";
        //else s += " (" + seq.get(i)[0] + "," + seq.get(i)[1] + ") ";
        
        if ([[[seq objectAtIndex:i]objectAtIndex:0] intValue] == 7) {
            s = [s stringByAppendingString:@"/"];
        } else {
            NSString *temp1 = [NSString stringWithFormat:@"%d", [[[seq objectAtIndex:i] objectAtIndex:0] intValue]];
            NSString *temp2 = [NSString stringWithFormat:@"%d", [[[seq objectAtIndex:i] objectAtIndex:1] intValue]];
            NSString *new = [[[[@" (" stringByAppendingString:temp1] stringByAppendingString:@","] stringByAppendingString:temp2] stringByAppendingString:@") "];
            s = [s stringByAppendingString:new];
        }
    }
    return s;
}

- (void) getseq {
    for (int i = 0; i< 24; i++) {
        p[i] = pOrig[i];
    }
    srand((unsigned)time(NULL));
    int cnt = 0;
    int len = 20;
    while (cnt < len) {
        //
        int x = rand()%12 - 5;
        //NSLog(@"x: %d", x);
        int y = rand()%12 - 5;
        //NSLog(@"y: %d", y);
        int size = ((x == 0) ? 0 : 1) + ((y == 0) ? 0 : 1);
        //NSLog(@"size: %d", size);
        if (size > 0 || cnt == 0) {
            if ([self domove:x y: y]) {
                NSArray *m = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:x], [NSNumber numberWithInt:y], nil];
                if (size > 0) 
                    [seq addObject:m];
                cnt++;
                NSArray *n = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:7], [NSNumber numberWithInt:0], nil];
                [seq addObject:n];
                [self domove:7 y:0];
            }
        }
    }
}

- (BOOL)domove: (int) x y:(int) y {
    if (x == 7) {
        for (int i = 0; i < 6; i++) {
            int temp = p[i + 6];
            p[i + 6] = p[i + 12];
            p[i + 12] = temp;
        }
        //NSLog(@"true1");
        return true;
        
    }
    else {
        //NSLog(@"%d", p[(17 - x) % 12]);
        //NSLog(@"%d", p[(11 - x) % 12]);
        //NSLog(@"%d", p[12 + (17 - y) % 12]);
        //NSLog(@"%d", p[12 + (11 - y) % 12]);
        if (p[(17 - x) % 12]|| p[(11 - x) % 12]|| p[12 + (17 - y) % 12]|| p[12 + (11 - y) % 12]) {
            //NSLog(@"false");
            return false;
        }
        else {
            int px[12];
            int py[12];
            for (int i = 0; i < 12; i++) {
                px[i] = p[i];
            }
            for (int i = 12; i < 24; i++) {
                py[i-12] = p[i];
            }    
            for (int i = 0; i < 12; i++) {
                p[i] = px[(12 + i - x) % 12];
                p[i + 12] = py[(12 + i - y) % 12];
            }
            //NSLog(@"true2");
            return true;
        }
    }
}

/*
- (NSString *)scramble {
    self.webview = [[UIWebView alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"scramble" ofType:@"js"];
    NSLog(@"path: %@", path);
    NSString *js = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]; 
    [self.webview stringByEvaluatingJavaScriptFromString:js];
    NSString *scr = @"sq1_scramble(0);";
    NSLog(@"%@", scr);
    return [self.webview stringByEvaluatingJavaScriptFromString:scr];
}
*/

@end

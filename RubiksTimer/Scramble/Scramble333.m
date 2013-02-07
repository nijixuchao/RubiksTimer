//
//  Scramble333.m
//  RubiksTimer
//
//  Created by Jichao Li on 6/2/12.
//  Copyright (c) 2012 Sufflok University. All rights reserved.
//

#import "Scramble333.h"

@interface Scramble333 ()
@property (nonatomic, retain) UIWebView *webview;

@end


@implementation Scramble333
@synthesize webview = _webview;

- (Scramble333 *)init {
    if (self = [super init]) {
        self.webview = [[UIWebView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"scramble_333" ofType:@"js"];
        NSLog(@"%@", path);
        NSString *js = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]; 
        [[self webview] stringByEvaluatingJavaScriptFromString:js];
        NSString *ini = [NSString stringWithFormat:@"scramblers[\"%d\"].initialize(null, Math)", 333];
        [[self webview] stringByEvaluatingJavaScriptFromString:ini]; 
    }
    return self;
}

- (NSString *)scramble {
    NSString *scr = @"scramblers[\"333\"].getRandomScramble().scramble_string";
    NSLog(@"%@", scr);
    return [[self webview] stringByEvaluatingJavaScriptFromString:scr];
}

@end

//
//  FBUtils.m
//  oomf
//
//  Created by shail on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBUtils.h"

static FBUtils *sharedFBUtils = nil;

@implementation FBUtils

#pragma mark - @synthesize -

@synthesize facebook = _facebook;
@synthesize delegate;

#pragma mark - Initialise -

+(FBUtils *)sharedFBUtils {
	if (!sharedFBUtils) {
		sharedFBUtils = [[FBUtils alloc] init];
	}
	return sharedFBUtils;
}

-(void)initializeWithAppID:(NSString *)appid {	
	_facebook = [[Facebook alloc] initWithAppId:appid andDelegate:self];
    
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];		
	}		
}

-(void)LoginWithPermisions:(NSArray *)array {
	if (![self.facebook isSessionValid]) {
		if (array) {
			[self.facebook authorize:array];
		}
	}
}


#pragma mark - FBSessionDelegate - 

- (void)fbDidLogin {
	
	//save to user defualt
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_facebook accessToken] 
				 forKey:@"FBAccessTokenKey"];
	
    [defaults setObject:[_facebook expirationDate] 
				 forKey:@"FBExpirationDateKey"];
	
    [defaults synchronize];
	
	if (delegate && [delegate respondsToSelector:@selector(fbDidLogin)]) {
		[delegate fbDidLogin];
	}
    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"FB Login!", NULL) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", NULL) otherButtonTitles:nil];
    [alertView show];
	
}

- (void)fbDidNotLogin:(BOOL)cancelled {
	
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt {
	
}

- (void)fbDidLogout {
	[self.facebook logout];
}

- (void)fbSessionInvalidated {
	
}

-(BOOL)handleOpenURL:(NSURL *)url {
	return [self.facebook handleOpenURL:url];
}


@end

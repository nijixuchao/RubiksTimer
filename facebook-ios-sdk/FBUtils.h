//
//  FBUtils.h
//  oomf
//
//  Created by shail on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"

/*
 Requirements to use this Utils
 
 To use this class one need to override the method in AppDelegate as follows
 - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
   return [[FBUtils sharedFBUtils] handleOpenURL:url]; 
 }
 
 and Implement Custom URL Schema with URL as "fbAppId" where AppId is the application Identifier you get when you register App @ developer.facebook.com
 and then Call Initialize method of FBUtils with initializeWithAppID:
*/

@protocol FBUtilsDelegate <NSObject>

@optional
-(void)fbDidLogin ;

@end

@interface FBUtils : NSObject <FBSessionDelegate>

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, assign) id<FBUtilsDelegate> delegate;
+(FBUtils *)sharedFBUtils ;
-(void)initializeWithAppID:(NSString *)appid ;
-(void)LoginWithPermisions:(NSArray *)array ;
-(BOOL)handleOpenURL:(NSURL *)url ;

@end

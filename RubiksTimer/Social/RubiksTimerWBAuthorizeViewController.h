//
//  RubiksTimerWBAuthorizeViewController.h
//  ChaoTimer
//
//  Created by Jichao Li on 2/3/13.
//  Copyright (c) 2013 Jichao Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RubiksTimerWBAuthorizeViewController;

@protocol RubiksTimerWBAuthorizeViewDelegate <NSObject>

- (void)authorizeAuthView:(RubiksTimerWBAuthorizeViewController *)authView didReceiveAuthorizeCode:(NSString *)code;

@end

@interface RubiksTimerWBAuthorizeViewController : UIViewController <UIWebViewDelegate>
{
    UIView *containerView;
    UIActivityIndicatorView *indicatorView;
	UIWebView *webView;
    id<RubiksTimerWBAuthorizeViewDelegate> delegate;
}

@property (nonatomic, assign) id<RubiksTimerWBAuthorizeViewDelegate> delegate;
@property (nonatomic, strong) NSString *urlString;
- (void)loadRequestWithURL:(NSURL *)url;
- (void)hide;
@end

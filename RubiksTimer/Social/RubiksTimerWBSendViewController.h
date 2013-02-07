//
//  RubiksTimerWBSendViewController.h
//  ChaoTimer
//
//  Created by Jichao Li on 2/4/13.
//  Copyright (c) 2013 Jichao Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WBEngine.h"

@class RubiksTimerWBSendViewController;

@protocol RubiksTimerWBSendDelegate <NSObject>
@optional
- (void)sendViewWillAppear:(RubiksTimerWBSendViewController *)viewController;
- (void)sendViewDidAppear:(RubiksTimerWBSendViewController *)viewController;
- (void)sendViewWillDisappear:(RubiksTimerWBSendViewController *)viewController;
- (void)sendViewDidDisappear:(RubiksTimerWBSendViewController *)viewController;

- (void)sendViewDidFinishSending:(RubiksTimerWBSendViewController *)viewController;
- (void)sendView:(RubiksTimerWBSendViewController *)viewController didFailWithError:(NSError *)error;

- (void)sendViewNotAuthorized:(RubiksTimerWBSendViewController *)viewController;
- (void)sendViewAuthorizeExpired:(RubiksTimerWBSendViewController *)viewController;
@end

@interface RubiksTimerWBSendViewController : UIViewController <UITextViewDelegate, WBEngineDelegate>
{
    UIActivityIndicatorView *indicatorView;
    WBEngine    *engine;
    id<RubiksTimerWBSendDelegate> delegate;
}

@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) NSString *contentText;
@property (strong, nonatomic) UIImage *contentImage;
@property (nonatomic, assign) id<RubiksTimerWBSendDelegate> delegate;
- (void) setProperties: (NSString *)appKey appSecret:(NSString *)appSecret text:(NSString *)text image:(UIImage *)image;
- (void) hide;
@end

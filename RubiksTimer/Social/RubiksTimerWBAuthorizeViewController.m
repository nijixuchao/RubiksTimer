//
//  RubiksTimerWBAuthorizeViewController.m
//  ChaoTimer
//
//  Created by Jichao Li on 2/3/13.
//  Copyright (c) 2013 Jichao Li. All rights reserved.
//

#import "RubiksTimerWBAuthorizeViewController.h"
#import <QuartzCore/QuartzCore.h> 

@interface RubiksTimerWBAuthorizeViewController ()
@end

@implementation RubiksTimerWBAuthorizeViewController

@synthesize delegate = _delegate;
@synthesize urlString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.title = NSLocalizedString(@"weibo login", NULL);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    if ( [[UIDevice currentDevice].systemVersion doubleValue] >= 6.0f) {
        titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:22.0f];
    } else {
        titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    }
    [titleLabel setShadowColor:[UIColor darkGrayColor]];
    [titleLabel setShadowOffset:CGSizeMake(0, -1)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"weibo login", NULL);
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.1f green:0.5f blue:0.75f alpha:1]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:0.2f green:0.6f blue:0.8f alpha:1]];
    //[self.navigationController.toolbar setTintColor:[UIColor colorWithRed:0.1f green:0.5f blue:0.75f alpha:1]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backToPreviousView:)];
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self. view.frame.size.width, self.view.frame.size.height)];
    [[containerView layer] setBorderColor:[UIColor colorWithRed:0. green:0. blue:0. alpha:0.7].CGColor];
    [[containerView layer] setBorderWidth:1.0];
    
    // add the web view
    CGRect tScreenBounds = self.view.frame;
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, tScreenBounds.size.width, tScreenBounds.size.height)];
    [webView setDelegate:self];
    [containerView addSubview:webView];
    
    [self.view addSubview:containerView];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setCenter:CGPointMake(tScreenBounds.size.width/2, tScreenBounds.size.height/2)];
    [self.view addSubview:indicatorView];

    [self loadRequestWithURL:[NSURL URLWithString:urlString]];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - WBAuthorizeWebView Public Methods

- (void)loadRequestWithURL:(NSURL *)url
{
    NSURLRequest *request =[NSURLRequest requestWithURL:url
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:60.0];
    [webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
	[indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
	[indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
    [indicatorView stopAnimating];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSRange range = [request.URL.absoluteString rangeOfString:@"code="];
    
    if (range.location != NSNotFound)
    {
        NSString *code = [request.URL.absoluteString substringFromIndex:range.location + range.length];
        NSLog(@"rtc web1");
        //[_delegate authorizeAuthView:self didReceiveAuthorizeCode:code];
        if ([_delegate respondsToSelector:@selector(authorizeAuthView:didReceiveAuthorizeCode:)])
        {
            NSLog(@"rtc web");
            [_delegate authorizeAuthView:self didReceiveAuthorizeCode:code];
        }
    }
    
    return YES;
}

- (IBAction)backToPreviousView:(id)sender {
    NSLog(@"remove!");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hide{
    NSLog(@"remove!");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
    
    //return YES;
}

@end

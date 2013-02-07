//
//  RubiksTimerWBSendViewController.m
//  ChaoTimer
//
//  Created by Jichao Li on 2/4/13.
//  Copyright (c) 2013 Jichao Li. All rights reserved.
//

#import "RubiksTimerWBSendViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface RubiksTimerWBSendViewController ()
- (int)textLength:(NSString *)text;
- (void)calculateTextLength;
@end

@implementation RubiksTimerWBSendViewController

@synthesize container;
@synthesize textView;
@synthesize imageView;
@synthesize contentText;
@synthesize contentImage;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setProperties: (NSString *)appKey appSecret:(NSString *)appSecret text:(NSString *)text image:(UIImage *)image {
    engine = [[WBEngine alloc] initWithAppKey:appKey appSecret:appSecret];
    [engine setDelegate:self];
    contentText = text;
    contentImage = image;
}

- (void)viewDidLoad
{
    self.navigationItem.title = NSLocalizedString(@"shareWeibo", NULL);
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
    titleLabel.text = NSLocalizedString(@"shareWeibo", NULL);
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.1f green:0.5f blue:0.75f alpha:1]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:0.2f green:0.6f blue:0.8f alpha:1]];
    //[self.navigationController.toolbar setTintColor:[UIColor colorWithRed:0.1f green:0.5f blue:0.75f alpha:1]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backToPreviousView:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"share!", NULL) style:UIBarButtonItemStyleBordered target:self action:@selector(onSendButtonTouched:)];
    
    
    [self.container.layer setCornerRadius:5];
    [self.container.layer setBorderWidth:1];
    [self.container.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    self.container.layer.masksToBounds = YES;
    
    [self.imageView.layer setBorderWidth:5];
    [self.imageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.imageView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.imageView.layer setShadowOpacity:1];
    [self.imageView.layer setShadowOffset:CGSizeMake(0, 0)];
    //[self.imageView.layer setShadowRadius:3];

    UIImageView *imgSubView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.imageView.frame.size.width-10, self.imageView.frame.size.height-10)];
    if (contentImage) {
        imgSubView.image = contentImage;
    } else {
        imgSubView.image = [UIImage imageNamed:@"icon_144"];
    }
    [imgSubView setContentMode:UIViewContentModeScaleToFill];
    [imgSubView setClipsToBounds:YES];
    [self.imageView addSubview:imgSubView];
    
    [self.textView setText:contentText];
    [self.textView becomeFirstResponder];
    [self.textView endOfDocument];
    
    [self.textView setDelegate:self];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setCenter:CGPointMake(self.container.frame.origin.x + self.container.frame.size.width/2, self.container.frame.origin.y + self.container.frame.size.height/2) ];
     NSLog(@"%f, %f", indicatorView.center.x, indicatorView.center.y);
    //[indicatorView startAnimating];
    [self.view addSubview:indicatorView];
    [self calculateTextLength];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContainer:nil];
    [self setTextView:nil];
    [self setImageView:nil];
    [self setLabel:nil];
    [indicatorView stopAnimating];
    [super viewDidUnload];
}

- (void)onSendButtonTouched:(id)sender
{
    [indicatorView startAnimating];
    [self performSelector:@selector(sendSinaWeibo) withObject:nil afterDelay:0.1];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

- (void) sendSinaWeibo {
    if ([self.textView.text isEqualToString:@""])
    {
		UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"新浪微博", nil)
                                                             message:NSLocalizedString(@"请输入微博内容", nil)
                                                            delegate:nil
                                                   cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
		[alertView show];
        [indicatorView stopAnimating];
        
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
		return;
	}
    else {
        [engine sendWeiBoWithText:self.textView.text image:contentImage];
    }
}

- (int)textLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    return ceil(number);
}

- (void)calculateTextLength
{
    if (self.textView.text.length > 0)
	{
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
	}
	else
	{
		[self.navigationItem.rightBarButtonItem setEnabled:NO];
	}
	
	int wordcount = [self textLength:self.textView.text];
	NSInteger count  = 140 - wordcount;
	if (count < 0)
    {
		[self.label setTextColor:[UIColor redColor]];
		[self.navigationItem.rightBarButtonItem setEnabled:NO];
	}
    else if (count == 140) {
        [self.label setTextColor:[UIColor darkGrayColor]];
		[self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
	else
    {
		[self.label setTextColor:[UIColor darkGrayColor]];
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
	}
	
	[self.label setText:[NSString stringWithFormat:@"%i",count]];
}

#pragma mark - UITextViewDelegate Methods

- (void)textViewDidChange:(UITextView *)textView
{
	[self calculateTextLength];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

#pragma mark - WBEngineDelegate Methods

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    if ([_delegate respondsToSelector:@selector(sendViewDidFinishSending:)])
    {
        [_delegate sendViewDidFinishSending:self];
    }
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(sendView:didFailWithError:)])
    {
        [_delegate sendView:self didFailWithError:error];
    }
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    if ([_delegate respondsToSelector:@selector(sendViewNotAuthorized:)])
    {
        [_delegate sendViewNotAuthorized:self];
    }
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    if ([_delegate respondsToSelector:@selector(sendViewAuthorizeExpired:)])
    {
        [_delegate sendViewAuthorizeExpired:self];
    }
}

- (IBAction)backToPreviousView:(id)sender {
    if ([_delegate respondsToSelector:@selector(sendViewWillDisappear:)])
    {
        [_delegate sendViewWillDisappear:self];
    }
    NSLog(@"remove!");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hide{
    if ([_delegate respondsToSelector:@selector(sendViewWillDisappear:)])
    {
        [_delegate sendViewWillDisappear:self];
    }
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

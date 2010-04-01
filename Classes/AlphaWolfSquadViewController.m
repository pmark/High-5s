//
//  AlphaWolfSquadViewController.m
//  AlphaWolfSquad
//
//  Created by Swinkdaddy on 8/20/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "AlphaWolfSquadViewController.h"
#import "SettingsController.h"
#import "HelpController.h"
#import "WelcomeController.h"
#import "ConfirmationController.h"
#import "CountdownController.h"

#define SESSION_END_DELAY_SEC 1.5
#define CC_MD5_DIGEST_LENGTH 16
#define OVERLAY_TRANSITION_ANIMATION 0.75
#define CONGRATS_OFFSET 10
#define CONGRATS_ANIMATION_DURATION 0.33

#define MAIL_SUBJECT @"Have some high 5s"
#define MAIL_BODY @"Hello friend,\n\nI'm sending you some High 5s. Click the link below to view these puppies on the internets.\n   %@\n\n"
#define MAIL_BODY_HTML @"Hello friend,<br/><br/>\n\nI'm sending you some High 5s. <a href=\"%@\">Click here</a> to view these puppies on the internets.<br/>\n<br/>\n"
#define CONGRATS_TEXT_FORMAT @"You just completed %i High5%@.  You have skills. Now press \"Send.\" Or \"Try Again\" to redeem yourself."

@implementation AlphaWolfSquadViewController

@synthesize alphaview, slapview, sessionEndTimer, congrats, congratsText;
@synthesize countdown;

- (void)dealloc {
    [alphaview release];
    [slapview release];
    [sessionEndTimer release];
    [congrats release], congrats = nil;
    [congratsText release], congratsText = nil;
    [countdown release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	AlphaWolfView *aBegin = [[AlphaWolfView alloc] init];
    aBegin.controller = self;
	self.alphaview = aBegin;
	alphaview.frame = CGRectMake(0,0,320,480);
	[aBegin release];
	[self.view addSubview:alphaview];
	
    self.slapview = [[[SlapView alloc] initWithCenter:CGPointMake(160, 240)] autorelease];
    slapview.userInteractionEnabled = NO;
    slapview.controller = self;
    [alphaview addSubview:slapview]; 
    
    self.countdown = [[[CountdownController alloc] init] autorelease];
    [self.view addSubview:countdown.view];
}

-(void)openOverlay:(OverlayController*)newOverlay {
    newOverlay.host = self;
    newOverlay.view.hidden = YES;
    [self.view addSubview:newOverlay.view];        
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:OVERLAY_TRANSITION_ANIMATION];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    
	newOverlay.view.hidden = NO;
    
    [UIView commitAnimations];
}

-(void)removeOverlay:(OverlayController*)overlay {
	[overlay.view removeFromSuperview];
    [overlay release];
}

-(void)closeOverlay:(OverlayController*)activeOverlay {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:OVERLAY_TRANSITION_ANIMATION];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    
	activeOverlay.view.hidden = YES;
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(removeOverlay:) withObject:activeOverlay afterDelay:OVERLAY_TRANSITION_ANIMATION];

    if ([activeOverlay isKindOfClass:[WelcomeController class]]) {
        [countdown startCountdownAfterDelay:OVERLAY_TRANSITION_ANIMATION];
    }
}

-(void)acceleratedInX:(float)xx Y:(float)yy Z:(float)zz{
	// I just pass along the info.
	[alphaview acceleratedInX:xx Y:yy Z:zz];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"[awsvc] viewWillAppear");
    [self.alphaview becomeFirstResponder]; // For shake gesture.
}


- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"[awsvc] viewWillDisappear");
    [super viewWillDisappear:animated];
    [self.alphaview resignFirstResponder]; 
} 

#pragma mark Mail
+ (void) alertWithTitle:(NSString*)title message:(NSString*)message {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil, nil];
	[alert show];
	[alert release];				
}


- (void) showEmailModalView:(NSString*)title emailBody:(NSString*)body recipientList:(NSArray*)recipients {
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self; 
    
	if (recipients != nil) {
        [picker setToRecipients:recipients];	
	}
    
	[picker setSubject:title];
	[picker setMessageBody:body isHTML:YES]; 	
	picker.navigationBar.barStyle = UIBarStyleBlack; 
	picker.navigationBar.translucent = NO;
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

/*
 * delegate method to handle email
 */
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{ 
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
            [self showConfirmationScreen];
			break;
		case MFMailComposeResultFailed:
			break;
		default:
		{
            [AlphaWolfSquadViewController alertWithTitle:@"Email failed" message:@"Sorry, but this email could not be sent."];
		}
            
            break;
	}
    [self dismissModalViewControllerAnimated:YES];    
}

#pragma mark -
#pragma mark Motion

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	[super motionBegan: motion withEvent: event];
	if (motion == UIEventSubtypeMotionShake) {
        [self shakeDetected];
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	[super motionCancelled: motion withEvent: event];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	[super motionEnded: motion withEvent: event];
}  

- (void)clickSettings {
    SettingsController *c = [[SettingsController alloc] init];
    [self openOverlay:c];
}

- (void)clickHelp {
    HelpController *c = [[HelpController alloc] init];
    [self openOverlay:c];
}

#pragma mark -

- (void)handleSlap {
    congrats.hidden = YES;
    [alphaview clapper];
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    [self.slapview showSlapEffect];
    [self.slapview incrementCount];
    
    // start timer
    if (sessionEndTimer) 
        [sessionEndTimer invalidate];
    
	self.sessionEndTimer = [NSTimer scheduledTimerWithTimeInterval:SESSION_END_DELAY_SEC target:self selector:@selector(askToEndSession) userInfo:nil repeats:NO];  
}

- (void)askToEndSession {
    CGPoint screenCenter = CGPointMake(self.view.center.x, self.view.center.y-20);
    congratsText.text = [NSString stringWithFormat:CONGRATS_TEXT_FORMAT, slapview.slapCount, (slapview.slapCount != 1 ? @"s" : @"")];
    
    
    congrats.center = CGPointMake(screenCenter.x, screenCenter.y - CONGRATS_OFFSET);
    congrats.alpha = 0.0;
    congrats.hidden = NO;
    
    [self.view bringSubviewToFront:congrats];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:CONGRATS_ANIMATION_DURATION];
    
    congrats.alpha = 1.0;
    congrats.center = screenCenter;
    
    [UIView commitAnimations];
}

- (void)shakeDetected {
    NSLog(@"shake!!!!!");
    [self handleSlap];
}

- (IBAction)tryAgain {
    congrats.alpha = 1.0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:CONGRATS_ANIMATION_DURATION];
    [UIView setAnimationDidStopSelector:@selector(tryAgainAnimationDidFinish)];
    
    congrats.alpha = 0.0;
    congrats.center = CGPointMake(congrats.center.x, congrats.center.y + CONGRATS_OFFSET);
    
    [UIView commitAnimations];
    
    [slapview reset];
}

- (void)tryAgainAnimationDidFinish {
    congrats.center = self.view.center;
}

- (IBAction)sendBatch {
    //NSString *link = [NSString stringWithFormat:@"http://www.havesomehigh5s.com/staging/includes/sendStuff_iPhone.php?"];
    //NSString *link = @"http://www.havesomehigh5s.com/staging/index.php?id=26";
    NSString *link = [self batchURL];
    [self showEmailModalView:MAIL_SUBJECT emailBody:[NSString stringWithFormat:MAIL_BODY_HTML, link] recipientList:nil];
}

#pragma mark -
+ (NSString *)uniqueIDFromString:(NSString *)source {
	const char *src = [[source lowercaseString] UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(src, strlen(src), result);
    
    NSString *ret = [[[NSString alloc] initWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", 
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15]
                      ] autorelease];
    
    return ret;
}

- (NSString*)batchURL {
    NSString *baseURL = @"http://www.havesomehigh5s.com/staging/index.php?batch=%@";
    NSTimeInterval millis = [[NSDate date] timeIntervalSince1970];
    NSString *tstamp = [NSString stringWithFormat:@"%f", millis];
    NSString *token = [AlphaWolfSquadViewController uniqueIDFromString:tstamp];
    return [NSString stringWithFormat:baseURL, token];
}

#pragma mark -
- (void) showWelcomeScreen {    
    WelcomeController *welcomeController = [[WelcomeController alloc] init];
    [self openOverlay:welcomeController];
}

- (void) showConfirmationScreen {    
    [slapview reset];
    congrats.hidden = YES;
    ConfirmationController *c = [[ConfirmationController alloc] init];
    [self openOverlay:c];
}

@end

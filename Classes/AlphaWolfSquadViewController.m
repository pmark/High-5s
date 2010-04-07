//
//  AlphaWolfSquadViewController.m
//  AlphaWolfSquad
//
//  Created by Swinkdaddy on 8/20/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "AlphaWolfSquadViewController.h"
#import "AlphaWolfSquadAppDelegate.h"
#import "SettingsController.h"
#import "HelpController.h"
#import "WelcomeController.h"
#import "ConfirmationController.h"
#import "CountdownController.h"

#define SESSION_END_DELAY_SEC 2.5
#define CC_MD5_DIGEST_LENGTH 16
#define OVERLAY_TRANSITION_ANIMATION 0.75
#define CONGRATS_OFFSET 10
#define CONGRATS_ANIMATION_DURATION 0.33
//#define ARC_START_ANGLE 135.0
//#define ARC_TRAVEL -20.0
#define ARC_START_ANGLE 45.0
#define ARC_TRAVEL 20.0

#define MAIL_SUBJECT @"Have Some High 5s"
//#define MAIL_BODY_TEXT @"I am sending you %i High 5%@. I worked hard for them and hope you will appreciate the fruits they bear. Click the link below to witness the awesome spectacle these High 5s offer.\n\n%@"
#define MAIL_BODY_SINGULAR_HTML @"I am sending you a High 5. I worked hard for it and hope you will appreciate the fruit it bears. <a href=\"%@\">Click here</a> to witness the awesome spectacle this High 5 offers."
#define MAIL_BODY_PLURAL_HTML @"I am sending you %i High 5s. I worked hard for them and hope you will appreciate the fruits they bear. <a href=\"%@\">Click here</a> to witness the awesome spectacle these High 5s offer."
#define CONGRATS_TEXT_FORMAT @"You just completed %i High5%@.  You have skills. Now press \"Send.\" Or \"Try Again\" to redeem yourself."

@implementation AlphaWolfSquadViewController

@synthesize alphaview, slapview, sessionEndTimer, congrats, congratsText;
@synthesize countdown, arc;

- (void)dealloc {
    [alphaview release];
    [slapview release];
    [sessionEndTimer release];
    [congrats release], congrats = nil;
    [congratsText release], congratsText = nil;
    [countdown release];
    [arc release];
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
	
    self.slapview = [[[SlapView alloc] initWithCenter:CGPointMake(133, 280)] autorelease];
    slapview.userInteractionEnabled = NO;
    slapview.controller = self;
    [alphaview addSubview:slapview]; 
    
    self.countdown = [[[CountdownController alloc] init] autorelease];
    [self.view addSubview:countdown.view];
    
    //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(detectMovement:) userInfo:nil repeats:YES];
    self.arc = [DeviceMovementArc arcOnAxis:DeviceMovementAxisPitch startAngle:ARC_START_ANGLE travel:ARC_TRAVEL];

    
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedSM3DAR_Controller];
    sm3dar.delegate = self;

    //[NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(printPitch) userInfo:nil repeats:YES];
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

-(NSString*)messageBody {
    NSString *link = [self batchURL];
    NSString *html = (slapview.slapCount != 1 ? MAIL_BODY_SINGULAR_HTML : MAIL_BODY_PLURAL_HTML);
	return [NSString stringWithFormat:html, slapview.slapCount, link];
}

-(NSString*)theLetterS {
    return (slapview.slapCount != 1 ? @"" : @"s");
}

-(void)acceleratedInX:(float)xx Y:(float)yy Z:(float)zz{
    NSLog(@"AWSVC::acceleratedInX:Y:Z");

    // which axis is pitch?
    CGFloat xdeg = RADIANS_TO_DEGREES(xx);
    CGFloat ydeg = RADIANS_TO_DEGREES(yy);
    CGFloat zdeg = RADIANS_TO_DEGREES(zz);

    if (xdeg > 90.0) {
        NSLog(@"x: %f", xdeg);
    }
    
    if (ydeg > 90.0) {
        NSLog(@"y: %f", ydeg);
    }

    if (zdeg > 90.0) {
        NSLog(@"z: %f", zdeg);
    }

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
/*
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
*/

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
    [alphaview clapper];

    [countdown cancelCountdown];    
    congrats.hidden = YES;
    
    [self.slapview showSlapEffect];
    [self.slapview incrementCount];
    
    // start timer
    if (sessionEndTimer) 
        [sessionEndTimer invalidate];
    
	self.sessionEndTimer = [NSTimer scheduledTimerWithTimeInterval:SESSION_END_DELAY_SEC target:self selector:@selector(askToEndSession) userInfo:nil repeats:NO];  
}

- (void)askToEndSession {
    CGPoint screenCenter = CGPointMake(self.view.center.x, self.view.center.y-20);
    congratsText.text = [NSString stringWithFormat:CONGRATS_TEXT_FORMAT, slapview.slapCount, [self theLetterS]];
    
    
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
    //[self handleSlap];
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
    [self showEmailModalView:MAIL_SUBJECT emailBody:[self messageBody] recipientList:nil];
}

#pragma mark -
+ (NSString *)uniqueIDFromString:(NSString *)source {
	const char *src = [[source lowercaseString] UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(src, strlen(src), result);
    
    NSString *ret = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", 
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15]
                      ];
    
    return ret;
}

- (NSString*)batchURL {
    
    NSString *baseURL = @"http://www.havesomehigh5s.com/index.php?token=%@&vidNumber=%i";
    NSTimeInterval millis = [[NSDate date] timeIntervalSince1970];
    NSString *tstamp = [NSString stringWithFormat:@"%f", millis];
    NSString *token = [AlphaWolfSquadViewController uniqueIDFromString:tstamp];
    NSInteger vidNumber = [slapview slapCount];
    if (vidNumber > 23) vidNumber = 23;
    return [NSString stringWithFormat:baseURL, token, vidNumber];
}

#pragma mark -
- (void) showWelcomeScreen {    
    WelcomeController *welcomeController = [[WelcomeController alloc] init];
    [self openOverlay:welcomeController];
}

- (void) showConfirmationScreen {
    [APP_DELEGATE incrementLocalCountBy:slapview.slapCount];
    [alphaview updateLocalCounterLabel];

    [slapview reset];
    congrats.hidden = YES;
    ConfirmationController *c = [[ConfirmationController alloc] init];
    [self openOverlay:c];
}

- (void) didChangeOrientationYaw:(CGFloat)yaw pitch:(CGFloat)pitch roll:(CGFloat)roll {    
    CGFloat pitchDelta = pitch - lastPitch;
    
    // use angle coming from other direction
//    CGFloat diff1 = pitch - (pitch - 360);
//    CGFloat diff2 = pitch - (lastPitch + 360);

    NSLog(@"pitch:%.0f,   last:%.0f,   delta:%.0f", pitch, lastPitch, pitchDelta);    
    
    
    // TODO: make it work from either angle
    // Maybe the 90 degree point just needs to be crossed
    // just prior to the arc's end.
    //
    // Watch for arc start when a certain distance is traveled in one direction.
    // Record arc start angle.
    // When arc motion ends, record end angle.
    // If 90 degree point has been crossed, trigger event.
    // But this will happen in both directions (bad).


    // TESTS:
    
    
    // if dir is positive
    // it should go to (90 - apexOffset), from (startAngle)
    // startAngle should start from going in positive direction
    
    // TRAVEL: 20
    // POS: 45
    // NEG: 135
    

    // must be traveling from -123 to 90 degrees
    if (pitchDelta < 0 || fabs(pitchDelta) > 179) {
        movementPhase = 0;
        lastPitch = pitch;
     	return;   
    }
    
    //NSLog(@"pitch: %f", pitch);

    // determine whether arc has passed startAngle
    // heading in direction of travel
    
    CGFloat distanceFromThreshold;
    BOOL traveledPastThreshold;
    
    switch (movementPhase) {
        case 0:
            // haven't started yet
            // given that travel direction is correct
            // have we passed startAngle?
            distanceFromThreshold = arc.startAngle - lastPitch;
            traveledPastThreshold = fabs(pitchDelta) >= fabs(distanceFromThreshold);            

            if (traveledPastThreshold) {
                NSLog(@"PHASE 0 end: pitch %.1f  delta: %.2f", pitch, pitchDelta);
                movementPhase = 1;
            }
            
            break;

        case 1:
            traveledPastThreshold = fabs(pitch - arc.startAngle) >= fabs(arc.travel);
            if (traveledPastThreshold) {
                NSLog(@"PHASE 1 end: pitch %.1f  delta: %.2f", pitch, pitchDelta);
                movementPhase = 0;
                [self handleSlap];
            }
            break;

        default:
            break;
    }
    
    lastPitch = pitch;    
}

- (void)printPitch {
	NSLog(@"pitch: %.1f", lastPitch);    
}

@end

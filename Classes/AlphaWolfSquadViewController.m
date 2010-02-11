//
//  AlphaWolfSquadViewController.m
//  AlphaWolfSquad
//
//  Created by Swinkdaddy on 8/20/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "AlphaWolfSquadViewController.h"
#import "SettingsController.h"
#import "HelpController.h"

#define SESSION_END_DELAY_SEC 1.5

#define MAIL_SUBJECT @"Have some high 5s"
#define MAIL_BODY @"Hello friend,\n\nI'm sending you some High 5s. Click the link below to view these puppies on the internets.\n   %@\n\n"

@implementation AlphaWolfSquadViewController

@synthesize alphaview, slapview, sessionEndTimer, congrats;

- (void)dealloc {
  [alphaview release];
  [slapview release];
  [sessionEndTimer release];
  [congrats release];
  [super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];
	AlphaWolfView *aBegin = [[AlphaWolfView alloc] init];
	self.alphaview = aBegin;
	alphaview.frame = CGRectMake(0,0,320,480);
	[aBegin release];
	[self.view addSubview:alphaview];
	
  self.slapview = [[[SlapView alloc] initWithFrame:CGRectMake(0,90,320,326)] autorelease];
  slapview.controller = self;
  //slapview.hidden = YES;
  [alphaview addSubview:slapview];  
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
	[picker setMessageBody:body isHTML:NO]; 	
	picker.navigationBar.barStyle = UIBarStyleBlack; 
	picker.navigationBar.translucent = YES;
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
  SettingsController *c = [[[SettingsController alloc] initWithNibName:@"Settings" bundle:nil] autorelease];
  [self presentModalViewController:c animated:YES];
}

- (void)clickHelp{
  HelpController *c = [[[HelpController alloc] initWithNibName:@"HelpController" bundle:nil] autorelease];
  [self presentModalViewController:c animated:YES];
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
  congrats.hidden = NO;
  [self.view bringSubviewToFront:congrats];
}

- (void)shakeDetected {
  NSLog(@"shake!!!!!");
  [self handleSlap];
}

- (IBAction)tryAgain {
  congrats.hidden = YES;
  [slapview reset];
}

- (IBAction)sendBatch {
  NSString *link = [NSString stringWithFormat:@"http://www.havesomehigh5s.com/staging/includes/sendStuff_iPhone.php?"];
  [self showEmailModalView:MAIL_SUBJECT emailBody:[NSString stringWithFormat:MAIL_BODY, link] recipientList:nil];
}

#pragma mark -


#pragma mark -

@end

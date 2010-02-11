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

@implementation AlphaWolfSquadViewController

@synthesize alphaview, slapview;

- (void)dealloc {
  [alphaview release];
  [slapview release];
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

#pragma mark -
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
  [alphaview clapper];

  AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);

  [self.slapview showSlapEffect];
  [self.slapview incrementCount];
  
  // start timer
  
}

- (void)shakeDetected {
  NSLog(@"shake!!!!!");
  [self handleSlap];
}


@end

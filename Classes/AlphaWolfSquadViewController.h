//
//  AlphaWolfSquadViewController.h
//  AlphaWolfSquad
//
//  Created by Swinkdaddy on 8/20/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AlphaWolfView.h"
#import "High5s.h"
#import "SlapView.h"


@interface AlphaWolfSquadViewController : UIViewController <SlapDelegate, MFMailComposeViewControllerDelegate> {
	AlphaWolfView *alphaview;
  SlapView *slapview;
  NSTimer *sessionEndTimer;
  IBOutlet UIView *congrats;
}

@property (nonatomic, retain) AlphaWolfView *alphaview;
@property (nonatomic, retain) SlapView *slapview;
@property (nonatomic, retain) NSTimer *sessionEndTimer;
@property (nonatomic, retain) IBOutlet UIView *congrats;

- (void)viewDidLoad;
- (void)acceleratedInX:(float)xx Y:(float)yy Z:(float)zz;
- (void)shakeDetected;
- (IBAction)tryAgain;
- (IBAction)sendBatch;
- (NSString*)batchURL;

@end


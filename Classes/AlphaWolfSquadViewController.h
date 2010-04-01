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
#import "OverlayController.h"
#import "CountdownController.h"
//#import "SM3DAR.h"

@interface AlphaWolfSquadViewController : UIViewController <SlapDelegate, MFMailComposeViewControllerDelegate> {
	AlphaWolfView *alphaview;
    SlapView *slapview;
    NSTimer *sessionEndTimer;
    IBOutlet UIView *congrats;
    IBOutlet UILabel *congratsText;
    CountdownController *countdown;
    //    SM3DAR_Controller *sm3dar;
}

@property (nonatomic, retain) AlphaWolfView *alphaview;
@property (nonatomic, retain) SlapView *slapview;
@property (nonatomic, retain) NSTimer *sessionEndTimer;
@property (nonatomic, retain) IBOutlet UIView *congrats;
@property (nonatomic, retain) IBOutlet UILabel *congratsText;
@property (nonatomic, retain) CountdownController *countdown;
//@property (nonatomic, assign) SM3DAR_Controller *sm3dar;

- (void)viewDidLoad;
- (void)acceleratedInX:(float)xx Y:(float)yy Z:(float)zz;
- (void)shakeDetected;
- (IBAction)tryAgain;
- (IBAction)sendBatch;
- (NSString*)batchURL;
- (void)showWelcomeScreen;
- (void)openOverlay:(OverlayController*)newOverlay;
- (void)closeOverlay:(OverlayController*)activeOverlay;
- (void)showConfirmationScreen;
-(NSString*)sorno;

@end


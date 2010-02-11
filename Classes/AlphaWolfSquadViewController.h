//
//  AlphaWolfSquadViewController.h
//  AlphaWolfSquad
//
//  Created by Swinkdaddy on 8/20/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlphaWolfView.h"
#import "High5s.h"
#import "SlapView.h"


@interface AlphaWolfSquadViewController : UIViewController <SlapDelegate> {
	AlphaWolfView *alphaview;
  SlapView *slapview;
}

@property (nonatomic, retain) AlphaWolfView *alphaview;
@property (nonatomic, retain) SlapView *slapview;

- (void)viewDidLoad;
- (void)acceleratedInX:(float)xx Y:(float)yy Z:(float)zz;
- (void)shakeDetected;



@end


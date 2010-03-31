//
//  OverlayController.h
//  AlphaWolfSquad
//
//  Created by P. Mark Anderson on 3/30/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlphaWolfSquadViewController;

@interface OverlayController : UIViewController {
	AlphaWolfSquadViewController *host;
}

@property (nonatomic, retain) AlphaWolfSquadViewController *host;

- (IBAction) close;

@end

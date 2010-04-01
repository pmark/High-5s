//
//  CountdownController.h
//  AlphaWolfSquad
//
//  Created by P. Mark Anderson on 3/31/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CountdownController : UIViewController {
	NSInteger currentCount;
    UIImageView *counterStar;
    BOOL cancel;
}

- (void) startCountdownAfterDelay:(CGFloat)delay;
- (void) startCountdown;
- (void) cancelCountdown;
- (void) beginAnimation;
- (void) animationDidFinish;

@end

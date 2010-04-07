//
//  CountdownController.m
//  AlphaWolfSquad
//
//  Created by P. Mark Anderson on 3/31/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "CountdownController.h"
#import "High5s.h"
#import "AlphaWolfSquadAppDelegate.h"

#define ITERATION_DURATION 0.5
#define ITERATION_DELAY 0.15

@implementation CountdownController

- (void)dealloc {
    [counterStar release];
    [super dealloc];
}

- (void)loadView {    
    self.view = [[[UIView alloc] initWithFrame:CGRectMake(32, 141, 255, 207)] autorelease];
    
    UIImage *stars = [UIImage imageNamed:@"countdown-stars.png"];
    UIImageView *background = [[UIImageView alloc] initWithImage:stars];
    [self.view addSubview:background];
    [background release];
    
    UIImage *starThree = [UIImage imageNamed:@"countdown-3.png"];
    counterStar = [[UIImageView alloc] initWithImage:starThree];    
    counterStar.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:counterStar];
    [counterStar release];
    
    self.view.hidden = YES;
}

- (void) startCountdownAfterDelay:(CGFloat)delay {
    [self performSelector:@selector(startCountdown) withObject:nil afterDelay:delay];
}

- (void) startCountdown {
    cancel = NO;
	currentCount = 3;
    self.view.hidden = NO;
    [self beginAnimation];
}

- (void) cancelCountdown {
    [UIView setAnimationsEnabled:NO];
    cancel = YES;
    self.view.hidden = YES;
    [UIView setAnimationsEnabled:YES];
}

- (void) beginAnimation {
    if (cancel) return;
    self.view.hidden = YES;
    NSString *imgName = [NSString stringWithFormat:@"countdown-%i.png", currentCount];
    counterStar.image = [UIImage imageNamed:imgName];
    
    CGFloat scaleDown = 0.35;
    UIView *v = self.view;
    v.transform = CGAffineTransformMakeScale(scaleDown, scaleDown);
    v.alpha = 0.85;
    self.view.hidden = NO;
    
    // background
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ITERATION_DURATION];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationBeginsFromCurrentState:NO];    
    v.transform = CGAffineTransformMakeScale(1.0, 1.0);
    v.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void) fade {
    UIView *v = self.view;
    v.alpha = 1.0f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    v.transform = CGAffineTransformMakeScale(0.1, 0.1);
    v.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void) animationDidFinish {
    if (cancel) return;
    [APP_DELEGATE clapper];

    if (currentCount > 0) {        
        currentCount--;
        [self performSelector:@selector(beginAnimation) withObject:nil afterDelay:ITERATION_DELAY];

    } else {
        if (!cancel)
            [self performSelector:@selector(fade) withObject:nil afterDelay:1.0];
    }
}


@end

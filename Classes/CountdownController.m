//
//  CountdownController.m
//  AlphaWolfSquad
//
//  Created by P. Mark Anderson on 3/31/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "CountdownController.h"


@implementation CountdownController

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

- (void)dealloc {
    [counterStar release];
    [super dealloc];
}

- (void) startCountdownAfterDelay:(CGFloat)delay {
    [self performSelector:@selector(startCountdown) withObject:nil afterDelay:delay];
}

- (void) startCountdown {
	currentCount = 3;    
    self.view.hidden = NO;
    [self beginAnimation];
}

- (void) cancelCountdown {
    self.view.hidden = YES;    
}

- (void) beginAnimation {
    NSString *imgName = [NSString stringWithFormat:@"countdown-%i.png", currentCount];
    counterStar.image = [UIImage imageNamed:imgName];
    NSLog(@"animating %@", imgName);
    
    CGFloat scaleDown = 0.15;
    UIView *v = self.view;
    v.transform = CGAffineTransformMakeScale(scaleDown, scaleDown);
    v.alpha = 0.85;
    self.view.hidden = NO;
    
    CGFloat duration = 1.0f;

    // background
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationBeginsFromCurrentState:NO];    
    v.transform = CGAffineTransformMakeScale(1.0, 1.0);
    v.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void) hide {
    self.view.hidden = YES;
}

- (void) animationDidFinish {
    NSLog(@"animationDidFinish for %i", currentCount);
    if (currentCount > 0) {
        self.view.hidden = YES;
        // update counter image
        currentCount--;
        [self beginAnimation];

    } else {
        // done
        [self performSelector:@selector(hide) withObject:nil afterDelay:3.0];
    }

}


@end

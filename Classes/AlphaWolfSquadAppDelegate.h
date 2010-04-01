//
//  AlphaWolfSquadAppDelegate.h
//  AlphaWolfSquad
//
//  Created by Swinkdaddy on 8/20/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlphaWolfSquadViewController;

@interface AlphaWolfSquadAppDelegate : NSObject <UIAccelerometerDelegate> {
    UIWindow *window;
    AlphaWolfSquadViewController *viewController;
    NSInteger globalCount;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AlphaWolfSquadViewController *viewController;
@property (nonatomic, assign) NSInteger globalCount;

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;
- (void)clapper;

@end


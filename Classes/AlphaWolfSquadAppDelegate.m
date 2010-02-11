//
//  AlphaWolfSquadAppDelegate.m
//  AlphaWolfSquad
//
//  Created by Swinkdaddy on 8/20/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "AlphaWolfSquadAppDelegate.h"
#import "AlphaWolfSquadViewController.h"

@implementation AlphaWolfSquadAppDelegate

@synthesize window;
@synthesize viewController;

// Constant for the number of times per second (Hertz) to sample acceleration.
#define kAccelerometerFrequency     40

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	// Configure and start the accelerometer
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

// UIAccelerometerDelegate method, called when the device accelerates.
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
  // Update the accelerometer graph view
  [viewController.alphaview acceleratedInX:acceleration.x Y:acceleration.y Z:acceleration.z];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

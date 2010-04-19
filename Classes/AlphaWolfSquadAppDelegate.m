//
//  AlphaWolfSquadAppDelegate.m
//  AlphaWolfSquad
//
//  Created by Swinkdaddy on 8/20/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "AlphaWolfSquadAppDelegate.h"
#import "AlphaWolfSquadViewController.h"
#import "High5s.h"

@implementation AlphaWolfSquadAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize globalCount;

// Constant for the number of times per second (Hertz) to sample acceleration.
//#define kAccelerometerFrequency     40

- (void)getGlobalCount {
	NSURL *url = [NSURL URLWithString:GLOBAL_COUNT_URL];
    NSString *countStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];

    if ([countStr length] > 0) {
		self.globalCount = [countStr integerValue];      
        PREF_SAVE_OBJECT(PREF_KEY_GLOBAL_COUNT, [NSNumber numberWithInt:self.globalCount]);    
    } else {
        self.globalCount = GLOBAL_COUNT_NA;
    }
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	// Configure and start the accelerometer
//    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
//    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    [self getGlobalCount];
}

// UIAccelerometerDelegate method, called when the device accelerates.
//- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
//  // Update the accelerometer graph view
//  [viewController acceleratedInX:acceleration.x Y:acceleration.y Z:acceleration.z];
//}

- (void)clapper {
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:NOTIF_PLAY_CLAP_SOUND object:nil]];    
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

- (void)incrementLocalCountBy:(NSInteger)adder {
    NSNumber *local = (NSNumber*)PREF_READ_OBJECT(PREF_KEY_LOCAL_COUNT);
    NSInteger totalLocal = [local intValue] + adder;
    PREF_SAVE_OBJECT(PREF_KEY_LOCAL_COUNT, [NSNumber numberWithInt:totalLocal]);
}

- (void)incrementGlobalCountBy:(NSInteger)adder {
    NSNumber *global = (NSNumber*)PREF_READ_OBJECT(PREF_KEY_GLOBAL_COUNT);
    NSInteger totalGlobal = [global intValue] + adder;
    PREF_SAVE_OBJECT(PREF_KEY_GLOBAL_COUNT, [NSNumber numberWithInt:totalGlobal]);    
}

@end

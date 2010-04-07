//
//  DeviceMovement.m
//  AlphaWolfSquad
//
//  Created by P. Mark Anderson on 4/5/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "DeviceMovement.h"
#import "DeviceMovementArc.h"


@implementation DeviceMovement

@synthesize name;
@synthesize stages;
@synthesize currentStage;
@synthesize timeout;
@synthesize target;
@synthesize selector;

- (void) dealloc {
    [name release];
    [stages release];
    [super dealloc];
}

- (id) initWithStages:(NSArray*)theStages target:(id)theTarget selector:(SEL)theSelector name:(NSString*)theName {
    if (self = [super init]) {
        self.stages = theStages;
        self.name = theName;
        self.target = theTarget;
        self.selector = theSelector;
    }
    return self;
}




@end

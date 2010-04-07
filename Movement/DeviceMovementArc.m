//
//  DeviceMovementArc.m
//  AlphaWolfSquad
//
//  Created by P. Mark Anderson on 4/5/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "DeviceMovementArc.h"


@implementation DeviceMovementArc

@synthesize axis;
@synthesize startAngle;
@synthesize travel;

+ (DeviceMovementArc*) arcOnAxis:(DeviceMovementAxis)theAxis startAngle:(CGFloat)theStartAngle travel:(CGFloat)theTravel {
    DeviceMovementArc *arc = [[[DeviceMovementArc alloc] init] autorelease];
    arc.axis = theAxis;
    arc.startAngle = theStartAngle;
    arc.travel = theTravel;
    return arc;
}

@end

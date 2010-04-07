//
//  DeviceMovementArc.h
//  AlphaWolfSquad
//
//  Created by P. Mark Anderson on 4/5/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {
    DeviceMovementAxisYaw,
    DeviceMovementAxisPitch,
    DeviceMovementAxisRoll
} DeviceMovementAxis;

@interface DeviceMovementArc : NSObject {
    DeviceMovementAxis axis;
    CGFloat startAngle;
    CGFloat travel;
}

@property (nonatomic, assign) DeviceMovementAxis axis;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat travel;

+ (DeviceMovementArc*) arcOnAxis:(DeviceMovementAxis)theAxis startAngle:(CGFloat)theStartAngle travel:(CGFloat)theTravel;

@end

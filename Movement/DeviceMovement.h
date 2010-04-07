//
//  DeviceMovement.h
//  AlphaWolfSquad
//
//  Created by P. Mark Anderson on 4/5/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//
//  
//  
//  
//  
//  

#import <Foundation/Foundation.h>


@interface DeviceMovement : NSObject {
    NSString *name;
    NSArray *stages;
    NSInteger currentStage;
    NSTimeInterval timeout;
    id target;
    SEL selector;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *stages;
@property (nonatomic, assign) NSInteger currentStage;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;

- (id) initWithStages:(NSArray*)theStages target:(id)theTarget selector:(SEL)theSelector name:(NSString*)theName;

@end

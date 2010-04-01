//
//  SlapView.h
//  AlphaWolfSquad
//
//  Created by P. Mark Anderson on 1/13/10.
//  Copyright 2010 Bordertown Labs, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "High5s.h"

@protocol SlapDelegate;

@interface SlapView : UIView {
    UILabel *countLabel;
    NSInteger slapCount;
    UIImageView *background;
    UIImageView *foreground;
    id<SlapDelegate> controller;
}

@property (nonatomic, retain) UILabel *countLabel;
@property (nonatomic, assign) NSInteger slapCount;
@property (nonatomic, assign) id<SlapDelegate> controller;
@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) UIImageView *foreground;

- (id)initWithCenter:(CGPoint)centerPoint;
- (void)incrementCount;
- (void)showSlapEffect;
- (void)reset;

@end

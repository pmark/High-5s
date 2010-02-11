//
//  SlapView.m
//  AlphaWolfSquad
//
//  Created by P. Mark Anderson on 1/13/10.
//  Copyright 2010 Bordertown Labs, LLC. All rights reserved.
//

#import "SlapView.h"

@implementation SlapView
@synthesize countLabel, slapCount, controller;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    // Initialization code    
    self.backgroundColor = [UIColor clearColor];

    self.countLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 326)] autorelease];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.textColor = [UIColor blackColor];
    countLabel.font = [UIFont systemFontOfSize:128];
    countLabel.shadowColor = [UIColor whiteColor];
    countLabel.shadowOffset = CGSizeMake(2, 2);
    countLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:countLabel];
    

  }
  return self;
}

- (void)showSlapEffect {
}

- (void)incrementCount {
  [self.superview bringSubviewToFront:self];
  self.hidden = NO;
  self.slapCount++;

  countLabel.text = [NSString stringWithFormat:@"%i", slapCount];
  [self bringSubviewToFront:countLabel];
  countLabel.hidden = NO;
  NSLog(@"inc: %i", self.slapCount);
  
}

- (void)drawRect:(CGRect)rect {
  // Drawing code
}


- (void)dealloc {
  [countLabel release];
  [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  NSLog(@"Touched view %@", touch.view);
  
  [self.controller handleSlap];
}

- (void)reset {
  self.slapCount = 0;
  countLabel.hidden = YES;
}

@end

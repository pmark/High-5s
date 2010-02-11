//
//  SlapView.m
//  AlphaWolfSquad
//
//  Created by P. Mark Anderson on 1/13/10.
//  Copyright 2010 Bordertown Labs, LLC. All rights reserved.
//

#import "SlapView.h"


@implementation SlapView
@synthesize countLabel, slapCount;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    // Initialization code
    self.countLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
    self.countLabel.backgroundColor = [UIColor clearColor];
    self.countLabel.textAlignment = UITextAlignmentCenter;
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)increment {
  [self.superview bringSubviewToFront:self];
  self.hidden = NO;
  self.slapCount++;
  self.countLabel.text = [NSString stringWithFormat:@"%i", self.slapCount];
  [self.countLabel sizeToFit];
  NSLog(@"inc: %i", self.slapCount);
}

- (void)drawRect:(CGRect)rect {
  // Drawing code
}


- (void)dealloc {
  [countLabel release];
  [super dealloc];
}


@end

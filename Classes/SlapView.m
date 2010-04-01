//
//  SlapView.m
//  AlphaWolfSquad
//
//  Created by P. Mark Anderson on 1/13/10.
//  Copyright 2010 Bordertown Labs, LLC. All rights reserved.
//

#import "SlapView.h"

@implementation SlapView
@synthesize countLabel, slapCount, controller, background, foreground;

- (id)initWithCenter:(CGPoint)centerPoint {
    if (self = [super init]) {

        self.backgroundColor = [UIColor clearColor];
                
        UIImage *stars = [UIImage imageNamed:@"countdown-stars.png"];
        UIImageView *bg = [[UIImageView alloc] initWithImage:stars];
        [self addSubview:bg];
        self.background = bg;
        [background release];

        // set the frame
        CGFloat w = stars.size.width;
        CGFloat h = stars.size.height;
        CGFloat x = centerPoint.x - (w/2);
        CGFloat y = centerPoint.y - (h/2);
        self.frame = CGRectMake(x, y, w, h);
        
        UIImage *blank = [UIImage imageNamed:@"star-blank.png"];
        UIImageView *fg = [[UIImageView alloc] initWithImage:blank];
        w = blank.size.width;
        h = blank.size.height;
        x = bg.frame.size.width/2 - blank.size.width/2;
        y = bg.frame.size.height/2 - blank.size.height/2;
        fg.frame = CGRectMake(x, y, w, h);
        [self addSubview:fg];
        self.foreground = fg;
        [fg release];

        self.countLabel = [[[UILabel alloc] init] autorelease];
        countLabel.backgroundColor = [UIColor clearColor];
        countLabel.textColor = [UIColor blackColor];
        countLabel.font = [UIFont fontWithName:@"Courier" size:24];
        //countLabel.font = [UIFont systemFontOfSize:32];
        countLabel.shadowColor = [UIColor whiteColor];
        countLabel.shadowOffset = CGSizeMake(2, 2);
        countLabel.textAlignment = UITextAlignmentCenter;
        countLabel.text = @"0";
        [countLabel sizeToFit];
        h = countLabel.frame.size.height;
        countLabel.frame = CGRectMake(4, (80-h/2), self.frame.size.width, h);
        [self addSubview:countLabel];
        self.hidden = YES;
    }

    return self;
}

- (void)showSlapEffect {
    self.hidden = NO;
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
    [background release];
    [foreground release];
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

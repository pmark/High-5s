//
//  SlapView.h
//  AlphaWolfSquad
//
//  Created by P. Mark Anderson on 1/13/10.
//  Copyright 2010 Bordertown Labs, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SlapView : UIView {
  UILabel *countLabel;
  NSInteger slapCount;
}

@property (nonatomic, retain) UILabel *countLabel;
@property (nonatomic, assign) NSInteger slapCount;

- (void)increment;

@end

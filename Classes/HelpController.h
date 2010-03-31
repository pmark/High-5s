//
//  HelpController.h
//  AlphaWolfSquad
//
//  Created by P. Mark Anderson on 2/10/10.
//  Copyright 2010 Bordertown Labs, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayController.h"

@interface HelpController : OverlayController {
  IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@end

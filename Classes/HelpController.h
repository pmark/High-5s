//
//  HelpController.h
//  AlphaWolfSquad
//
//  Created by P. Mark Anderson on 2/10/10.
//  Copyright 2010 Bordertown Labs, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelpController : UIViewController {
  IBOutlet UITextView *textView;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;

- (IBAction)close;

@end

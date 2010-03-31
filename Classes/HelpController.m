//
//  HelpController.m
//  AlphaWolfSquad
//
//  Created by P. Mark Anderson on 2/10/10.
//  Copyright 2010 Bordertown Labs, LLC. All rights reserved.
//

#import "HelpController.h"


@implementation HelpController

@synthesize scrollView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *img = [UIImage imageNamed:@"HelpContent.png"];
    [scrollView setContentSize:CGSizeMake(img.size.width,
                               img.size.height)];
    
//    UIImageView *content = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HelpContent.png"]];
//    [scrollView addSubview:content];
//    [content release];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [scrollView flashScrollIndicators];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
  [scrollView release];
  [super dealloc];
}


@end
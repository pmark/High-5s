//  Created by Swinkdaddy on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>
@class AlphaWolfSquadViewController;

@interface AlphaWolfView : UIView {
	// screen 1
	UIButton *beginButton;
	UIImageView *mike;
	UIImageView *scott;
	UIImageView *mikeArm;
	UIImageView *scottArm;
	UIImageView *starR;
	UIImageView *starL;
	UIImageView *header;
	// screen 2
	UIImageView *burst;
	UIImageView *top;
	UIImageView *bottom;
	UIImageView *instruction;
	UIImageView *hand;
	UILabel *instTxt;
	UIButton *settingsButton;
	UIButton *helpButton;
	UIButton *startButton;
    
    AlphaWolfSquadViewController *controller;
	SystemSoundID clapSound;  
    BOOL beginButtonClicked;
}
// screen 1
@property (nonatomic, retain)UIButton *beginButton;
@property (nonatomic, retain)UIImageView *mike;
@property (nonatomic, retain)UIImageView *scott;
@property (nonatomic, retain)UIImageView *mikeArm;
@property (nonatomic, retain)UIImageView *scottArm;
@property (nonatomic, retain)UIImageView *starR;
@property (nonatomic, retain)UIImageView *starL;
@property (nonatomic, retain)UIImageView *header;
// screen 2
@property (nonatomic, retain)UIButton *startButton;
@property (nonatomic, retain)UIButton *settingsButton;
@property (nonatomic, retain)UIButton *helpButton;
@property (nonatomic, retain)UILabel *instTxt;
@property (nonatomic, retain)UIImageView *top;
@property (nonatomic, retain)UIImageView *bottom;
@property (nonatomic, retain)UIImageView *hand;
@property (nonatomic, retain)UIImageView *burst;
@property (nonatomic, retain)UIImageView *instruction;
@property (nonatomic, retain)AlphaWolfSquadViewController *controller;
@property (nonatomic, assign)BOOL beginButtonClicked;


// create object
- (void)createBeginButton;
- (void)createMike;
- (void)createScott;
- (void)createMikeArm;
- (void)createScottArm;
- (void)createStarR;
- (void)createStarL;
- (void)createHeader;
- (void)setUpInitView;

- (void)createHand;
- (void)createTop;
- (void)createBottom;
- (void)createBurst;
- (void)createSettings;
- (void)createHelp;

// actions
- (void)DropThatShit;
- (void)DropThatShit2;
- (void)tearDownScreen1;
- (void)killScreen1;
- (void)killScreen2;

// sound
- (void)soundObject:(NSString *)file type:(NSString *)type;
- (void)clapper;

-(void)acceleratedInX:(float)xx Y:(float)yy Z:(float)zz;

// animation classes
- (void)pulse:(id)MC 
      toScale:(float)toScale 
    fromScale:(float)fromScale 
         time:(float)time;
- (void)ITween:(id)MC 
	  instance:(NSString *)instance
		   toX:(float)toX 
		   toY:(float)toY 
		   toO:(float)toO 
		 fromX:(float)fromX 
		 fromY:(float)fromY 
		 fromO:(float)fromO 
		 timeA:(float)timeA 
		 timeO:(float)timeO
		bounce:(BOOL)bounce
		  ease:(NSString *)ease;


-(void)setupAudio;

@end


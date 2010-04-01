
#import "High5s.h"
#import "AlphaWolfView.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AlphaWolfSquadViewController.h"
#import "AlphaWolfSquadAppDelegate.h"

@implementation AlphaWolfView

// screen 1 elements
@synthesize beginButton;
@synthesize mike;
@synthesize scott;
@synthesize mikeArm;
@synthesize scottArm;
@synthesize starR;
@synthesize starL;
@synthesize header;

//screen 2 elements
@synthesize burst;
@synthesize top;
@synthesize bottom;
@synthesize instruction;
@synthesize hand;
@synthesize instTxt;
@synthesize settingsButton;
@synthesize helpButton;
@synthesize startButton;
@synthesize globalCounterLabel;

@synthesize controller;
@synthesize beginButtonClicked;

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
        beginButtonClicked = NO;
		[self setUpInitView];
        [self setupAudio];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clapper) name:NOTIF_PLAY_CLAP_SOUND object:nil];
	}
	return self;
}


- (void)setUpInitView {
	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(createStarR) userInfo:nil repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(createStarL) userInfo:nil repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(createHeader) userInfo:nil repeats:NO];
	
	[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(clapper) userInfo:nil repeats:NO];
	
	[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(createMikeArm) userInfo:nil repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(createScottArm) userInfo:nil repeats:NO];
	
	[NSTimer scheduledTimerWithTimeInterval:2.2 target:self selector:@selector(createBeginButton) userInfo:nil repeats:NO];	
	
	[self createMike];
	[self createScott];
}

- (BOOL)canBecomeFirstResponder {  
    return YES; 
} 

- (void)buildInteraction{
	[self createBurst];
	[self createHand];
	[self createTop];
	[self createBottom];
	
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(animateHand) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createSettings) userInfo:nil repeats:NO];	
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createHelp) userInfo:nil repeats:NO];	
	[NSTimer scheduledTimerWithTimeInterval:2.05 target:self selector:@selector(showWelcomeScreen) userInfo:nil repeats:NO];
}

- (void)showWelcomeScreen {
    [controller showWelcomeScreen];
    controller.slapview.userInteractionEnabled = YES;
}

//-----------ITWEEN---------------------------------------------------------------------------------
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
		  ease:(NSString *)ease
{
	
	CALayer *welcomeLayer = MC;
	
	CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	bounceAnimation.removedOnCompletion = NO;
	
	CGFloat animationDuration = timeA;
	CGFloat opacityDuration = timeO;
	
	CGMutablePathRef thePath = CGPathCreateMutable();
	if(bounce){
		CGFloat midX = toX;
		CGFloat midY = toY;
		CGFloat originalOffsetX = fromX - midX;
		CGFloat originalOffsetY = fromY - midY;
		CGFloat offsetDivider = 4.0;
        
		BOOL stopBouncing = NO;
        
		CGPathMoveToPoint(thePath, NULL,fromX, fromY);
		CGPathAddLineToPoint(thePath, NULL, midX, midY);
        
		while (stopBouncing != YES) {
			CGPathAddLineToPoint(thePath, NULL, midX + originalOffsetX/offsetDivider, midY + originalOffsetY/offsetDivider);
			CGPathAddLineToPoint(thePath, NULL, midX, midY);
			offsetDivider += 4;
			animationDuration += 1/offsetDivider;
			if ((abs(originalOffsetX/offsetDivider) < 6) && (abs(originalOffsetY/offsetDivider) < 6)) {
				stopBouncing = YES;
			}
		}
	}else{
		
		CGPathMoveToPoint(thePath, NULL, fromX, fromY);
		CGPathAddLineToPoint(thePath, NULL, toX, toY);
        
	}
    
	bounceAnimation.path = thePath;
	bounceAnimation.duration = animationDuration;
	CGPathRelease(thePath);
	
	CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	transformAnimation.fromValue = [NSNumber numberWithFloat:fromO];
	transformAnimation.toValue = [NSNumber numberWithFloat:toO];
	//transformAnimation.removedOnCompletion = NO;
	transformAnimation.duration = opacityDuration;
	
	
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	
	
	[theGroup setDelegate:self];
	[theGroup setDuration:animationDuration];
	[theGroup setValue:instance forKey:@"ITweenGroup"];
	//theGroup.beginTime = CACurrentMediaTime()+delay;
	if(ease == @"in-out"){
		theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	}
	if(ease == @"out"){
		theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	}else{
		theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
	}
	
	theGroup.animations = [NSArray arrayWithObjects:bounceAnimation, transformAnimation,  nil];
	
	[welcomeLayer addAnimation:theGroup forKey:@"animate"];
	
	// End of animation state
	welcomeLayer.opacity = toO;
	welcomeLayer.position = CGPointMake(toX,toY);
    
	
}
-(void)pulse:(id)MC toScale:(float)toScale fromScale:(float)fromScale time:(float)time {
	CABasicAnimation * pulseObject;
	pulseObject = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	pulseObject.duration = time;
	pulseObject.repeatCount = 0;
	pulseObject.autoreverses = YES;
	pulseObject.fromValue=[NSNumber numberWithFloat:fromScale];
	pulseObject.toValue=[NSNumber numberWithFloat:toScale];
	[MC addAnimation:pulseObject forKey:@"scaler"];
}

//---------UNIV BUTTON----------------------------------------------------------------------------
+ (UIButton *)buttonWithTitle:	(NSString *)title
						  tag:(NSString *)tag
					   target:(id)target
					 selector:(SEL)selector
						frame:(CGRect)frame
						image:(UIImage *)image
				 imagePressed:(UIImage *)imagePressed
				darkTextColor:(BOOL)darkTextColor
{	
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = frame;
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];	
	if (darkTextColor){
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}else{
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	button.backgroundColor = [UIColor clearColor];
	return button;
}

//----------------------------CREATE OBJECTS------------------------------------------------------------------------

- (void)createBeginButton{	
	UIImage *buttonBackground = [UIImage imageNamed:@"begin.png"];
	UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"beginOver.png"];
	
	CGRect frame = CGRectMake(92, 20, 156, 156);
	
	beginButton = [AlphaWolfView buttonWithTitle:@" "
											 tag:@"beginButton"
										  target:self		
										selector:@selector(clickBegin)
										   frame:frame
										   image:buttonBackground
									imagePressed:buttonBackgroundPressed
								   darkTextColor:YES];
    
	[self addSubview:beginButton];
	
	[self bringSubviewToFront:beginButton];
	
	[self ITween:beginButton.layer
		instance:@"beginB"
			 toX:160 
			 toY:370 
			 toO:1 
		   fromX:160
		   fromY:0 
		   fromO:0
		   timeA:1.8
		   timeO:0.1
		  bounce:TRUE
			ease:@"out"
	 ];
}
- (void)createMike{	
	mike = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 127, 257)];
	[mike setImage:[UIImage imageNamed:@"screen1_mike.png"]];
	mike.center = CGPointMake(400,210);
	[self addSubview:mike];
	[self ITween:mike.layer
		instance:@"mikeHead"
			 toX:257
			 toY:230
			 toO:1 
		   fromX:mike.center.x
		   fromY:mike.center.y
		   fromO:0
		   timeA:0.8
		   timeO:0.8
		  bounce:FALSE
			ease:@"in"
	 ];
}
- (void)createScott{	
	scott = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 133, 255)];
	[scott setImage:[UIImage imageNamed:@"screen1_scott.png"]];
	scott.center = CGPointMake(-133,210);
	[self addSubview:scott];
	[self ITween:scott.layer
		instance:@"scottHead"
			 toX:66
			 toY:230
			 toO:1 
		   fromX:scott.center.x
		   fromY:scott.center.y
		   fromO:0
		   timeA:0.8
		   timeO:0.8
		  bounce:FALSE
			ease:@"in"
	 ];	
}
- (void)createMikeArm{	
	mikeArm = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 155, 223)];
	[mikeArm setImage:[UIImage imageNamed:@"screen1_mike_arm.png"]];
	mikeArm.center = CGPointMake(400,230);
	[self addSubview:mikeArm];
	[self bringSubviewToFront:mike];
	[self ITween:mikeArm.layer
		instance:@"mikeArm"
			 toX:233
			 toY:170
			 toO:1 
		   fromX:mikeArm.center.x
		   fromY:mikeArm.center.y
		   fromO:1
		   timeA:0.2
		   timeO:0.2
		  bounce:FALSE
			ease:@"in"
	 ];
}
- (void)createScottArm{	
	scottArm = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 178, 235)];
	[scottArm setImage:[UIImage imageNamed:@"screen1_scott_arm.png"]];
	scottArm.center = CGPointMake(-133,230);
	[self addSubview:scottArm];
	[self bringSubviewToFront:scott];
	[self ITween:scottArm.layer
		instance:@"scottArm"
			 toX:90
			 toY:170
			 toO:1 
		   fromX:scottArm.center.x
		   fromY:scottArm.center.y
		   fromO:1
		   timeA:0.2
		   timeO:0.2
		  bounce:FALSE
			ease:@"in"
	 ];
	
}
- (void)createStarR{	
	starR = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 103, 83)];
	[starR setImage:[UIImage imageNamed:@"screen1_star_r.png"]];
	starR.center = CGPointMake(180,530);
	[self addSubview:starR];
	[self ITween:starR.layer
		instance:@"starr"
			 toX:266
			 toY:421
			 toO:1 
		   fromX:starR.center.x
		   fromY:starR.center.y
		   fromO:0
		   timeA:0.4
		   timeO:0.4
		  bounce:FALSE
			ease:@"in"
	 ];
}
- (void)createStarL{	
	starL = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 103, 83)];
	[starL setImage:[UIImage imageNamed:@"screen1_star_l.png"]];
	starL.center = CGPointMake(120,530);
	[self addSubview:starL];
	[self ITween:starL.layer
		instance:@"starl"
			 toX:54
			 toY:421
			 toO:1 
		   fromX:starL.center.x
		   fromY:starL.center.y
		   fromO:0
		   timeA:0.4
		   timeO:0.4
		  bounce:FALSE
			ease:@"in"
	 ];
}
- (void)createHeader{	
	header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 303, 32)];
	[header setImage:[UIImage imageNamed:@"screen1_title.png"]];
	header.center = CGPointMake(160,-18);
	[self addSubview:header];
	[self ITween:header.layer
		instance:@"header"
			 toX:160
			 toY:28
			 toO:1 
		   fromX:header.center.x
		   fromY:header.center.y
		   fromO:0
		   timeA:0.4
		   timeO:0.4
		  bounce:FALSE
			ease:@"in"
	 ];
}
// screen 2
- (void)createBurst{	
	burst = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[burst setImage:[UIImage imageNamed:@"screen2_bkg.png"]];
	burst.center = CGPointMake(160,240);
	burst.alpha = 0.0f;
	[self addSubview:burst];
	[self ITween:burst.layer
		instance:@"burst"
			 toX:burst.center.x
			 toY:burst.center.y
			 toO:1 
		   fromX:burst.center.x
		   fromY:burst.center.y
		   fromO:0
		   timeA:0.8
		   timeO:0.8
		  bounce:FALSE
			ease:@"in"
	 ];
}
- (void)createHand{	
	hand = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 274, 372)];
	[hand setImage:[UIImage imageNamed:@"screen2_hand.png"]];
	hand.center = CGPointMake(160,770);
	[self addSubview:hand];
    
}
- (void)animateHand{
	[self ITween:hand.layer
		instance:@"hand"
			 toX:160
			 toY:280
			 toO:1 
		   fromX:hand.center.x
		   fromY:hand.center.y
		   fromO:1
		   timeA:1.0
		   timeO:1.0
		  bounce:FALSE
			ease:@"in"
	 ];	
    
}

- (void)updateGlobalCounterLabel {
    NSInteger count = APP_DELEGATE.globalCount;
    if (count == GLOBAL_COUNT_NA) {
        globalCounterLabel.text = @"N/A";
    } else {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
        globalCounterLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:count]];
        [numberFormatter release];        
    }
}

- (void)createTop{	
	top = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 92)];
	[top setImage:[UIImage imageNamed:@"screen2_header.png"]];
	top.center = CGPointMake(160,-50);
	[self addSubview:top];
	[self ITween:top.layer
		instance:@"top"
			 toX:160
			 toY:46
			 toO:1 
		   fromX:top.center.x
		   fromY:top.center.y
		   fromO:0
		   timeA:0.8
		   timeO:0.8
		  bounce:FALSE
			ease:@"in"
	 ];
    
    
    //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(180, 142, 153, 27)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(155, 55, 153, 30)];
    label.font = [UIFont fontWithName:@"Courier" size:20];
    label.textAlignment = UITextAlignmentRight;
    [top addSubview:label];
    self.globalCounterLabel = label;
    [label release];
    
    [self updateGlobalCounterLabel];
}

- (void)createBottom{	
	bottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
	[bottom setImage:[UIImage imageNamed:@"screen2_footer.png"]];
	bottom.center = CGPointMake(160,530);
	[self addSubview:bottom];
	[self ITween:bottom.layer
		instance:@"top"
			 toX:160
			 toY:436
			 toO:1 
		   fromX:bottom.center.x
		   fromY:bottom.center.y
		   fromO:0
		   timeA:0.8
		   timeO:0.8
		  bounce:FALSE
			ease:@"in"
	 ];
}
- (void)createSettings{	
	UIImage *buttonBackground = [UIImage imageNamed:@"screen2_settings.png"];
	UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"screen2_settingsOver.png"];
	
	CGRect frame = CGRectMake(-68, 30, 134, 26);
    
	settingsButton = [AlphaWolfView buttonWithTitle:@" "
                                                tag:@"settingsButton"
                                             target:self.controller		
                                           selector:@selector(clickSettings)
                                              frame:frame
                                              image:buttonBackground
                                       imagePressed:buttonBackgroundPressed
                                      darkTextColor:YES];
	
    //  settingsButton.hidden = YES;
	[self addSubview:settingsButton];
    
	[self ITween:settingsButton.layer
		instance:@"settingsB"
			 toX:68
			 toY:30
			 toO:1 
		   fromX:settingsButton.center.x
		   fromY:settingsButton.center.y
		   fromO:0
		   timeA:1.0
		   timeO:1.0
		  bounce:FALSE
			ease:@"out"
	 ];
}
- (void)createHelp{	
	UIImage *buttonBackground = [UIImage imageNamed:@"screen2_help.png"];
	UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"screen2_helpOver.png"];
	
	CGRect frame = CGRectMake(360, 30, 79, 23);
	
	helpButton = [AlphaWolfView buttonWithTitle:@" "
                                            tag:@"helpButton"
                                         target:self.controller	
                                       selector:@selector(clickHelp)
                                          frame:frame
                                          image:buttonBackground
                                   imagePressed:buttonBackgroundPressed
                                  darkTextColor:YES];
	
	[self addSubview:helpButton];
	
	[self ITween:helpButton.layer
		instance:@"helpB"
			 toX:280
			 toY:30
			 toO:1 
		   fromX:helpButton.center.x
		   fromY:helpButton.center.y
		   fromO:0
		   timeA:1.0
		   timeO:1.0
		  bounce:FALSE
			ease:@"in"
	 ];
	[self bringSubviewToFront:helpButton];
	[self bringSubviewToFront:settingsButton];
}




//-------------------- ACTIONS --------------------------------------------------------
-(void)clickBegin{
    if (beginButtonClicked)
        return;
    beginButtonClicked = YES;
    
	[self pulse:beginButton toScale:1.05 fromScale:1 time:0.2];
	[self tearDownScreen1];
	
}
-(void)tearDownScreen1{
	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(DropThatShit) userInfo:nil repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(DropThatShit2) userInfo:nil repeats:NO];
	
}

- (void)DropThatShit{
    [self ITween:beginButton.layer
        instance:@"dropIt1"
             toX:160 
             toY:530 
             toO:0 
           fromX:beginButton.center.x 
           fromY:beginButton.center.y 
           fromO:1
           timeA:0.3
           timeO:0.3
          bounce:FALSE
            ease:@"out"
     ];
}
- (void)DropThatShit2{
	[self ITween:mike.layer instance:@"mikeHead" toX:380  toY:210 toO:1  fromX:mike.center.x  fromY:mike.center.y fromO:1  timeA:1  timeO:1 bounce:FALSE ease:@"out" ];
	[self ITween:scott.layer instance:@"scottHead" toX:-133  toY:210 toO:1  fromX:scott.center.x  fromY:scott.center.y fromO:1  timeA:1  timeO:1 bounce:FALSE ease:@"out" ];
	[self ITween:mikeArm.layer instance:@"mikeArm" toX:400  toY:170 toO:0  fromX:mikeArm.center.x  fromY:mikeArm.center.y fromO:1  timeA:0.5  timeO:0.5 bounce:FALSE ease:@"out" ];
	[self ITween:scottArm.layer instance:@"scottArm" toX:-160  toY:170 toO:0  fromX:scottArm.center.x  fromY:scottArm.center.y fromO:1  timeA:0.5  timeO:0.5 bounce:FALSE ease:@"out" ];
	[self ITween:header.layer instance:@"header" toX:160  toY:-20 toO:0  fromX:header.center.x  fromY:header.center.y fromO:1  timeA:1  timeO:1 bounce:FALSE ease:@"out" ];
	[self ITween:starL.layer instance:@"starl" toX:120  toY:530 toO:0  fromX:starL.center.x  fromY:starL.center.y fromO:1  timeA:1  timeO:1 bounce:FALSE ease:@"out" ];
	[self ITween:starR.layer instance:@"starKiller" toX:180  toY:530 toO:0  fromX:starR.center.x  fromY:starR.center.y fromO:1  timeA:1  timeO:1 bounce:FALSE ease:@"out" ];
	
}

- (void)animationDidStop:(CAAnimation *)theGroup finished:(BOOL)flag {
	//Animation delegate method called when the animation's finished:
	id instance =[theGroup valueForKey:@"ITweenGroup"];
    if([instance isEqualToString:@"scottArm"]){
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:instance delegate:self cancelButtonTitle:@"sweet!" otherButtonTitles:nil];
        //[alert show];
        //[alert release];
        //[self clapper];
    }
	if([instance isEqualToString:@"starKiller"]){
		[self killScreen1];
		[self buildInteraction];
	}
	
	self.userInteractionEnabled = YES;
}


//-------------------- SOUND --------------------------------------------------------
-(void)setupAudio {
	NSURL* soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"clap" ofType:@"wav"]];
	OSStatus status = AudioServicesCreateSystemSoundID((CFURLRef)soundURL, &clapSound);
	if (status != kAudioServicesNoError)
		NSLog(@"Sound creation error: %@", status);    
}

-(void)clapper {
    
	//[self soundObject:@"clap" type:@"wav"];
    //AudioServicesPlaySystemSound(pmph);
	AudioServicesPlayAlertSound(clapSound);
}
-(void)soundObject:(NSString *)file type:(NSString *)type {
	SystemSoundID pmph;
	id sndPath = [[NSBundle mainBundle]
				  pathForResource:file
				  ofType:type
				  inDirectory:@"/"];
	CFURLRef baseURL = (CFURLRef) [[NSURL alloc] initFileURLWithPath:sndPath];
	AudioServicesCreateSystemSoundID (baseURL, &pmph);
	AudioServicesPlaySystemSound(pmph);
}
//-------------------- ACTIONS --------------------------------------------------------
-(void)acceleratedInX:(float)xx Y:(float)yy Z:(float)zz{
	//hand do that mojo here
}
//-------------------- DEALLOC --------------------------------------------------------
-(void)killScreen1{
	[beginButton removeFromSuperview];
	[scottArm removeFromSuperview];
	[scott removeFromSuperview];
	[mike removeFromSuperview];
	[mikeArm removeFromSuperview];
	[starL removeFromSuperview];
	[starR removeFromSuperview];
	[header removeFromSuperview];
    
}

-(void)killScreen2{	
    [burst release];
    [top release];
    [bottom release];
    [instruction release];
    [hand release];
    [instTxt release];
    [settingsButton release];
    [helpButton release];
    [startButton release];
    [globalCounterLabel release];
}

- (void)dealloc {
	[self killScreen1];
	[self killScreen2];
    
    [controller release];
    
	[super dealloc];	
}


/*
 - (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
 NSLog(@"[AWV] motionBegan");
 [super motionBegan: motion withEvent: event];
 if (motion == UIEventSubtypeMotionShake) {
 NSLog(@"shake!!!!!");
 }
 }
 
 - (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
 [super motionCancelled: motion withEvent: event];
 }
 
 - (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
 [super motionEnded: motion withEvent: event];
 }  
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    if (point.y > 90 && point.y < 413) {
        [self.controller handleSlap];        
    }
}

@end

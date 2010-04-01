/*
 *  High5s.h
 *  AlphaWolfSquad
 *
 *  Created by P. Mark Anderson on 2/11/10.
 *  Copyright 2010 Bordertown Labs, LLC. All rights reserved.
 *
 */

@protocol SlapDelegate
- (void)handleSlap;
@end

#define HIDE_SETTINGS_BUTTON 1
#define NOTIF_PLAY_CLAP_SOUND @"NOTIF_PLAY_CLAP_SOUND"
#define APP_DELEGATE (AlphaWolfSquadAppDelegate*)[[UIApplication sharedApplication] delegate]

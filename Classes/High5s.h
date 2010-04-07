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

#define RELEASE(object) if(object){[object release]; object=nil;}
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 180.0 / M_PI)

#define PREF_SAVE_OBJECT(name, value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:name]
#define PREF_READ_OBJECT(name) [[NSUserDefaults standardUserDefaults] objectForKey:name]
#define PREF_READ_ARRAY(name) (NSArray*)PREF_READ_OBJECT(name)
#define PREF_READ_DICTIONARY(name) (NSDictionary*)PREF_READ_OBJECT(name)
#define PREF_SAVE_BOOL(name, value) [[NSUserDefaults standardUserDefaults] setBool:value forKey:name]
#define PREF_READ_BOOL(name) [[NSUserDefaults standardUserDefaults] boolForKey:name]
#define PREF_EXISTS(name) ([[NSUserDefaults standardUserDefaults] objectForKey:name] != nil)

#define HIDE_SETTINGS_BUTTON 1
#define NOTIF_PLAY_CLAP_SOUND @"NOTIF_PLAY_CLAP_SOUND"
#define APP_DELEGATE ((AlphaWolfSquadAppDelegate*)[[UIApplication sharedApplication] delegate])
#define GLOBAL_COUNT_URL @"http://www.havesomehigh5s.com/includes/totalCount.php"
#define GLOBAL_COUNT_NA -1
#define PREF_KEY_LOCAL_COUNT @"PREF_KEY_LOCAL_COUNT"

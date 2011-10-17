/*
 * Tweak: LockVibe
 * Version: 2.1
 * Created by EvilPenguin
 *
 * Enjoy :0)
 */

#import <AudioToolbox/AudioToolbox.h>
#import <GraphicsServices/GraphicsServices.h>

#define LOCK_VIBE_PLIST @"/var/mobile/Library/Preferences/us.nakedproductions.lockvibe.plist"
#define listenToNotification$withCallBack(notification, callback); CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)&callback, CFSTR(notification), NULL, CFNotificationSuspensionBehaviorHold);
#define isSettingEnabled(settingName) [plistDict objectForKey:settingName] ? [[plistDict objectForKey:settingName] boolValue] : NO

static NSMutableDictionary *plistDict = nil;
static BOOL isEnabled;
static void loadSettings(void) {
	if (plistDict) {
		[plistDict release];
		plistDict = nil;
	}
	plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:LOCK_VIBE_PLIST];
	isEnabled = isSettingEnabled(@"LockVibeEnabled");
}

#pragma mark -
#pragma mark == SpringBoard ==

%hook SpringBoard 
- (void)autoLock {
	if (isSettingEnabled(@"AutoLock")) AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	%orig;
}

- (void)menuButtonDown:(GSEventRef)down {
	if (isSettingEnabled(@"MenuDown")) AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	%orig(down);
}

- (void)lockButtonDown:(GSEventRef)down {
	if (isSettingEnabled(@"LockDown")) AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	%orig(down);
}
%end

#pragma mark -
#pragma mark == SBSearchView ==

%hook SBSearchView
- (void)keyboardDidShow:(id)keyboard {
	if (isSettingEnabled(@"ShowSearch")) AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	%orig(keyboard);
}
%end

#pragma mark -
#pragma mark == SBApplication ==

%hook SBApplication
- (void)launchSucceeded:(BOOL)succeeded {
	if (isSettingEnabled(@"AppLaunch")) AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	%orig(succeeded);
}

- (void)exitedCommon {
	if (isSettingEnabled(@"AppClose")) AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	%orig;
}
%end

#pragma mark -
#pragma mark == VolumeControl ==

%hook VolumeControl
- (void) increaseVolume {
	if (isSettingEnabled(@"VolumeIncrease")) AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	%orig;
}

- (void) decreaseVolume {
	if (isSettingEnabled(@"VolumeDecrease")) AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	%orig;
}
%end
#pragma mark -
#pragma mark == SBLowPowerAlertItem ==

%hook SBLowPowerAlertItem
- (id)initWithLevel:(unsigned)level {
	if (isSettingEnabled(@"PowerAlert")) AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	return %orig(level);
}
%end

%ctor {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	%init;
	listenToNotification$withCallBack("com.understruction.lockvibe.update", loadSettings);
	loadSettings();
	[pool drain];
}
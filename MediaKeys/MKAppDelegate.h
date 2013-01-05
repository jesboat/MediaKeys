//
//  MKAppDelegate.h
//  MediaKeys
//
//  Created by Jonathan Sailor on 2013-01-05.
//  Copyright (c) 2013 Jonathan Sailor.
//


#import <Cocoa/Cocoa.h>

#import "../SPMediaKeyTap/SPMediaKeyTap.h"
#import "MKExecutor.h"


@interface MKAppDelegate : NSObject <NSApplicationDelegate>

#pragma mark Connections to the UI

@property (assign) IBOutlet NSPanel* disabledWarningWindow;

@property (assign) IBOutlet NSWindow* preferencesWindow;

- (IBAction)showPreferencesWindow:(id)sender;

#pragma mark Dealing with media keys

@property (assign) BOOL tapEnabled;

@property (assign) SPMediaKeyTap* keyTap;

- (NSString*)defaultsKeyForKeycode:(int)keycode;

- (void)mediaKeyTap:(SPMediaKeyTap*)keyTap receivedMediaKeyEvent:(NSEvent*)event;

- (void)gotMediaKeyCode:(int)code flags:(int)flags down:(BOOL)down up:(BOOL)up repeat:(BOOL)repeat;

@end


#pragma mark Keys for preferences dictionary

extern NSString* const kMKPlayPauseCmdKey;
extern NSString* const kMKRewindCmdKey;
extern NSString* const kMKForwardCmdKey;

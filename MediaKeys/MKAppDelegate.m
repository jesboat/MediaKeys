//
//  MKAppDelegate.m
//  MediaKeys
//
//  Created by Jonathan Sailor on 2013-01-05.
//  Copyright (c) 2013 Jonathan Sailor.
//

#import "MKAppDelegate.h"


NSString* const kMKPlayPauseCmdKey = @"onPlayPause";
NSString* const kMKRewindCmdKey = @"onRewind";
NSString* const kMKForwardCmdKey = @"onForward";


static void setDefault(NSString* key, id val) {
    [[NSUserDefaults standardUserDefaults] registerDefaults: @{key: val}];
}


@implementation MKAppDelegate

+(void)initialize;
{
    if ([self class] != [MKAppDelegate class])
        return;

    // Register defaults for the whitelist of apps that want to use media keys
    setDefault(kMediaKeyUsingBundleIdentifiersDefaultsKey,
               [SPMediaKeyTap defaultMediaKeyUserBundleIdentifiers]);

    // Default commands do nothing
    setDefault(kMKPlayPauseCmdKey, @"");
    setDefault(kMKRewindCmdKey, @"");
    setDefault(kMKForwardCmdKey, @"");
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.keyTap = [[SPMediaKeyTap alloc] initWithDelegate:self];

    if([SPMediaKeyTap usesGlobalMediaKeyTap]) {
        self.tapEnabled = YES;
        [self.keyTap startWatchingMediaKeys];
    } else {
        self.tapEnabled = NO;
        NSLog(@"Media key monitoring disabled");
        [self.disabledWarningWindow makeKeyAndOrderFront:self];
        [[NSApplication sharedApplication] unhide:self];
    }
}

- (IBAction)showPreferencesWindow:(id)sender
{
    [self.preferencesWindow makeKeyAndOrderFront:self];
}

- (NSString*)defaultsKeyForKeycode:(int)keycode;
{
    switch (keycode) {
        case NX_KEYTYPE_PLAY:   return kMKPlayPauseCmdKey;
        case NX_KEYTYPE_FAST:   return kMKForwardCmdKey;
        case NX_KEYTYPE_REWIND: return kMKRewindCmdKey;
        default:
            NSLog(@"Unrecognized media key %d pressed. Ignoring.", keycode);
            return nil;
        // XXX: implement more of the cases defined in hidsystem/ev_keymap.h
    }
}

-(void)mediaKeyTap:(SPMediaKeyTap*)keyTap receivedMediaKeyEvent:(NSEvent*)event;
{
    NSAssert([event type] == NSSystemDefined
             && [event subtype] == SPSystemDefinedEventMediaKeys,
             @"Unexpected NSEvent in mediaKeyTap:receivedMediaKeyEvent:");

    // This is officially icky.
    long keyEvData     = [event data1];
    int  keyCode       = ((keyEvData & 0xFFFF0000) >> 16);
    int  keyFlags      = ((keyEvData & 0x0000FFFF));
    BOOL keyDown       = ((keyEvData & 0x0000FF00) >> 8  ==  0xA);
    BOOL keyUp         = ((keyEvData & 0x0000FF00) >> 8  ==  0xB);
    BOOL keyRepeat     = ((keyEvData & 0x00000001)       ? YES : NO);

    [self gotMediaKeyCode:keyCode flags:keyFlags down:keyDown up:keyUp repeat:keyRepeat];
}

- (void)gotMediaKeyCode:(int)code flags:(int)flags
                   down:(BOOL)down up:(BOOL)up repeat:(BOOL)repeat;
{
    if (up) {
        NSString* defaultsKey = [self defaultsKeyForKeycode:code];
        if (defaultsKey == nil)
            return;
        NSString* cmd = [[NSUserDefaults standardUserDefaults] stringForKey:defaultsKey];
        if (cmd == nil || [cmd length] == 0)
            return;
        [MKExecutor spawnCommand:cmd];
    }
}

@end

//
//  MKExecutor.m
//  MediaKeys
//
//  Created by Jonathan Sailor on 2013-01-05.
//  Copyright (c) 2013 Jonathan Sailor.
//


#import "MKExecutor.h"
#import "../arc.h"

static NSFileHandle* devnull = nil;


@implementation MKExecutor

+(void)initialize
{
    devnull = [NSFileHandle fileHandleWithNullDevice];
}

+(void)spawnCommand:(NSString*)cmd
{
    MKExecutor* exec = maybe_autorelease([[MKExecutor alloc] init]);
    [NSThread detachNewThreadSelector:@selector(inThread:) toTarget:exec withObject:cmd];
}

-(void)inThread:(NSString*)cmd
{
    @autoreleasepool {
        NSTask* tsk = maybe_autorelease([[NSTask alloc] init]);
        @try {
            [tsk setStandardInput:devnull];
            [tsk setStandardOutput:devnull];
            [tsk setLaunchPath:@"/bin/sh"];
            [tsk setArguments:[NSArray arrayWithObjects:@"-c", cmd, nil]];
            [tsk launch];
            [tsk waitUntilExit];
            int status = [tsk terminationStatus];
            if (status != 0)
                NSLog(@"Command '%@' failed with exit code %d", cmd, status);
        }
        @catch (NSException* exception) {
            NSLog(@"Throwing away exception when launching command '%@': %@", cmd, exception);
        }
    }
}

@end

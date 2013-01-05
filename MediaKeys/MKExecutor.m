//
//  MKExecutor.m
//  MediaKeys
//
//  Created by Jonathan Sailor on 2013-01-05.
//  Copyright (c) 2013 Jonathan Sailor.
//


#import "MKExecutor.h"


static MKExecutor* theExecutor = nil;


@implementation MKExecutor

+(MKExecutor*)executor
{
    if (theExecutor == nil)
        theExecutor = [[MKExecutor alloc] init];
    return theExecutor;
}

-(id)init
{
    [super init];
    devnull = [NSFileHandle fileHandleWithNullDevice];
    return self;
}

-(void)runCommand:(NSString*)cmd
{
    [NSThread detachNewThreadSelector:@selector(inThread:) toTarget:self withObject:cmd];
}

-(void)inThread:(NSString*)cmd
{
    @autoreleasepool {
        NSTask* tsk = [[NSTask alloc] init];
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
        @finally {
            [tsk release];
        }
    }
}

@end

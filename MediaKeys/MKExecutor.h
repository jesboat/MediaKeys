//
//  MKExecutor.h
//  MediaKeys
//
//  Created by Jonathan Sailor on 2013-01-05.
//  Copyright (c) 2013 Jonathan Sailor.
//


#import <Foundation/Foundation.h>


@interface MKExecutor : NSObject {
    NSFileHandle* devnull;
}

+(MKExecutor*)executor;

-(void)runCommand:(NSString*)cmd;

@end

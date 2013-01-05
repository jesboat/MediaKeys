//
//  arc.h
//  MediaKeys
//
//  Created by Jonathan Sailor on 2013-01-05.
//  Copyright (c) 2013 Jonathan Sailor.
//

#pragma once

inline static id identity_function(id obj) {
    return obj;
}

#if __has_feature(objc_arc)
# define maybe_autorelease(obj) (identity_function(obj))
#else
# define maybe_autorelease(obj) ([(obj) autorelease])
#endif


//
//  Debuglog.h
//  SpeedDating
//
//  Created by Lubos Ilcik on 4/6/14.
//  Copyright (c) 2014 Lubos Ilcik. All rights reserved.
//

#ifndef GCRFT_Debuglog_h
#define GCRFT_Debuglog_h

#define DEBUGLOG YES

#ifdef DEBUG
#define DBLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define DBLog(...) do { } while (0)
#endif

#endif

//
//  UserSettings.h
//  Tasks
//
//  Created by Lubos Ilcik on 1/12/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import <Foundation/Foundation.h>

enum Order { ALPHABETICAL, CHRONOLOGICAL};

@interface UserSettings : NSObject

+(void)setNotificationsEnabled:(BOOL)notificationsEnabled;

+(BOOL)notificationsEnabled;

+(void)setTasksOrder:(enum Order)tasksOrder;

+(enum Order)tasksOrder;

@end

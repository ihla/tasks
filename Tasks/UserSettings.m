//
//  UserSettings.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/12/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "UserSettings.h"

static NSString * const NOTIFICATIONS = @"notifications";
static NSString * const ENABLED = @"on";
static NSString * const DISABLED = @"off";

static NSString * const TASK_ORDER = @"taskOrder";
static NSString * const ALPHABETICAL_ORDER = @"alphabetical";
static NSString * const CHRONOLOGICAL_ORDER = @"chronological";

@implementation UserSettings

+(void)setNotificationsEnabled:(BOOL)notificationsEnabled {
    NSString *enabled = notificationsEnabled ? ENABLED : DISABLED;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:enabled forKey:NOTIFICATIONS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)notificationsEnabled {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL enabled = [[userDefaults objectForKey:NOTIFICATIONS] isEqualToString:ENABLED];
    return enabled;
}

+(void)setTasksOrder:(enum Order)tasksOrder {
    NSString *order = tasksOrder == ALPHABETICAL ? ALPHABETICAL_ORDER : CHRONOLOGICAL_ORDER;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:order forKey:TASK_ORDER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(enum Order)tasksOrder {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    enum Order order = [[userDefaults objectForKey:TASK_ORDER] isEqualToString:CHRONOLOGICAL_ORDER] ? CHRONOLOGICAL : ALPHABETICAL;
    return order;
}

+(NSString*)taskOrderKey {
    return TASK_ORDER;
}

+(NSString*)notificationsEnabledKey {
    return NOTIFICATIONS;
}

@end

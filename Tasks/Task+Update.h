//
//  Task+Update.h
//  Tasks
//
//  Created by Lubos Ilcik on 1/13/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "Task.h"

@interface Task (Update)

- (void)updateWithComplete:(BOOL)complete;
- (void) updateWithName:(NSString *)name category:(TaskCategory *)category date:(NSDate *)date;

@end

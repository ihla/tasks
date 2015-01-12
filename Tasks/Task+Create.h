//
//  Task+Create.h
//  Tasks
//
//  Created by Lubos Ilcik on 1/12/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "Task.h"

@interface Task (Create)

+ (Task *) taskWithName:(NSString *)name category:(TaskCategory *)category inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Task *) taskWithName:(NSString *)name category:(TaskCategory *)category date:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context;

@end

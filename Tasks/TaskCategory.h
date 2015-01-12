//
//  TaskCategory.h
//  Tasks
//
//  Created by Lubos Ilcik on 1/12/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface TaskCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface TaskCategory (CoreDataGeneratedAccessors)

- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end

//
//  Task+Create.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/12/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "Task+Create.h"

@implementation Task (Create)

+ (Task *) taskWithName:(NSString *)name category:(TaskCategory *)category inManagedObjectContext:(NSManagedObjectContext *)context {
    return [self taskWithName:name category:category date:nil inManagedObjectContext:context];
}

+ (Task *) taskWithName:(NSString *)name category:(TaskCategory *)category date:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context {
    Task *task = nil;
    
    if ([name length] && category) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            //TODO handle error
        } else if (![matches count]) {
            task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
            task.name = name;
            task.category = category;
            task.due = date;
            if (date) {
                task.notificationEnabled = [NSNumber numberWithBool:YES];
            } else {
                task.notificationEnabled = [NSNumber numberWithBool:NO];
            }
            task.complete = [NSNumber numberWithBool:NO];
        } else {
            task = [matches lastObject];
        }
    }
    
    return task;
}

@end

//
//  Task+Update.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/13/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "Task+Update.h"
#import "TaskCategory.h"

@implementation Task (Update)

- (void)updateWithComplete:(BOOL)complete {
    self.complete = [NSNumber numberWithBool:complete];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        //we have an error!
        NSLog(@"%@", error);
    }
}

- (void) updateWithName:(NSString *)name category:(TaskCategory *)category date:(NSDate *)date {
    BOOL nameChanged = ![self.name isEqualToString:name];
    BOOL categoryChanged = !(self.category.name == category.name && self.category.color == category.color);
    BOOL dueChanged = (self.due && ![self.due isEqualToDate:date]) || (!self.due && date);
    if (nameChanged || categoryChanged || dueChanged) {
        if (nameChanged) self.name = name;
        if (categoryChanged) self.category = category;
        if (dueChanged) self.due = date;

        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            //we have an error!
            NSLog(@"%@", error);
        }
    }
}

@end

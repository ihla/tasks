//
//  TaskCategory+Retrieve.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/12/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "TaskCategory+Retrieve.h"

@implementation TaskCategory (Retrieve)

+ (TaskCategory *) retrieveCategoryWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context {
    TaskCategory *category = nil;
    
    if ([name length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TaskCategory"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            //TODO handle error
        } else if (![matches count]) {
            // not existing yet
        } else {
            category = [matches lastObject];
        }
    }
    return category;
}

@end
